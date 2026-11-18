CREATE DATABASE IF NOT EXISTS kindergarten_lab3
    DEFAULT CHARACTER SET utf8mb4;

USE kindergarten_lab3;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS employee_groups;
DROP TABLE IF EXISTS group_enrollments;
DROP TABLE IF EXISTS salary_payments;
DROP TABLE IF EXISTS bonus_payments;
DROP TABLE IF EXISTS employment_history;
DROP TABLE IF EXISTS child_groups;
DROP TABLE IF EXISTS children;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS positions;
DROP TABLE IF EXISTS kindergartens;
DROP TABLE IF EXISTS addresses;

CREATE TABLE addresses (
    address_id INT NOT NULL AUTO_INCREMENT,
    city VARCHAR(50) NOT NULL,
    district VARCHAR(50) NULL,
    street VARCHAR(100) NOT NULL,
    building_number VARCHAR(10) NOT NULL,
    postal_code VARCHAR(10) NULL,
    PRIMARY KEY (address_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE kindergartens (
    kindergarten_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address_id INT NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    PRIMARY KEY (kindergarten_id),
    INDEX fk_kindergartens_address_idx (address_id),
    CONSTRAINT fk_kindergartens_address
        FOREIGN KEY (address_id)
        REFERENCES addresses (address_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE positions (
    positions_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    PRIMARY KEY (positions_id),
    UNIQUE INDEX name_UNIQUE (name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE employees (
    employee_id INT NOT NULL AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NULL,
    birth_date DATE NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    PRIMARY KEY (employee_id),
    INDEX idx_employees_name (last_name, first_name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE employment_history (
    employment_id INT NOT NULL AUTO_INCREMENT,
    employee_id INT NOT NULL,
    kindergarten_id INT NOT NULL,
    position_id INT NOT NULL,
    hire_date DATE NOT NULL,
    dismissal_date DATE NULL,
    PRIMARY KEY (employment_id),
    INDEX fk_employment_employee_idx (employee_id),
    INDEX fk_employment_kindergarten_idx (kindergarten_id),
    INDEX fk_employment_position_idx (position_id),
    CONSTRAINT fk_employment_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees (employee_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    CONSTRAINT fk_employment_kindergarten
        FOREIGN KEY (kindergarten_id)
        REFERENCES kindergartens (kindergarten_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    CONSTRAINT fk_employment_position
        FOREIGN KEY (position_id)
        REFERENCES positions (positions_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE salary_payments (
    salary_payment_id INT NOT NULL AUTO_INCREMENT,
    employment_id INT NOT NULL,
    salary_month DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NULL,
    PRIMARY KEY (salary_payment_id),
    INDEX fk_salary_employment_idx (employment_id),
    INDEX idx_salary_month (salary_month),
    CONSTRAINT fk_salary_employment
        FOREIGN KEY (employment_id)
        REFERENCES employment_history (employment_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE bonus_payments (
    bonus_payment_id INT NOT NULL AUTO_INCREMENT,
    employment_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    award_date DATE NOT NULL,
    reason VARCHAR(255) NOT NULL,
    payment_date DATE NULL,
    PRIMARY KEY (bonus_payment_id),
    INDEX fk_bonus_employment_idx (employment_id),
    CONSTRAINT fk_bonus_employment
        FOREIGN KEY (employment_id)
        REFERENCES employment_history (employment_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE child_groups (
    group_id INT NOT NULL AUTO_INCREMENT,
    kindergarten_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    age_min TINYINT NOT NULL,
    age_max TINYINT NOT NULL,
    capacity INT NOT NULL,
    PRIMARY KEY (group_id),
    INDEX fk_groups_kindergarten_idx (kindergarten_id),
    CONSTRAINT fk_groups_kindergarten
        FOREIGN KEY (kindergarten_id)
        REFERENCES kindergartens (kindergarten_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE children (
    child_id INT NOT NULL AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NULL,
    birth_date DATE NOT NULL,
    PRIMARY KEY (child_id),
    INDEX idx_children_name (last_name, first_name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE group_enrollments (
    enrollment_id INT NOT NULL AUTO_INCREMENT,
    child_id INT NOT NULL,
    group_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    departure_reason VARCHAR(255) NULL,
    PRIMARY KEY (enrollment_id),
    INDEX fk_enrollments_child_idx (child_id),
    INDEX fk_enrollments_group_idx (group_id),
    CONSTRAINT fk_enrollments_child
        FOREIGN KEY (child_id)
        REFERENCES children (child_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    CONSTRAINT fk_enrollments_group
        FOREIGN KEY (group_id)
        REFERENCES child_groups (group_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;


CREATE TABLE employee_groups (
    employee_id INT NOT NULL,
    group_id INT NOT NULL,
    PRIMARY KEY (employee_id, group_id),
    INDEX fk_employee_groups_group_idx (group_id),
    CONSTRAINT fk_employee_groups_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees (employee_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,
    CONSTRAINT fk_employee_groups_group
        FOREIGN KEY (group_id)
        REFERENCES child_groups (group_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE INDEX idx_enrollments_child_start
ON group_enrollments (child_id, start_date);

CREATE INDEX idx_salary_employment_month
ON salary_payments (employment_id, salary_month);


START TRANSACTION;


INSERT INTO addresses VALUES
(1, 'Львів', 'Шевченківський', 'Навчальна', '1', '79001');
INSERT INTO addresses VALUES
(2, 'Львів', 'Франківський', 'Навчальна', '2', '79002');
INSERT INTO addresses VALUES
(3, 'Львів', 'Личаківський', 'Навчальна', '3', '79003');
INSERT INTO addresses VALUES
(4, 'Львів', 'Сихівський', 'Навчальна', '4', '79004');
INSERT INTO addresses VALUES
(5, 'Львів', 'Залізничний', 'Навчальна', '5', '79005');
INSERT INTO addresses VALUES
(6, 'Львів', 'Галицький', 'Навчальна', '6', '79006');
INSERT INTO addresses VALUES
(7, 'Львів', 'Шевченківський', 'Навчальна', '7', '79007');
INSERT INTO addresses VALUES
(8, 'Львів', 'Франківський', 'Навчальна', '8', '79008');
INSERT INTO addresses VALUES
(9, 'Львів', 'Личаківський', 'Навчальна', '9', '79009');
INSERT INTO addresses VALUES
(10, 'Львів', 'Сихівський', 'Навчальна', '10', '79010');


INSERT INTO kindergartens VALUES
(1, 'Сонечко', 1, '+380320000001', 'garden1@example.com');
INSERT INTO kindergartens VALUES
(2, 'Веселка', 2, '+380320000002', 'garden2@example.com');
INSERT INTO kindergartens VALUES
(3, 'Дзвіночок', 3, '+380320000003', 'garden3@example.com');
INSERT INTO kindergartens VALUES
(4, 'Ромашка', 4, '+380320000004', 'garden4@example.com');
INSERT INTO kindergartens VALUES
(5, 'Барвінок', 5, '+380320000005', 'garden5@example.com');
INSERT INTO kindergartens VALUES
(6, 'Калинка', 6, '+380320000006', 'garden6@example.com');
INSERT INTO kindergartens VALUES
(7, 'Зірочка', 7, '+380320000007', 'garden7@example.com');
INSERT INTO kindergartens VALUES
(8, 'Малятко', 8, '+380320000008', 'garden8@example.com');
INSERT INTO kindergartens VALUES
(9, 'Казка', 9, '+380320000009', 'garden9@example.com');
INSERT INTO kindergartens VALUES
(10, 'Джерельце', 10, '+380320000010', 'garden10@example.com');


INSERT INTO positions VALUES
(1, 'Вихователь', 'Навчання та догляд за дітьми');
INSERT INTO positions VALUES
(2, 'Помічник вихователя', 'Допомога вихователю');
INSERT INTO positions VALUES
(3, 'Директор', 'Керівництво дитсадком');
INSERT INTO positions VALUES
(4, 'Кухар', 'Приготування їжі');
INSERT INTO positions VALUES
(5, 'Медична сестра', 'Медичний супровід');
INSERT INTO positions VALUES
(6, 'Психолог', 'Психологічна підтримка дітей');
INSERT INTO positions VALUES
(7, 'Логопед', 'Розвиток мовлення дітей');
INSERT INTO positions VALUES
(8, 'Музичний керівник', 'Організація музичних занять');
INSERT INTO positions VALUES
(9, 'Інструктор з фізкультури', 'Проведення фізичних занять');
INSERT INTO positions VALUES
(10, 'Завідувач господарства', 'Господарське забезпечення');


INSERT INTO employees VALUES
(1, 'Коваль', 'Олена', 'Іванівна', '1983-03-01',
 '+380670000001', 'employee1@example.com');
INSERT INTO employees VALUES
(2, 'Мельник', 'Ірина', 'Петрівна', '1984-03-02',
 '+380670000002', 'employee2@example.com');
INSERT INTO employees VALUES
(3, 'Шевченко', 'Марія', 'Олегівна', '1985-03-03',
 '+380670000003', 'employee3@example.com');
INSERT INTO employees VALUES
(4, 'Бойко', 'Наталія', 'Андріївна', '1986-03-04',
 '+380670000004', 'employee4@example.com');
INSERT INTO employees VALUES
(5, 'Ткачук', 'Оксана', 'Василівна', '1987-03-05',
 '+380670000005', 'employee5@example.com');
INSERT INTO employees VALUES
(6, 'Савчук', 'Тарас', 'Ігорович', '1988-03-06',
 '+380670000006', 'employee6@example.com');
INSERT INTO employees VALUES
(7, 'Романюк', 'Софія', 'Михайлівна', '1989-03-07',
 '+380670000007', 'employee7@example.com');
INSERT INTO employees VALUES
(8, 'Кравчук', 'Андрій', 'Романович', '1990-03-08',
 '+380670000008', 'employee8@example.com');
INSERT INTO employees VALUES
(9, 'Олійник', 'Юлія', 'Степанівна', '1991-03-09',
 '+380670000009', 'employee9@example.com');
INSERT INTO employees VALUES
(10, 'Петренко', 'Галина', 'Богданівна', '1992-03-10',
 '+380670000010', 'employee10@example.com');


INSERT INTO employment_history VALUES
(1, 1, 1, 1, '2022-09-01', NULL);
INSERT INTO employment_history VALUES
(2, 2, 1, 2, '2022-09-01', NULL);
INSERT INTO employment_history VALUES
(3, 3, 2, 1, '2023-09-01', NULL);
INSERT INTO employment_history VALUES
(4, 4, 2, 2, '2023-09-01', NULL);
INSERT INTO employment_history VALUES
(5, 5, 3, 1, '2022-09-01', NULL);
INSERT INTO employment_history VALUES
(6, 6, 3, 2, '2022-09-01', NULL);
INSERT INTO employment_history VALUES
(7, 7, 4, 1, '2024-09-01', NULL);
INSERT INTO employment_history VALUES
(8, 8, 4, 2, '2024-09-01', NULL);
INSERT INTO employment_history VALUES
(9, 9, 5, 1, '2023-09-01', NULL);
INSERT INTO employment_history VALUES
(10, 10, 5, 2, '2023-09-01', '2026-08-31');


INSERT INTO salary_payments VALUES
(1, 1, '2026-09-01', 15500.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(2, 2, '2026-09-01', 16000.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(3, 3, '2026-09-01', 16500.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(4, 4, '2026-09-01', 17000.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(5, 5, '2026-09-01', 17500.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(6, 6, '2026-09-01', 18000.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(7, 7, '2026-09-01', 18500.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(8, 8, '2026-09-01', 19000.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(9, 9, '2026-09-01', 19500.00, '2026-09-30');
INSERT INTO salary_payments VALUES
(10, 10, '2026-08-01', 20000.00, '2026-09-08');


INSERT INTO bonus_payments VALUES
(1, 1, 1200.00, '2026-09-20',
 'Підготовка навчальних матеріалів', '2026-09-30');
INSERT INTO bonus_payments VALUES
(2, 2, 1400.00, '2026-09-20',
 'Якісна організація роботи', '2026-09-30');
INSERT INTO bonus_payments VALUES
(3, 3, 1600.00, '2026-09-20',
 'Проведення дитячого свята', '2026-09-30');
INSERT INTO bonus_payments VALUES
(4, 4, 1800.00, '2026-09-20',
 'Підготовка групи до навчання', '2026-09-30');
INSERT INTO bonus_payments VALUES
(5, 5, 2000.00, '2026-09-20',
 'Участь у навчальному проєкті', '2026-09-30');
INSERT INTO bonus_payments VALUES
(6, 6, 1100.00, '2026-09-21',
 'Допомога в організації занять', '2026-09-30');
INSERT INTO bonus_payments VALUES
(7, 7, 1300.00, '2026-09-21',
 'Проведення спортивного заходу', '2026-09-30');
INSERT INTO bonus_payments VALUES
(8, 8, 1500.00, '2026-09-21',
 'Підготовка обладнання', '2026-09-30');
INSERT INTO bonus_payments VALUES
(9, 9, 1700.00, '2026-09-21',
 'Організація роботи з батьками', '2026-09-30');
INSERT INTO bonus_payments VALUES
(10, 10, 900.00, '2026-08-20',
 'Якісне виконання обов’язків', '2026-08-31');


INSERT INTO child_groups VALUES
(1, 1, 'Молодша', 2, 4, 25);
INSERT INTO child_groups VALUES
(2, 1, 'Старша', 5, 7, 25);
INSERT INTO child_groups VALUES
(3, 2, 'Молодша', 2, 4, 25);
INSERT INTO child_groups VALUES
(4, 2, 'Старша', 5, 7, 25);
INSERT INTO child_groups VALUES
(5, 3, 'Молодша', 2, 4, 25);
INSERT INTO child_groups VALUES
(6, 3, 'Старша', 5, 7, 25);
INSERT INTO child_groups VALUES
(7, 4, 'Молодша', 2, 4, 25);
INSERT INTO child_groups VALUES
(8, 4, 'Старша', 5, 7, 25);
INSERT INTO child_groups VALUES
(9, 5, 'Молодша', 2, 4, 25);
INSERT INTO child_groups VALUES
(10, 5, 'Старша', 5, 7, 25);


INSERT INTO children VALUES
(1, 'Коваль', 'Максим', NULL, '2019-11-10');
INSERT INTO children VALUES
(2, 'Мельник', 'Анна', NULL, '2020-02-14');
INSERT INTO children VALUES
(3, 'Бойко', 'Данило', NULL, '2021-04-02');
INSERT INTO children VALUES
(4, 'Савчук', 'Софія', NULL, '2022-01-15');
INSERT INTO children VALUES
(5, 'Романюк', 'Артем', NULL, '2022-07-08');
INSERT INTO children VALUES
(6, 'Кравчук', 'Марія', NULL, '2020-09-03');
INSERT INTO children VALUES
(7, 'Олійник', 'Назар', NULL, '2022-08-20');
INSERT INTO children VALUES
(8, 'Ткачук', 'Вікторія', NULL, '2021-06-12');
INSERT INTO children VALUES
(9, 'Петренко', 'Олександр', NULL, '2019-03-25');
INSERT INTO children VALUES
(10, 'Шевченко', 'Дарина', NULL, '2019-05-17');


INSERT INTO group_enrollments VALUES
(1, 1, 2, '2024-11-11', '2026-05-31',
 'Переведення до іншого дитсадка');
INSERT INTO group_enrollments VALUES
(2, 1, 4, '2026-06-01', NULL, NULL);

INSERT INTO group_enrollments VALUES
(3, 2, 1, '2023-09-01', '2025-08-31',
 'Переведення до старшої групи');
INSERT INTO group_enrollments VALUES
(4, 2, 2, '2025-09-01', NULL, NULL);

INSERT INTO group_enrollments VALUES
(5, 3, 4, '2026-09-01', NULL, NULL);
INSERT INTO group_enrollments VALUES
(6, 4, 5, '2025-09-01', NULL, NULL);
INSERT INTO group_enrollments VALUES
(7, 5, 5, '2025-09-01', NULL, NULL);
INSERT INTO group_enrollments VALUES
(8, 6, 6, '2025-09-03', NULL, NULL);
INSERT INTO group_enrollments VALUES
(9, 7, 7, '2025-09-01', NULL, NULL);
INSERT INTO group_enrollments VALUES
(10, 8, 8, '2026-09-01', NULL, NULL);
INSERT INTO group_enrollments VALUES
(11, 9, 10, '2024-09-01', '2026-08-31',
 'Вступ до школи');
INSERT INTO group_enrollments VALUES
(12, 10, 10, '2024-09-01', '2026-08-31',
 'Вступ до школи');


INSERT INTO employee_groups VALUES (1, 1);
INSERT INTO employee_groups VALUES (1, 2);
INSERT INTO employee_groups VALUES (2, 1);
INSERT INTO employee_groups VALUES (2, 2);
INSERT INTO employee_groups VALUES (3, 3);
INSERT INTO employee_groups VALUES (3, 4);
INSERT INTO employee_groups VALUES (4, 3);
INSERT INTO employee_groups VALUES (4, 4);
INSERT INTO employee_groups VALUES (5, 5);
INSERT INTO employee_groups VALUES (6, 6);

COMMIT;


SELECT 'addresses' AS table_name, COUNT(*) AS row_count
FROM addresses
UNION ALL
SELECT 'kindergartens', COUNT(*) FROM kindergartens
UNION ALL
SELECT 'positions', COUNT(*) FROM positions
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'employment_history', COUNT(*) FROM employment_history
UNION ALL
SELECT 'salary_payments', COUNT(*) FROM salary_payments
UNION ALL
SELECT 'bonus_payments', COUNT(*) FROM bonus_payments
UNION ALL
SELECT 'child_groups', COUNT(*) FROM child_groups
UNION ALL
SELECT 'children', COUNT(*) FROM children
UNION ALL
SELECT 'group_enrollments', COUNT(*) FROM group_enrollments
UNION ALL
SELECT 'employee_groups', COUNT(*) FROM employee_groups;

SHOW INDEX FROM group_enrollments
WHERE Key_name = 'idx_enrollments_child_start';

SHOW INDEX FROM salary_payments
WHERE Key_name = 'idx_salary_employment_month';

SELECT TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'kindergarten_lab3'
  AND CONSTRAINT_NAME = 'PRIMARY'
ORDER BY TABLE_NAME, ORDINAL_POSITION;