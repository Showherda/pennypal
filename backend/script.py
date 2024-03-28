import psycopg2.pool
from decouple import config

# database imports
from database import transactions, users, transaction_categories

# Load database credentials from .env file
dbname = config('DB_NAME')
user = config('DB_USER')
password = config('DB_PASSWORD')
host = config('DB_HOST')
port = config('DB_PORT')

# Create a connection pool
connection_pool = psycopg2.pool.SimpleConnectionPool(
    minconn=1,
    maxconn=5,
    dbname=dbname,
    user=user,
    password=password,
    host=host,
    port=port
)

