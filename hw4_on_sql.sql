-- Задача 1: Информация по каждому сотруднику компании
SELECT 
    employee_id, 
    first_name || ' ' || last_name AS full_name, 
    title, 
    reports_to, 
    (SELECT first_name || ' ' || last_name || ', ' || title 
     FROM public.employee 
     WHERE employee_id = e.reports_to) AS manager_info
FROM public.employee AS e;

-- Задача 2: Список чеков, сумма которых была больше среднего чека за 2023 год
WITH avg_check_2023 AS (
    SELECT AVG(total) AS avg_total_2023
    FROM public.invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2023
)
SELECT 
    invoice_id, 
    invoice_date, 
    EXTRACT(YEAR FROM invoice_date) * 100 + EXTRACT(MONTH FROM invoice_date) AS monthkey, 
    customer_id, 
    total
FROM public.invoice
WHERE total > (SELECT avg_total_2023 FROM avg_check_2023);

-- Задача 3: Дополнение информации email-ом клиента
WITH avg_check_2023 AS (
    SELECT AVG(total) AS avg_total_2023
    FROM public.invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2023
)
SELECT 
    i.invoice_id, 
    i.invoice_date, 
    EXTRACT(YEAR FROM i.invoice_date) * 100 + EXTRACT(MONTH FROM i.invoice_date) AS monthkey, 
    i.customer_id, 
    i.total, 
    c.email
FROM public.invoice AS i
JOIN public.customer AS c ON i.customer_id = c.customer_id
WHERE i.total > (SELECT avg_total_2023 FROM avg_check_2023);

-- Задача 4: Отфильтровка клиентов без почтового ящика в домене gmail
WITH avg_check_2023 AS (
    SELECT AVG(total) AS avg_total_2023
    FROM public.invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2023
)
SELECT 
    i.invoice_id, 
    i.invoice_date, 
    EXTRACT(YEAR FROM i.invoice_date) * 100 + EXTRACT(MONTH FROM i.invoice_date) AS monthkey, 
    i.customer_id, 
    i.total, 
    c.email
FROM public.invoice AS i
JOIN public.customer AS c ON i.customer_id = c.customer_id
WHERE i.total > (SELECT avg_total_2023 FROM avg_check_2023)
AND c.email NOT LIKE '%@gmail.com%';

-- Задача 5: Процент от общей выручки за 2024 год для каждого чека
WITH total_revenue_2024 AS (
    SELECT SUM(total) AS total_revenue
    FROM public.invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2024
)
SELECT 
    invoice_id, 
    total, 
    (total / (SELECT total_revenue FROM total_revenue_2024) * 100) AS percentage_of_total_revenue
FROM public.invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2024;

-- Задача 6: Процент от общей выручки за 2024 год для каждого клиента
WITH total_revenue_2024 AS (
    SELECT SUM(total) AS total_revenue
    FROM public.invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2024
)
SELECT 
    customer_id, 
    SUM(total) AS total_per_customer, 
    (SUM(total) / (SELECT total_revenue FROM total_revenue_2024) * 100) AS percentage_of_total_revenue
FROM public.invoice
WHERE EXTRACT(YEAR FROM invoice_date) = 2024
GROUP BY customer_id;
