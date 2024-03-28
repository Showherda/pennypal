import pandas as pd

ahmad = pd.read_csv('ahmad.csv', sep=';')
bryan = pd.read_csv('bryan.csv', sep=';')
charles = pd.read_csv('charles.csv', sep=';')
danish = pd.read_csv('danish.csv', sep=';')
emily = pd.read_csv('emily.csv', sep=';')

# drop transaction id column
ahmad.drop(columns=['transaction_id'], inplace=True)
bryan.drop(columns=['transaction_id'], inplace=True)
charles.drop(columns=['transaction_id'], inplace=True)
danish.drop(columns=['transaction_id'], inplace=True)
emily.drop(columns=['transaction_id'], inplace=True)

# add user id column
ahmad['user_id'] = 1
bryan['user_id'] = 2
charles['user_id'] = 3
danish['user_id'] = 4
emily['user_id'] = 5

def fix_data(s):
    months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    s=s.split('-')
    y='20'+s[2]
    m=(2-len(str(months.index(s[1])+1)))*'0'+str(months.index(s[1])+1)
    d=(2-len(str(s[0])))*'0'+str(s[0])
    return y+'-'+m+'-'+d

# fix date column
ahmad['date'] = ahmad['date'].map(lambda x:fix_data(x))
bryan['date'] = bryan['date'].map(lambda x:fix_data(x))
charles['date'] = charles['date'].map(lambda x:fix_data(x))
danish['date'] = danish['date'].map(lambda x:fix_data(x))
emily['date'] = emily['date'].map(lambda x:fix_data(x))

# add amount column
ahmad['withdrawal_amt'] = ahmad['withdrawal_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
ahmad['deposit_amt'] = ahmad['deposit_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
bryan['withdrawal_amt'] = bryan['withdrawal_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
bryan['deposit_amt'] = bryan['deposit_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
charles['withdrawal_amt'] = charles['withdrawal_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
charles['deposit_amt'] = charles['deposit_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
danish['withdrawal_amt'] = danish['withdrawal_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
danish['deposit_amt'] = danish['deposit_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
emily['withdrawal_amt'] = emily['withdrawal_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))
emily['deposit_amt'] = emily['deposit_amt'].astype(str).map(lambda x: x.replace(',', '').replace(' ',''))

ahmad['withdrawal_amt'] = ahmad['withdrawal_amt'].astype(float)
ahmad['deposit_amt'] = ahmad['deposit_amt'].astype(float)
bryan['withdrawal_amt'] = bryan['withdrawal_amt'].astype(float)
bryan['deposit_amt'] = bryan['deposit_amt'].astype(float)
charles['withdrawal_amt'] = charles['withdrawal_amt'].astype(float)
charles['deposit_amt'] = charles['deposit_amt'].astype(float)
danish['withdrawal_amt'] = danish['withdrawal_amt'].astype(float)
danish['deposit_amt'] = danish['deposit_amt'].astype(float)
emily['withdrawal_amt'] = emily['withdrawal_amt'].astype(float)
emily['deposit_amt'] = emily['deposit_amt'].astype(float)

ahmad['withdrawal_amt'] = ahmad['withdrawal_amt'].fillna(0)
ahmad['deposit_amt'] = ahmad['deposit_amt'].fillna(0)
bryan['withdrawal_amt'] = bryan['withdrawal_amt'].fillna(0)
bryan['deposit_amt'] = bryan['deposit_amt'].fillna(0)
charles['withdrawal_amt'] = charles['withdrawal_amt'].fillna(0)
charles['deposit_amt'] = charles['deposit_amt'].fillna(0)
danish['withdrawal_amt'] = danish['withdrawal_amt'].fillna(0)
danish['deposit_amt'] = danish['deposit_amt'].fillna(0)
emily['withdrawal_amt'] = emily['withdrawal_amt'].fillna(0)
emily['deposit_amt'] = emily['deposit_amt'].fillna(0)

ahmad['amount'] = ahmad['deposit_amt']-ahmad['withdrawal_amt']
bryan['amount'] = bryan['deposit_amt']-bryan['withdrawal_amt']
charles['amount'] = charles['deposit_amt']-charles['withdrawal_amt']
danish['amount'] = danish['deposit_amt']-danish['withdrawal_amt']
emily['amount'] = emily['deposit_amt']-emily['withdrawal_amt']

ahmad.drop(columns=['deposit_amt', 'withdrawal_amt'], inplace=True)
bryan.drop(columns=['deposit_amt', 'withdrawal_amt'], inplace=True)
charles.drop(columns=['deposit_amt', 'withdrawal_amt'], inplace=True)
danish.drop(columns=['deposit_amt', 'withdrawal_amt'], inplace=True)
emily.drop(columns=['deposit_amt', 'withdrawal_amt'], inplace=True)

# fill missing values
ahmad['description'] = ahmad['description'].fillna('')
bryan['description'] = bryan['description'].fillna('')
charles['description'] = charles['description'].fillna('')
danish['description'] = danish['description'].fillna('')
emily['description'] = emily['description'].fillna('')
ahmad['payment_method'] = ahmad['payment_method'].fillna('Others')
bryan['payment_method'] = bryan['payment_method'].fillna('Others')
charles['payment_method'] = charles['payment_method'].fillna('Others')
danish['payment_method'] = danish['payment_method'].fillna('Others')
emily['payment_method'] = emily['payment_method'].fillna('Others')

# merge all data
data = pd.concat([ahmad, bryan, charles, danish, emily], ignore_index=True)
data.to_csv('combined_data.csv', index=False, sep=';')

print(ahmad.head())

# insert into transactions table
# f=open('data/combined_data.csv','r')
# for line in f.readlines()[1:]:
#     line=line.split(';')
#     transaction={}
#     transaction['date']=line[0]
#     transaction['transaction_detail']=line[1]
#     transaction['description']=line[2]
#     transaction['transaction_category']=line[3]
#     transaction['payment_method']=line[4]
#     transaction['user_id']=line[5]
#     transaction['amount']=line[6]

#     conn = connection_pool.getconn()
#     if transactions.insert_transaction(conn, transaction):
#         print('Transaction inserted')
#     else:
#         print('Transaction failed to insert')
#         connection_pool.putconn(conn)
#         break
#     connection_pool.putconn(conn)

# insert users
# users.insert_user(connection_pool.getconn(), {'first_name': 'ahmad', 'last_name': '', 'email': 'ahmad@test.com', 'password': 'test'})
# users.insert_user(connection_pool.getconn(), {'first_name': 'bryan', 'last_name': '', 'email': 'bryan@test.com', 'password': 'test'})
# users.insert_user(connection_pool.getconn(), {'first_name': 'charles', 'last_name': '', 'email': 'charles@test.com', 'password': 'test'})
# users.insert_user(connection_pool.getconn(), {'first_name': 'danish', 'last_name': '', 'email': 'danish@test.com', 'password': 'test'})
# users.insert_user(connection_pool.getconn(), {'first_name': 'emily', 'last_name': '', 'email': 'emily@test.com', 'password': 'test'})

# insert transaction categories
# from pypika import PostgreSQLQuery, Table
# conn = connection_pool.getconn()
# cursor = conn.cursor()
# query = 'SELECT DISTINCT transaction_category FROM transactions;'
# cursor.execute(query)
# result = cursor.fetchall()
# cursor.close()
# for i in result:
#     transaction_category = {
#         'transaction_category': i[0]
#     }
#     print(transaction_category)
#     transaction_categories.insert_transaction_category(conn, transaction_category)
# connection_pool.putconn(conn)

# insert transaction details
# from pypika import PostgreSQLQuery, Table
# conn = connection_pool.getconn()
# cursor = conn.cursor()
# query = 'SELECT DISTINCT transaction_detail FROM transactions;'
# cursor.execute(query)
# result = cursor.fetchall()
# cursor.close()
# for i in result:
#     transaction_detail = {
#         'transaction_detail': i[0]
#     }
#     print(transaction_detail)
#     transaction_details.insert_transaction_detail(conn, transaction_detail)
# connection_pool.putconn(conn)