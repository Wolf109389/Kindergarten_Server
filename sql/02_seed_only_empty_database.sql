-- Лише для повністю порожньої схеми. START_SERVER.bat перевіряє це автоматично.
START TRANSACTION;


INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(1, 'Львів', 'Шевченківський', 'Навчальна', '1', '79001');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(2, 'Львів', 'Франківський', 'Навчальна', '2', '79002');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(3, 'Львів', 'Личаківський', 'Навчальна', '3', '79003');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(4, 'Львів', 'Сихівський', 'Навчальна', '4', '79004');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(5, 'Львів', 'Залізничний', 'Навчальна', '5', '79005');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(6, 'Львів', 'Галицький', 'Навчальна', '6', '79006');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(7, 'Львів', 'Шевченківський', 'Навчальна', '7', '79007');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(8, 'Львів', 'Франківський', 'Навчальна', '8', '79008');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(9, 'Львів', 'Личаківський', 'Навчальна', '9', '79009');
INSERT INTO addresses (address_id, city, district, street, building_number, postal_code) VALUES
(10, 'Львів', 'Сихівський', 'Навчальна', '10', '79010');


INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(1, 'Сонечко', 1, '+380320000001', 'garden1@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(2, 'Веселка', 2, '+380320000002', 'garden2@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(3, 'Дзвіночок', 3, '+380320000003', 'garden3@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(4, 'Ромашка', 4, '+380320000004', 'garden4@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(5, 'Барвінок', 5, '+380320000005', 'garden5@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(6, 'Калинка', 6, '+380320000006', 'garden6@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(7, 'Зірочка', 7, '+380320000007', 'garden7@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(8, 'Малятко', 8, '+380320000008', 'garden8@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(9, 'Казка', 9, '+380320000009', 'garden9@example.com');
INSERT INTO kindergartens (kindergarten_id, name, address_id, phone, email) VALUES
(10, 'Джерельце', 10, '+380320000010', 'garden10@example.com');


INSERT INTO positions (positions_id, name, description) VALUES
(1, 'Вихователь', 'Навчання та догляд за дітьми');
INSERT INTO positions (positions_id, name, description) VALUES
(2, 'Помічник вихователя', 'Допомога вихователю');
INSERT INTO positions (positions_id, name, description) VALUES
(3, 'Директор', 'Керівництво дитсадком');
INSERT INTO positions (positions_id, name, description) VALUES
(4, 'Кухар', 'Приготування їжі');
INSERT INTO positions (positions_id, name, description) VALUES
(5, 'Медична сестра', 'Медичний супровід');
INSERT INTO positions (positions_id, name, description) VALUES
(6, 'Психолог', 'Психологічна підтримка дітей');
INSERT INTO positions (positions_id, name, description) VALUES
(7, 'Логопед', 'Розвиток мовлення дітей');
INSERT INTO positions (positions_id, name, description) VALUES
(8, 'Музичний керівник', 'Організація музичних занять');
INSERT INTO positions (positions_id, name, description) VALUES
(9, 'Інструктор з фізкультури', 'Проведення фізичних занять');
INSERT INTO positions (positions_id, name, description) VALUES
(10, 'Завідувач господарства', 'Господарське забезпечення');


INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(1, 'Коваль', 'Олена', 'Іванівна', '1983-03-01',
 '+380670000001', 'employee1@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(2, 'Мельник', 'Ірина', 'Петрівна', '1984-03-02',
 '+380670000002', 'employee2@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(3, 'Шевченко', 'Марія', 'Олегівна', '1985-03-03',
 '+380670000003', 'employee3@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(4, 'Бойко', 'Наталія', 'Андріївна', '1986-03-04',
 '+380670000004', 'employee4@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(5, 'Ткачук', 'Оксана', 'Василівна', '1987-03-05',
 '+380670000005', 'employee5@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(6, 'Савчук', 'Тарас', 'Ігорович', '1988-03-06',
 '+380670000006', 'employee6@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(7, 'Романюк', 'Софія', 'Михайлівна', '1989-03-07',
 '+380670000007', 'employee7@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(8, 'Кравчук', 'Андрій', 'Романович', '1990-03-08',
 '+380670000008', 'employee8@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(9, 'Олійник', 'Юлія', 'Степанівна', '1991-03-09',
 '+380670000009', 'employee9@example.com');
INSERT INTO employees (employee_id, last_name, first_name, middle_name, birth_date, phone, email) VALUES
(10, 'Петренко', 'Галина', 'Богданівна', '1992-03-10',
 '+380670000010', 'employee10@example.com');


INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(1, 1, 1, 1, '2022-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(2, 2, 1, 2, '2022-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(3, 3, 2, 1, '2023-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(4, 4, 2, 2, '2023-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(5, 5, 3, 1, '2022-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(6, 6, 3, 2, '2022-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(7, 7, 4, 1, '2024-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(8, 8, 4, 2, '2024-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(9, 9, 5, 1, '2023-09-01', NULL);
INSERT INTO employment_history (employment_id, employee_id, kindergarten_id, position_id, hire_date, dismissal_date) VALUES
(10, 10, 5, 2, '2023-09-01', '2026-08-31');


INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(1, 1, '2026-09-01', 15500.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(2, 2, '2026-09-01', 16000.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(3, 3, '2026-09-01', 16500.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(4, 4, '2026-09-01', 17000.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(5, 5, '2026-09-01', 17500.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(6, 6, '2026-09-01', 18000.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(7, 7, '2026-09-01', 18500.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(8, 8, '2026-09-01', 19000.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(9, 9, '2026-09-01', 19500.00, '2026-09-30');
INSERT INTO salary_payments (salary_payment_id, employment_id, salary_month, amount, payment_date) VALUES
(10, 10, '2026-08-01', 20000.00, '2026-09-08');


INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(1, 1, 1200.00, '2026-09-20',
 'Підготовка навчальних матеріалів', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(2, 2, 1400.00, '2026-09-20',
 'Якісна організація роботи', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(3, 3, 1600.00, '2026-09-20',
 'Проведення дитячого свята', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(4, 4, 1800.00, '2026-09-20',
 'Підготовка групи до навчання', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(5, 5, 2000.00, '2026-09-20',
 'Участь у навчальному проєкті', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(6, 6, 1100.00, '2026-09-21',
 'Допомога в організації занять', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(7, 7, 1300.00, '2026-09-21',
 'Проведення спортивного заходу', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(8, 8, 1500.00, '2026-09-21',
 'Підготовка обладнання', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(9, 9, 1700.00, '2026-09-21',
 'Організація роботи з батьками', '2026-09-30');
INSERT INTO bonus_payments (bonus_payment_id, employment_id, amount, award_date, reason, payment_date) VALUES
(10, 10, 900.00, '2026-08-20',
 'Якісне виконання обов’язків', '2026-08-31');


INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(1, 1, 'Молодша', 2, 4, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(2, 1, 'Старша', 5, 7, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(3, 2, 'Молодша', 2, 4, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(4, 2, 'Старша', 5, 7, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(5, 3, 'Молодша', 2, 4, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(6, 3, 'Старша', 5, 7, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(7, 4, 'Молодша', 2, 4, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(8, 4, 'Старша', 5, 7, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(9, 5, 'Молодша', 2, 4, 25);
INSERT INTO child_groups (group_id, kindergarten_id, name, age_min, age_max, capacity) VALUES
(10, 5, 'Старша', 5, 7, 25);


INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(1, 'Коваль', 'Максим', NULL, '2019-11-10');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(2, 'Мельник', 'Анна', NULL, '2020-02-14');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(3, 'Бойко', 'Данило', NULL, '2021-04-02');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(4, 'Савчук', 'Софія', NULL, '2022-01-15');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(5, 'Романюк', 'Артем', NULL, '2022-07-08');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(6, 'Кравчук', 'Марія', NULL, '2020-09-03');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(7, 'Олійник', 'Назар', NULL, '2022-08-20');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(8, 'Ткачук', 'Вікторія', NULL, '2021-06-12');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(9, 'Петренко', 'Олександр', NULL, '2019-03-25');
INSERT INTO children (child_id, last_name, first_name, middle_name, birth_date) VALUES
(10, 'Шевченко', 'Дарина', NULL, '2019-05-17');


INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(1, 1, 2, '2024-11-11', '2026-05-31',
 'Переведення до іншого дитсадка');
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(2, 1, 4, '2026-06-01', NULL, NULL);

INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(3, 2, 1, '2023-09-01', '2025-08-31',
 'Переведення до старшої групи');
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(4, 2, 2, '2025-09-01', NULL, NULL);

INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(5, 3, 4, '2026-09-01', NULL, NULL);
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(6, 4, 5, '2025-09-01', NULL, NULL);
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(7, 5, 5, '2025-09-01', NULL, NULL);
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(8, 6, 6, '2025-09-03', NULL, NULL);
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(9, 7, 7, '2025-09-01', NULL, NULL);
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(10, 8, 8, '2026-09-01', NULL, NULL);
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(11, 9, 10, '2024-09-01', '2026-08-31',
 'Вступ до школи');
INSERT INTO group_enrollments (enrollment_id, child_id, group_id, start_date, end_date, departure_reason) VALUES
(12, 10, 10, '2024-09-01', '2026-08-31',
 'Вступ до школи');


INSERT INTO employee_groups (employee_id, group_id) VALUES (1, 1);
INSERT INTO employee_groups (employee_id, group_id) VALUES (1, 2);
INSERT INTO employee_groups (employee_id, group_id) VALUES (2, 1);
INSERT INTO employee_groups (employee_id, group_id) VALUES (2, 2);
INSERT INTO employee_groups (employee_id, group_id) VALUES (3, 3);
INSERT INTO employee_groups (employee_id, group_id) VALUES (3, 4);
INSERT INTO employee_groups (employee_id, group_id) VALUES (4, 3);
INSERT INTO employee_groups (employee_id, group_id) VALUES (4, 4);
INSERT INTO employee_groups (employee_id, group_id) VALUES (5, 5);
INSERT INTO employee_groups (employee_id, group_id) VALUES (6, 6);

COMMIT;