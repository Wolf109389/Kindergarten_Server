import mysql.connector
from flask import Flask, jsonify
from werkzeug.exceptions import HTTPException
from app.config import load_config
from app.db import close_connection
from app.errors import APIError

def create_app(test_config=None):
    app = Flask(__name__)
    app.config.update(load_config())
    if test_config:
        app.config.update(test_config)
    app.json.ensure_ascii = False
    app.teardown_appcontext(close_connection)

    from app.controller.api import api
    app.register_blueprint(api)

    @app.get("/")
    def index():
        return jsonify(project="Дитсадок — лабораторна 4, варіант 34", api="/api", health="/api/health")

    @app.errorhandler(APIError)
    def api_error(error):
        return jsonify(error=error.message), error.status

    @app.errorhandler(mysql.connector.Error)
    def db_error(error):
        if error.errno == 1062:
            return jsonify(error="Запис із таким унікальним значенням уже існує"), 409
        if error.errno == 1451:
            return jsonify(error="Запис використовується в інших таблицях. Спочатку видали залежні записи"), 409
        if error.errno == 1452:
            return jsonify(error="Пов’язаний запис не існує. Перевір зовнішні ключі"), 409
        app.logger.error("Database error: %s", error.errno)
        if error.errno in (1045, 1049, 2002, 2003, 2005, 2006, 2013, 2055):
            return jsonify(error="Немає підключення до MySQL. Перевір сервер, базу та налаштування .env"), 503
        return jsonify(error="Помилка роботи з базою даних"), 500

    @app.errorhandler(HTTPException)
    def http_error(error):
        return jsonify(error=error.description), error.code

    return app
