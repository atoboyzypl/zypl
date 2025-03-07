-- Задача 1: Создание новой схемы store и активация её
CREATE SCHEMA store;
SET search_path TO store;

-- Задача 2: Создание таблицы customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(260),
    address TEXT
);

-- Задача 3: Заполнение таблицы customers данными из customer
INSERT INTO customers (customer_name, email, address)
SELECT 
    first_name || ' ' || last_name AS customer_name,
    email,
    country || ' ' || COALESCE(state, '') || ' ' || city || ' ' || address AS address
FROM public.customer;

-- Задача 4: Создание таблицы products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC NOT NULL
);

-- Задача 5: Заполнение таблицы products списком товаров
INSERT INTO products (product_name, price) VALUES
('Ноутбук Lenovo Thinkpad', 12000),
('Мышь для компьютера, беспроводная', 90),
('Подставка для ноутбука', 300),
('Шнур электрический для ПК', 160);

-- Задача 6: Создание таблицы sales
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- Задача 7: Заполнение таблицы sales данными
INSERT INTO sales (customer_id, product_id, quantity) VALUES
(3, 4, 1),
(56, 2, 3),
(11, 2, 1),
(31, 2, 1),
(24, 2, 3),
(27, 2, 1),
(37, 3, 2),
(35, 1, 2),
(21, 1, 2),
(31, 2, 2),
(15, 1, 1),
(29, 2, 1),
(12, 2, 1);

-- Задача 8: Добавление столбца discount и установка его значения
ALTER TABLE sales ADD COLUMN discount NUMERIC;
UPDATE sales SET discount = 0.2 WHERE product_id = 1;

-- Задача 9: Создание представления v_usa_customers
CREATE VIEW v_usa_customers AS
SELECT * FROM customers WHERE address LIKE '%USA%';
