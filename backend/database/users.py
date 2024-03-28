from pypika import PostgreSQLQuery, Table

def insert_user(conn, user):
    users = Table('users')
    try:
        cursor = conn.cursor()
        query =(
             PostgreSQLQuery
            .into(users)
            .columns('first_name', 'last_name', 'email', 'password')
            .insert(user['first_name'], user['last_name'], user['email'], user['password'])
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