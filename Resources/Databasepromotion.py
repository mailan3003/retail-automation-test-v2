
import pyodbc

DATABASE_CONFIG_PROMOTION = {
    'server': '103.252.0.202,6000',
    'database': 'KiotVietPromotion',
    'username': 'retail_app',
    'password': 'LnqxffeJulNvQi6u',
    'driver': 'SQL Server'
}

def db_connection_promotion():
    conn_str = (
        f"DRIVER={DATABASE_CONFIG_PROMOTION['driver']};"
        f"SERVER={DATABASE_CONFIG_PROMOTION['server']};"
        f"DATABASE={DATABASE_CONFIG_PROMOTION['database']};"
        f"UID={DATABASE_CONFIG_PROMOTION['username']};"
        f"PWD={DATABASE_CONFIG_PROMOTION['password']}"
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