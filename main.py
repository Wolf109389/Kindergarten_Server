"""Звичайний запуск сервера після початкового налаштування через BAT."""
import os
from app import create_app

app = create_app()

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=int(os.getenv('APP_PORT', '5001')), debug=False)
