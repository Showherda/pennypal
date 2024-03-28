from pypika import PostgreSQLQuery, Table

def insert_transaction_detail(conn, transaction_detail):
    transaction_details = Table('transaction_details')
    try:
        cursor = conn.cursor()
        query =(
             PostgreSQLQuery
            .into(transaction_details)
            .columns('transaction_detail')
            .insert(transaction_detail['transaction_detail'])
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
def get_transaction_details(conn):
    transaction_details = Table('transaction_details')
    try:
        cursor = conn.cursor()
        query = (
            PostgreSQLQuery
            .from_(transaction_details)
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