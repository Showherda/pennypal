from pypika import PostgreSQLQuery, Table

def insert_role(conn, role):
    roles = Table('roles')
    try:
        cursor = conn.cursor()
        query =(
             PostgreSQLQuery
            .into(roles)
            .columns('role')
            .insert(role['role'])
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
def get_roles(conn):
    roles = Table('roles')
    try:
        cursor = conn.cursor()
        query = (
            PostgreSQLQuery
            .from_(roles)
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