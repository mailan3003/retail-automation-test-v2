import os
import pyodbc

DATABASE_CONFIG_DRIVER = os.environ.get('DATABASE_CONFIG_DRIVER', 'SQL Server')

DATABASE_CONFIG = {
    'server': '103.252.0.202,6002',
    'database': 'KiotVietShard40',
    'username': 'retail_app',
    'password': 'LnqxffeJulNvQi6u',
    'driver': DATABASE_CONFIG_DRIVER
}

DATABASE_CONFIG_PROMOTION = {
    'server': '103.252.0.202,6002',
    'database': 'KiotVietPromotion',
    'username': 'retail_app',
    'password': 'LnqxffeJulNvQi6u',
    'driver': DATABASE_CONFIG_DRIVER
}

def db_connection():
    conn_str = (
        f"DRIVER={DATABASE_CONFIG['driver']};"
        f"SERVER={DATABASE_CONFIG['server']};"
        f"DATABASE={DATABASE_CONFIG['database']};"
        f"UID={DATABASE_CONFIG['username']};"
        f"PWD={DATABASE_CONFIG['password']};"
        f"TrustServerCertificate=yes;"
    )
    conn = pyodbc.connect(conn_str)
    return conn


def execute_query(query, *params):
    conn = db_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    conn.commit()
    cursor.close()
    conn.close()


def fetch_one(query, *params):
    conn = db_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result


def fetch_all(query, *params):
    conn = db_connection()
    cursor = conn.cursor()
    cursor.execute(query, params)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result
