from pypika import PostgreSQLQuery, Table

# need to test
def insert_conversation(conn, conversation):
    conversations = Table('conversations')
    try:
        cursor = conn.cursor()
        query =(
             PostgreSQLQuery
            .into(conversations)
            .columns('user_id', 'role', 'content')
            .insert(conversation['user_id'], conversation['role'], conversation['content'])
        )
        query = query.get_sql()
        print(query)
        cursor.execute(query)
        conn.commit()
        cursor.close()
        return True
    except Exception as e:
        print(e)
        return False

# need to test 
def get_conversations(conn):
    conversations = Table('conversations')
    try:
        cursor = conn.cursor()
        query = (
            PostgreSQLQuery
            .from_(conversations)
            .select('*')
        )
        query = query.get_sql()
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        return result
    except Exception as e:
        print(e)
        return False