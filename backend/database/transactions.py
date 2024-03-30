from pypika import PostgreSQLQuery, Table

def insert_transaction(conn, transaction):
    transactions = Table('transactions')
    try:
        cursor = conn.cursor()
        query =(
             PostgreSQLQuery
            .into(transactions)
            .columns('user_id', 'date', 'transaction_detail', 'description', 'transaction_category', 'payment_method', 'withdrawal_amt', 'deposit_amt')
            .insert(transaction['user_id'], transaction['date'], transaction['transaction_detail'], transaction['description'], transaction['transaction_category'], transaction['payment_method'], transaction['withdrawal_amt'], transaction['deposit_amt'])
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