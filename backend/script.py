import psycopg2.pool
from decouple import config
from fastapi import FastAPI
from fastapi.responses import JSONResponse, FileResponse
from PIL import Image
import io
from openai import OpenAI
from pydantic import BaseModel
import uvicorn
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
import os

# database imports
from database import transactions, conversations, users, transaction_categories, transaction_details, payment_methods, roles

# Load database credentials from .env file
dbname = config('DB_NAME')
user = config('DB_USER')
password = config('DB_PASSWORD')
host = config('DB_HOST')
port = config('DB_PORT')

# connection pool
connection_pool = psycopg2.pool.SimpleConnectionPool(
    minconn=1,
    maxconn=5,
    dbname=dbname,
    user=user,
    password=password,
    host=host,
    port=port
)

# FastAPI instance
app = FastAPI()

# OpenAI instance
openai = OpenAI(
    api_key = config('OPENAI_API_KEY')
)

# message response
class MessageResponse(BaseModel):
    user_id: int
    content: str
    role: str = "assistant"

# incoming message
class IncomingMessage(BaseModel):
    user_id: int
    content: str
    role: str = "user"

def check_time(message: IncomingMessage):
    global openai
    # determine whether the question is about the past or the future with OpenAI
    prompt = [{"role": "user", "content": "determine whether the question is about the past or the future "+message.content+" reply only 0 for past and only 1 for future"}]
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return int(response.choices[0].message.content)

def check_query_needed(message: IncomingMessage):
    global openai
    # check if the message requires queries
    prompt = [{"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'. check if an SQL query is necessary to respond to the following: "+message.content+" reply only 0 for no and only 1 for yes"}]
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return int(response.choices[0].message.content)

def generate_query_past(message: IncomingMessage, graph_needed: int):
    global openai
    # generate the query
    prompt = [
        {"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'. generate only a PostgreSQL query string to respond to the following: "+message.content},
        {"role": "user", "content": "if the question asks about a specific product, you must check if the product exists in any of the columns: 'transaction_detail', 'description', 'transaction_category'. dont use equality. you must check if the term exists in any of these columns"},
        {"role": "user", "content": "the query must be generated for user_id="+str(message.user_id)},
        {"role": "user", "content": "dont include any imports. dont include any comments, suggestions, or explanations. dont include any formatting symbols"},
        {"role": "user", "content": "generate only code and nothing else."}
    ]
    if graph_needed == 1:
        prompt.append({"role": "user", "content": "you must generate a query that returns the necessary data for a graph."})
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return response.choices[0].message.content

def generate_query_future(message: IncomingMessage, graph_needed = 1):
    global openai
    # generate the query
    prompt = [
        {"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'. generate only a PostgreSQL query string to respond to the following: "+message.content},
        {"role": "user", "content": "the database holds data from the past. you must only query past data. do not query for present or future data"},
        {"role": "user", "content": "if the question asks about a specific product, you must check if the product exists in any of the columns: 'transaction_detail', 'description', 'transaction_category'. dont use equality. you must check if the term exists in any of these columns"},
        {"role": "user", "content": "the query must be generated for user_id="+str(message.user_id)},
        {"role": "user", "content": "dont include any imports. dont include any comments, suggestions, or explanations. dont include any formatting symbols"},
        {"role": "user", "content": "generate only code and nothing else."}
    ]
    if graph_needed == 1:
        prompt.append({"role": "user", "content": "you must generate a query that returns the necessary data for a graph."})
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return response.choices[0].message.content

def check_graph_needed(message: IncomingMessage):
    global openai
    # determine if a graph is needed to answer the question
    prompt = [{"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'. determine if a graph is needed to answer the following: "+message.content+" reply only 0 for no and only 1 for yes"}]
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return int(response.choices[0].message.content)

def generate_response_from_query(message: IncomingMessage, result: list):
    global openai
    # create a response
    prompt = [{"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'. The following question was asked: "+message.content+" the following output was generated by database query: "+str(result)+". provide a response to the user.make it brief."}]
    try:
        response = openai.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=prompt,
            max_tokens=300
        )
        return response.choices[0].message.content
    except Exception as e:
        return str(result)[:300]+"... end of result."

def generate_response_no_query(message: IncomingMessage):
    global openai
    # query isnt needed
    prompt = [{"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'. The following question was asked: "+message.content+" no database query is necessary. provide a response to the user. make it brief."}]
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return response.choices[0].message.content

def check_graph_needed(message: IncomingMessage):
    global openai
    # determine if a graph is needed to answer the question
    prompt = [{"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'. determine if a graph is needed to answer the following: "+message.content+" reply only 0 for no and only 1 for yes"}]
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return int(response.choices[0].message.content)

def generate_graph_code_past(query: str, message: IncomingMessage):
    global openai
    # generate the graph generation code
    prompt = [
        {"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'."},
        {"role": "user", "content": "generate only a Python matplotlib code snippet to generate a graph to answer the following: "+message.content+" the following PostgreSQL query was generated: "+query},
        {"role": "user", "content": "determine which type of graph is most appropriate."},
        {"role": "user", "content": "you can choose to ignore unnecessary columns from the query string."},
        {"role": "user", "content": "the code must store the graph at data/"+str(message.user_id)+".png"},
        {"role": "user", "content": "these are the imports already specified in the code: import pandas as pd; import numpy as np; import matplotlib.pyplot as plt"},
        {"role": "user", "content": "the data is stored as a python list of tuples called result"},
        {"role": "user", "content": "dont include any imports that are already defined, dont include any comments, suggestions, or explanations. dont include any formatting symbols"},
        {"role": "user", "content": "generate only code and nothing else."}
    ]
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return response.choices[0].message.content

def generate_graph_code_future(query: str, message: IncomingMessage):
    global openai
    # generate the graph generation code
    prompt = [
        {"role": "user", "content": "the messages are for a finance chatbot connected to a database. the database has a 'transactions' table with the columns: 'transaction_id', 'user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt'."},
        {"role": "user", "content": "generate code for a simple linear regression model to predict future values to answer the following: "+message.content+" the following PostgreSQL query was generated: "+query},
        {"role": "user", "content": "determine which type of graph is most appropriate."},
        {"role": "user", "content": "you can choose to ignore unnecessary columns from the query string."},
        {"role": "user", "content": "the code must store the graph at data/"+str(message.user_id)+".png"},
        {"role": "user", "content": "these are the imports already specified in the code: import pandas as pd; import numpy as np; import matplotlib.pyplot as plt;from sklearn.linear_model import LinearRegression"},
        {"role": "user", "content": "the data is stored as a python list of tuples called result"},
        {"role": "user", "content": "dont include any imports that are already defined, dont include any comments, suggestions, or explanations. dont include any formatting symbols"},
        {"role": "user", "content": "generate only code and nothing else."}
    ]
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=prompt,
        max_tokens=300
    )
    return response.choices[0].message.content

# incoming message endpoint
# def test():
#     message = IncomingMessage(user_id=1, content="what was my average grocery spending in the past three month?")
@app.post("/incoming-message")
async def incoming_message(message: IncomingMessage):
    # store message in database
    conn = connection_pool.getconn()
    conversations.insert_conversation(conn, message.model_dump())
    connection_pool.putconn(conn)

    # determine whether the question is about the past or the future with OpenAI
    time = check_time(message)
    print("time = "+str(time))

    # past
    if time == 0:
        # check if the message requires queries
        query_needed = check_query_needed(message)
        print("query_needed = "+str(query_needed))

        # if a query is necessary
        if query_needed == 1:
            # determine if a graph is needed to answer the question
            graph_needed = check_graph_needed(message)
            print("graph_needed = "+str(graph_needed))
            
            # generate the query
            query = generate_query_past(message, graph_needed)
            print("query = "+query)
            
            # execute the query
            conn = connection_pool.getconn()
            cursor = conn.cursor()
            cursor.execute(query)
            result = cursor.fetchall()
            print("result = "+str(result))
            cursor.close()
            connection_pool.putconn(conn)

            # if a graph is needed
            if graph_needed == 1:
                # generate the graph generation code
                graph_code = generate_graph_code_past(query, message)
                print("graph_code = "+graph_code)

                # execute the graph code
                exec(graph_code)

            # create a response
            answer = generate_response_from_query(message, result)

        # query isnt needed
        else:
            answer = generate_response_no_query(message)
    
    # future
    else:
        # check if the message requires queries
        query_needed = check_query_needed(message)
        print("query_needed = "+str(query_needed))

        # if a query is necessary
        if query_needed == 1:
            # determine if a graph is needed to answer the question
            graph_needed = check_graph_needed(message)
            print("graph_needed = "+str(graph_needed))
            
            # generate the query
            query = generate_query_future(message, graph_needed)
            print("query = "+query)
            
            # execute the query
            conn = connection_pool.getconn()
            cursor = conn.cursor()
            cursor.execute(query)
            result = cursor.fetchall()
            print("result = "+str(result))
            cursor.close()
            connection_pool.putconn(conn)

            # if a graph is needed
            if graph_needed == 1:
                # generate the graph generation code
                graph_code = generate_graph_code_future(query, message)
                print("graph_code = "+graph_code)

                # execute the graph code
                exec(graph_code)

            # create a response
            answer = generate_response_from_query(message, result)

        # query isnt needed
        else:
            answer = generate_response_no_query(message)
    print(answer)
    conn = connection_pool.getconn()
    conversations.insert_conversation(conn, MessageResponse(user_id=message.user_id, content=answer).model_dump())
    connection_pool.putconn(conn)

    return JSONResponse(content={"content": answer, "graph-needed": graph_needed, "user_id": message.user_id})

@app.get("/get-graph/{user_id}")
async def get_graph(user_id: int):
    return FileResponse("data/"+str(user_id)+".png")

if __name__ == '__main__':
    uvicorn.run("script:app", host="0.0.0.0", port=8000)
    # test()