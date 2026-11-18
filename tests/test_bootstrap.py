import os
import uuid
from pathlib import Path
import mysql.connector
import pytest
import bootstrap

pytestmark = pytest.mark.skipif(os.getenv('RUN_MYSQL_TESTS') != '1', reason='MySQL integration tests are opt-in')

@pytest.fixture
def database():
    config = {'MYSQL_HOST':os.getenv('MYSQL_HOST','127.0.0.1'),
              'MYSQL_PORT':os.getenv('MYSQL_PORT','3306'),
              'MYSQL_USER':os.getenv('MYSQL_USER','root'),
              'MYSQL_PASSWORD':os.getenv('MYSQL_PASSWORD',''),
              'MYSQL_DATABASE':'kindergarten_bootstrap_' + uuid.uuid4().hex}
    connection = mysql.connector.connect(**bootstrap.connect_options(config), autocommit=True)
    try:
        yield config, connection
    finally:
        cursor = connection.cursor()
        cursor.execute('DROP DATABASE IF EXISTS `' + config['MYSQL_DATABASE'] + '`')
        cursor.close();connection.close()

def count(connection, table):
    cursor = connection.cursor()
    cursor.execute('SELECT COUNT(*) FROM `' + table + '`')
    result = cursor.fetchone()[0]
    cursor.close();return result

def test_create_and_repeat_preserves_rows(database):
    cfg, connection = database
    assert bootstrap.prepare_database(cfg)
    connection.database = cfg['MYSQL_DATABASE']
    cursor = connection.cursor()
    cursor.execute("UPDATE employees SET first_name='Збережене ім’я' WHERE employee_id=1")
    assert count(connection,'employees') == 10
    assert count(connection,'group_enrollments') == 12
    assert bootstrap.prepare_database(cfg) == []
    cursor.execute('SELECT first_name FROM employees WHERE employee_id=1')
    assert cursor.fetchone()[0] == 'Збережене ім’я'
    cursor.close()

def test_upgrade_missing_column_and_junction(database):
    cfg, connection = database
    bootstrap.prepare_database(cfg)
    connection.database = cfg['MYSQL_DATABASE']
    cursor = connection.cursor()
    cursor.execute('ALTER TABLE addresses DROP COLUMN district')
    cursor.execute('DROP TABLE employee_groups')
    changes = bootstrap.prepare_database(cfg)
    assert any('district' in x for x in changes)
    assert count(connection,'employees') == 10
    assert count(connection,'employee_groups') == 0
    cursor.execute('SELECT district FROM addresses WHERE address_id=1')
    assert cursor.fetchone()[0] is None
    cursor.close()

def test_partial_database_is_not_seeded(database):
    cfg, connection = database
    bootstrap.prepare_database(cfg,seed_if_empty=False)
    connection.database = cfg['MYSQL_DATABASE']
    cursor = connection.cursor()
    cursor.execute("INSERT INTO addresses(city,street,building_number) VALUES('Львів','Моя','1')")
    bootstrap.prepare_database(cfg)
    assert count(connection,'addresses') == 1
    assert count(connection,'employees') == 0
    cursor.close()

def test_seed_uses_explicit_columns(database):
    cfg, connection = database
    bootstrap.prepare_database(cfg,seed_if_empty=False)
    connection.database = cfg['MYSQL_DATABASE']
    cursor = connection.cursor()
    cursor.execute('ALTER TABLE addresses ADD extra_note VARCHAR(20) NULL')
    bootstrap.prepare_database(cfg)
    assert count(connection,'addresses') == 10
    cursor.close()

def test_manual_district_migration_can_repeat(database):
    cfg, connection = database
    bootstrap.prepare_database(cfg)
    connection.database = cfg['MYSQL_DATABASE']
    cursor = connection.cursor(buffered=True)
    cursor.execute('ALTER TABLE addresses DROP COLUMN district')
    sql = (Path(bootstrap.__file__).parent/'sql/03_add_district_if_missing.sql').read_text().replace('kindergarten_lab3',cfg['MYSQL_DATABASE'])
    for _ in range(2):
        for statement in sql.split(';'):
            if statement.strip():
                cursor.execute(statement)
                if cursor.with_rows:cursor.fetchall()
    assert count(connection,'addresses') == 10
    cursor.close()

def test_config_roundtrip_quotes_and_unicode(tmp_path,monkeypatch):
    target = tmp_path/'.env'
    monkeypatch.setattr(bootstrap,'ENV_FILE',target)
    values = {'MYSQL_PASSWORD':"test'quote#with space\\and_ю",'MYSQL_DATABASE':'kindergarten_test'}
    bootstrap.save_config(values)
    assert dict(bootstrap.dotenv_values(target)) == values

def test_reject_music_database():
    with pytest.raises(ValueError):bootstrap.validate_database_name('music_player_db')
