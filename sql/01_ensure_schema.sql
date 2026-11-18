-- Варіант 34 Дитсадок. Не видаляє таблиці або дані.
-- За потреби заміни kindergarten_lab3 на назву своєї бази.
CREATE DATABASE IF NOT EXISTS kindergarten_lab3 DEFAULT CHARACTER SET utf8mb4;
USE kindergarten_lab3;
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS addresses (
    address_id INT NOT NULL AUTO_INCREMENT,
    city VARCHAR(50) NOT NULL,
    district VARCHAR(50) NULL,
    street VARCHAR(100) NOT NULL,
    building_number VARCHAR(10) NOT NULL,
    postal_code VARCHAR(10) NULL,
    PRIMARY KEY (address_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS kindergartens (
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

CREATE TABLE IF NOT EXISTS positions (
    positions_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    PRIMARY KEY (positions_id),
    UNIQUE INDEX name_UNIQUE (name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS employees (
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

CREATE TABLE IF NOT EXISTS employment_history (
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

CREATE TABLE IF NOT EXISTS salary_payments (
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

CREATE TABLE IF NOT EXISTS bonus_payments (
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

CREATE TABLE IF NOT EXISTS child_groups (
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

CREATE TABLE IF NOT EXISTS children (
    child_id INT NOT NULL AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NULL,
    birth_date DATE NOT NULL,
    PRIMARY KEY (child_id),
    INDEX idx_children_name (last_name, first_name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS group_enrollments (
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

CREATE TABLE IF NOT EXISTS employee_groups (
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
