"""First-run configuration and non-destructive database preparation."""
import argparse
import getpass
import json
import os
import re
import socket
import sys
import threading
import webbrowser
from pathlib import Path

import mysql.connector
from dotenv import dotenv_values, set_key

ROOT = Path(__file__).resolve().parent
ENV_FILE = ROOT / '.env'


def connect_options(config):
    return dict(host=config['MYSQL_HOST'], port=int(config['MYSQL_PORT']),
                user=config['MYSQL_USER'], password=config['MYSQL_PASSWORD'],
                charset='utf8mb4', connection_timeout=5)


def ask(prompt, default):
    return input(f'{prompt} [{default}]: ').strip() or str(default)


def validate_database_name(name):
    if not re.fullmatch(r'[A-Za-z0-9_]{1,64}', name):
        raise ValueError('Назва бази: лише латинські літери, цифри та знак _.')
    if name in {'mysql', 'sys', 'performance_schema', 'information_schema', 'music_player_db'}:
        raise ValueError('Обери базу дитсадка, наприклад kindergarten_lab3 або kindergarten_db.')


def prompt_config(defaults=None):
    defaults = defaults or {}
    print('\nПерше налаштування сервера «Дитсадок», варіант 34.')
    print('Введи дані свого MySQL. Enter залишає значення у квадратних дужках.')
    config = {
        'MYSQL_HOST': ask('Адреса MySQL', defaults.get('MYSQL_HOST', '127.0.0.1')),
        'MYSQL_PORT': ask('Порт MySQL', defaults.get('MYSQL_PORT', '3306')),
        'MYSQL_USER': ask('Користувач MySQL', defaults.get('MYSQL_USER', 'root')),
        'MYSQL_PASSWORD': getpass.getpass('Пароль MySQL (символи не відображаються): '),
        'APP_PORT': defaults.get('APP_PORT', '5001'),
    }
    if not 1 <= int(config['MYSQL_PORT']) <= 65535:
        raise ValueError('Порт має бути від 1 до 65535.')
    probe = mysql.connector.connect(**connect_options(config))
    try:
        cursor = probe.cursor()
        cursor.execute('SHOW DATABASES')
        existing = {row[0] for row in cursor.fetchall()}
        cursor.close()
    finally:
        probe.close()
    default_db = defaults.get('MYSQL_DATABASE')
    if not default_db:
        default_db = next((name for name in ['kindergarten_lab3', 'kindergarten_db'] if name in existing), 'kindergarten_lab3')
    print('Відомі бази дитсадка:', ', '.join(n for n in ['kindergarten_lab3', 'kindergarten_db'] if n in existing) or 'ще не створені')
    config['MYSQL_DATABASE'] = ask('База дитсадка', default_db)
    validate_database_name(config['MYSQL_DATABASE'])
    save_config(config)
    return config


def save_config(config):
    ENV_FILE.touch(exist_ok=True)
    for key, value in config.items():
        set_key(str(ENV_FILE), key, str(value), quote_mode='always')
    try:
        ENV_FILE.chmod(0o600)
    except OSError:
        pass


def prepare_database(config, seed_if_empty=True):
    """Create missing tables; never DROP, TRUNCATE, DELETE or overwrite rows."""
    from app.domain.schema import ENTITIES
    name = config['MYSQL_DATABASE']
    validate_database_name(name)
    connection = mysql.connector.connect(**connect_options(config))
    cursor = connection.cursor(buffered=True)
    changes = []
    try:
        cursor.execute('SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = %s', (name,))
        if cursor.fetchone() is None:
            cursor.execute(f'CREATE DATABASE `{name}` DEFAULT CHARACTER SET utf8mb4')
            changes.append('Створено базу ' + name)
        connection.database = name
        # Identifiers come from a validated DB name and the internal schema registry.
        sql = (ROOT / 'sql/01_ensure_schema.sql').read_text(encoding='utf-8')
        for statement in sql.split(';'):
            statement = statement.strip()
            if statement.startswith('CREATE TABLE IF NOT EXISTS'):
                cursor.execute(statement)
        cursor.execute("SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=%s AND TABLE_NAME='addresses' AND COLUMN_NAME='district'", (name,))
        if cursor.fetchone()[0] == 0:
            cursor.execute('ALTER TABLE addresses ADD COLUMN district VARCHAR(50) NULL AFTER city')
            changes.append('Додано необов’язкове поле addresses.district')
        for table, entity in ENTITIES.items():
            cursor.execute(f'SHOW COLUMNS FROM `{table}`')
            columns = {row[0] for row in cursor.fetchall()}
            expected = set(entity.fields) | set(entity.keys)
            missing = expected - columns
            if missing:
                raise ValueError(f'Таблиця {table}: відсутні поля {", ".join(sorted(missing))}. Потрібна схема лабораторної 3; наявні дані не видалялися.')
        counts = {}
        for table in ENTITIES:
            cursor.execute(f'SELECT COUNT(*) FROM `{table}`')
            counts[table] = cursor.fetchone()[0]
        if seed_if_empty and not any(counts.values()):
            seed = (ROOT / 'sql/02_seed_only_empty_database.sql').read_text(encoding='utf-8')
            for statement in seed.split(';'):
                if statement.strip():
                    cursor.execute(statement)
            connection.commit()
            changes.append('Порожню базу заповнено навчальними даними з лабораторної 3')
        # Existing partially populated databases remain as they are.
        connection.commit()
        return changes
    except Exception:
        connection.rollback()
        raise
    finally:
        cursor.close()
        connection.close()


def choose_port(preferred=5001):
    for port in range(preferred, min(preferred + 20, 65536)):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as probe:
            try:
                probe.bind(('127.0.0.1', port))
                return port
            except OSError:
                continue
    raise ValueError('Немає вільного локального порту. Закрий попередній сервер.')


def main():
    os.chdir(ROOT)
    parser = argparse.ArgumentParser()
    parser.add_argument('--configure', action='store_true')
    parser.add_argument('--no-browser', action='store_true')
    args = parser.parse_args()
    defaults = dict(dotenv_values(ENV_FILE)) if ENV_FILE.exists() else {}
    while True:
        try:
            config = prompt_config(defaults) if args.configure or not defaults else defaults
            changes = prepare_database(config)
            break
        except (mysql.connector.Error, ValueError) as error:
            if isinstance(error, mysql.connector.Error):
                messages = {1045: 'Неправильний користувач або пароль MySQL.',
                            2003: 'MySQL недоступний. Запусти службу MySQL і перевір адресу та порт.',
                            1044: 'Користувач не має прав доступу до вибраної бази.',
                            1142: 'Користувач не має прав створювати або змінювати таблиці.'}
                print('\n' + messages.get(error.errno, f'Помилка MySQL, код {error.errno}.'))
            else:
                print('\n' + str(error))
            if input('Ввести налаштування ще раз? [так/ні]: ').strip().lower() not in {'так','т','y','yes'}:
                return 1
            defaults = config if 'config' in locals() else defaults
            args.configure = True
    port = choose_port(int(config.get('APP_PORT', 5001)))
    config['APP_PORT'] = str(port)
    save_config(config)
    # Explicitly pass the selected values: stale shell variables must not select another DB.
    os.environ.update({key: str(value) for key, value in config.items() if value is not None})
    environment = {'name':'Дитсадок локально', 'values':[{'key':'base_url','value':f'http://127.0.0.1:{port}','enabled':True}], '_postman_variable_scope':'environment'}
    (ROOT/'postman/Local.postman_environment.json').write_text(json.dumps(environment, ensure_ascii=False, indent=2), encoding='utf-8')
    print('\nБаза:', config['MYSQL_DATABASE'])
    for message in changes:
        print(message)
    print(f'Перевірка: http://127.0.0.1:{port}/api/health')
    print(f'Працівники: http://127.0.0.1:{port}/api/employees')
    print('Postman: імпортуй колекцію й Local.postman_environment.json; вибери середовище «Дитсадок локально».')
    print('Щоб зупинити сервер, натисни Ctrl+C. Залиш це вікно відкритим.\n')
    from app import create_app
    if not args.no_browser:
        timer = threading.Timer(1.5, webbrowser.open, args=(f'http://127.0.0.1:{port}/api/health',))
        timer.daemon = True
        timer.start()
    create_app().run(host='127.0.0.1', port=port, debug=False)
    return 0


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        print('\nСервер зупинено.')
    except Exception as error:
        # No raw connection strings or passwords in console error messages.
        print(f'Не вдалося запустити сервер ({type(error).__name__}). Перевір README_UA.md.')
        raise SystemExit(1)
