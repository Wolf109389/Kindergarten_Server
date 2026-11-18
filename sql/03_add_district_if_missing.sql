-- Зміна лише для ранньої версії бази без поля district.
-- Для іншої бази заміни назву в USE.
USE kindergarten_lab3;
SET @district_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'addresses'
      AND COLUMN_NAME = 'district'
);
SET @district_sql = IF(@district_exists = 0,
    'ALTER TABLE addresses ADD COLUMN district VARCHAR(50) NULL AFTER city',
    'SELECT \'district already exists\' AS status');
PREPARE district_statement FROM @district_sql;
EXECUTE district_statement;
DEALLOCATE PREPARE district_statement;
