import mysql.connector
from flask import current_app, g

def get_connection():
    if "db" not in g:
        cfg = current_app.config
        g.db = mysql.connector.connect(
            host=cfg["MYSQL_HOST"], port=cfg["MYSQL_PORT"],
            user=cfg["MYSQL_USER"], password=cfg["MYSQL_PASSWORD"],
            database=cfg["MYSQL_DATABASE"], charset="utf8mb4",
            autocommit=False, connection_timeout=5,
        )
    return g.db

def close_connection(error=None):
    connection = g.pop("db", None)
    if connection is not None:
        try:
            connection.rollback()
        finally:
            connection.close()
