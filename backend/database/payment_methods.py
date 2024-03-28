from pypika import PostgreSQLQuery, Table

def insert_payment_method(conn, payment_method):
    payment_methods = Table('payment_methods')
    try:
        cursor = conn.cursor()
        query =(
             PostgreSQLQuery
            .into(payment_methods)
            .columns('payment_method')
            .insert(payment_method['payment_method'])
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
def get_payment_methods(conn):
    payment_methods = Table('payment_methods')
    try:
        cursor = conn.cursor()
        query = (
            PostgreSQLQuery
            .from_(payment_methods)
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