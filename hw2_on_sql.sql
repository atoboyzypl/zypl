-- Задача 1: Дата самой первой и самой последней покупки
SELECT MIN(invoice_date) AS first_purchase_date, MAX(invoice_date) AS last_purchase_date
FROM public.invoice;

-- Задача 2: Размер среднего чека для покупок из США
SELECT AVG(total) AS average_check_us
FROM public.invoice
WHERE billing_country = 'USA';

-- Задача 3: Список городов, в которых имеется более одного клиента
SELECT city, COUNT(*) AS customer_count
FROM public.customer
GROUP BY city
HAVING COUNT(*) > 1;

-- Задача 4: Список телефонных номеров, не содержащих скобок
SELECT phone
FROM public.customer
WHERE phone NOT LIKE '%(%' AND phone NOT LIKE '%)%';

-- Задача 5: Изменение текста 'lorem ipsum'
SELECT INITCAP('lorem ipsum') AS modified_text;

-- Задача 6: Список названий песен, которые содержат слово 'run'
SELECT "name"
FROM public.track
WHERE "name" ILIKE '%run%';

-- Задача 7: Список клиентов с почтовым ящиком в 'gmail'
SELECT email
FROM public.customer
WHERE email ILIKE '%@gmail%';

-- Задача 8: Произведение с самым длинным названием
SELECT "name"
FROM public.track
ORDER BY LENGTH("name") DESC
LIMIT 1;

-- Задача 9: Общая сумма продаж за 2021 год, в разбивке по месяцам
SELECT EXTRACT(MONTH FROM invoice_date) AS month_id, SUM(total) AS sales_sum
FROM public.invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id
ORDER BY month_id;

-- Задача 10: Добавление названия месяца к предыдущему запросу
SELECT EXTRACT(MONTH FROM invoice_date) AS month_id, 
       TO_CHAR(invoice_date, 'month') AS month_name, 
       SUM(total) AS sales_sum
FROM public.invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2021
GROUP BY month_id, month_name
ORDER BY month_id;

-- Задача 11: Список 3 самых возрастных сотрудников компании
SELECT CONCAT(first_name, ' ', last_name) AS full_name, birth_date, 
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age_now
FROM public.employee
ORDER BY birth_date ASC
LIMIT 3;

-- Задача 12: Средний возраст сотрудников через 3 года и 4 месяца
SELECT AVG(EXTRACT(YEAR FROM AGE(DATE '2024-07-01', birth_date))) AS average_age_in_future
FROM public.employee;

-- Задача 13: Сумма продаж в разбивке по годам и странам
SELECT EXTRACT(YEAR FROM invoice_date) AS year, billing_country, SUM(total) AS sales_sum
FROM public.invoice
GROUP BY year, billing_country
HAVING SUM(total) > 20
ORDER BY year, sales_sum DESC;
