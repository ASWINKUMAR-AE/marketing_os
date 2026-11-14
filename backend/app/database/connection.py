"""
XAMPP MySQL Database Connection and Pool Management for ZetHub Marketing OS
Supports safe reconnection, timeouts, parameterized queries, and transaction management.
"""

import os
import datetime
from contextlib import contextmanager
import pymysql
import pymysql.cursors
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".env"))

DB_HOST = os.getenv("MYSQL_HOST", "127.0.0.1")
DB_PORT = int(os.getenv("MYSQL_PORT", 3306))
DB_USER = os.getenv("MYSQL_USER", "root")
DB_PASS = os.getenv("MYSQL_PASSWORD", "")
DB_NAME = os.getenv("MYSQL_DATABASE", "zethub_marketing_os")

# Telemetry tracking for Admin Dashboard
_last_successful_connection = None
_latest_database_error = None


def get_connection_params():
    """Returns database connection parameters dictionary."""
    return {
        "host": DB_HOST,
        "port": DB_PORT,
        "user": DB_USER,
        "password": DB_PASS,
        "database": DB_NAME,
        "charset": "utf8mb4",
        "cursorclass": pymysql.cursors.DictCursor,
        "connect_timeout": 5,
        "read_timeout": 15,
        "write_timeout": 15,
        "autocommit": True
    }


def get_db_connection():
    """
    Returns a fresh PyMySQL connection configured with timeouts and UTF-8 charset.
    Maintains compatibility with all existing endpoints.
    """
    global _last_successful_connection, _latest_database_error
    try:
        conn = pymysql.connect(**get_connection_params())
        _last_successful_connection = datetime.datetime.now().isoformat()
        return conn
    except Exception as e:
        _latest_database_error = str(e)
        raise e


@contextmanager
def get_db_cursor():
    """Context manager that yields a cursor and safely closes connection."""
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            yield cursor
    finally:
        conn.close()


@contextmanager
def transaction():
    """
    Context manager providing safe transaction management with commit and rollback.
    """
    global _last_successful_connection, _latest_database_error
    params = get_connection_params()
    params["autocommit"] = False
    conn = pymysql.connect(**params)
    _last_successful_connection = datetime.datetime.now().isoformat()
    try:
        with conn.cursor() as cursor:
            yield cursor
        conn.commit()
    except Exception as e:
        conn.rollback()
        _latest_database_error = str(e)
        raise e
    finally:
        conn.close()


def execute_query(sql: str, params: tuple = None):
    """Executes a parameterized SELECT query and returns all rows."""
    with get_db_cursor() as cursor:
        cursor.execute(sql, params or ())
        return cursor.fetchall()


def execute_one(sql: str, params: tuple = None):
    """Executes a parameterized SELECT query and returns a single row."""
    with get_db_cursor() as cursor:
        cursor.execute(sql, params or ())
        return cursor.fetchone()


def get_database_health():
    """
    Comprehensive diagnostics for Section 7 Admin Dashboard:
    Returns status, version, total tables, datadir, last connection, and errors.
    """
    global _last_successful_connection, _latest_database_error
    try:
        conn = get_db_connection()
        with conn.cursor() as cursor:
            cursor.execute("SELECT VERSION()")
            version = cursor.fetchone()["VERSION()"]
            
            cursor.execute("SELECT @@datadir, @@port")
            row = cursor.fetchone()
            datadir = row.get("@@datadir", "")
            port = row.get("@@port", DB_PORT)
            
            cursor.execute("SHOW TABLES")
            tables = [list(r.values())[0] for r in cursor.fetchall()]
            
            _last_successful_connection = datetime.datetime.now().isoformat()
            
        conn.close()
        return {
            "status": "connected",
            "database": DB_NAME,
            "host": DB_HOST,
            "port": port,
            "server_version": version,
            "data_directory": datadir,
            "total_tables": len(tables),
            "tables": tables,
            "last_successful_connection": _last_successful_connection,
            "latest_database_error": _latest_database_error,
            "engine": "XAMPP MySQL / MariaDB"
        }
    except Exception as e:
        _latest_database_error = str(e)
        return {
            "status": "disconnected",
            "database": DB_NAME,
            "host": DB_HOST,
            "port": DB_PORT,
            "server_version": "unknown",
            "data_directory": "unknown",
            "total_tables": 0,
            "tables": [],
            "last_successful_connection": _last_successful_connection,
            "latest_database_error": _latest_database_error,
            "engine": "XAMPP MySQL / MariaDB"
        }
