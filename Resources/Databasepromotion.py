import os
import pyodbc

DATABASE_CONFIG_DRIVER = os.environ.get('DATABASE_CONFIG_DRIVER', 'SQL Server')

DATABASE_CONFIG_PROMOTION = {
    'server': '103.252.0.202,6000',
    'database': 'KiotVietPromotion',
    'username': 'retail_app',
    'password': 'LnqxffeJulNvQi6u',
    'driver': DATABASE_CONFIG_DRIVER
}

DATABASE_CONFIG_MASTER = {
    'server': '103.252.0.202,6000',
    'database': 'KiotVietMaster',
    'username': 'retail_app',
    'password': 'LnqxffeJulNvQi6u',
    'driver': DATABASE_CONFIG_DRIVER
}
def db_connection_promotion():
    conn_str = (
        f"DRIVER={DATABASE_CONFIG_PROMOTION['driver']};"
        f"SERVER={DATABASE_CONFIG_PROMOTION['server']};"
        f"DATABASE={DATABASE_CONFIG_PROMOTION['database']};"
        f"UID={DATABASE_CONFIG_PROMOTION['username']};"
        f"PWD={DATABASE_CONFIG_PROMOTION['password']};"
        f"TrustServerCertificate=yes;"
    )
    conn = pyodbc.connect(conn_str)
    return conn

def db_connection_master():
    conn_str = (
        f"DRIVER={DATABASE_CONFIG_MASTER['driver']};"
        f"SERVER={DATABASE_CONFIG_MASTER['server']};"
        f"DATABASE={DATABASE_CONFIG_MASTER['database']};"
        f"UID={DATABASE_CONFIG_MASTER['username']};"
        f"PWD={DATABASE_CONFIG_MASTER['password']};"
        f"TrustServerCertificate=yes;"
    )
    conn = pyodbc.connect(conn_str)
    return conn



def execute_query_promotion(query, *params):
    conn = db_connection_promotion()
    cursor = conn.cursor()
    cursor.execute(query, params)
    conn.commit()
    cursor.close()
    conn.close()


def select_one_promotion(query, *params):
    conn = db_connection_promotion()
    cursor = conn.cursor()
    cursor.execute(query, params)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result


def fetch_all_promotion(query, *params):
    conn = db_connection_promotion()
    cursor = conn.cursor()
    cursor.execute(query, params)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result

def select_one_master(query, *params):
    conn = db_connection_master()
    cursor = conn.cursor()
    cursor.execute(query, params)
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result

def fetch_all_master(query, *params):
    conn = db_connection_master()
    cursor = conn.cursor()
    cursor.execute(query, params)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    return result