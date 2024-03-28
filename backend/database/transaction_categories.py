from pypika import PostgreSQLQuery, Table

def insert_transaction_category(conn, transaction_category):
    transaction_categories = Table('transaction_categories')
    try:
        cursor = conn.cursor()
        query =(
             PostgreSQLQuery
            .into(transaction_categories)
            .columns('transaction_id', 'transaction_category')
            .insert(transaction_category['transaction_id'], transaction_category['transaction_category'])
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
    
def get_transaction_categories(conn):
    transaction_categories = Table('transaction_categories')
    try:
        cursor = conn.cursor()
        query = (
            PostgreSQLQuery
            .from_(transaction_categories)
            .select('transaction_category')
        )
        query = query.get_sql()
        cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        return result
    except Exception as e:
        print(e)
        return False