-- Задача №1.1: Сумма продаж по годам и месяцам для каждого клиента
SELECT 
    i.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    EXTRACT(YEAR FROM i.invoice_date) * 100 + EXTRACT(MONTH FROM i.invoice_date) AS monthkey,
    SUM(i.total) AS total
FROM public.invoice AS i
JOIN public.customer AS c ON i.customer_id = c.customer_id
GROUP BY i.customer_id, full_name, monthkey;

-- Задача №1.2: Процент от общих продаж за каждый месяц для каждого клиента
WITH monthly_sales AS (
    SELECT 
        i.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        EXTRACT(YEAR FROM i.invoice_date) * 100 + EXTRACT(MONTH FROM i.invoice_date) AS monthkey,
        SUM(i.total) AS total
    FROM public.invoice AS i
    JOIN public.customer AS c ON i.customer_id = c.customer_id
    GROUP BY i.customer_id, full_name, monthkey
), total_sales AS (
    SELECT 
        EXTRACT(YEAR FROM i.invoice_date) * 100 + EXTRACT(MONTH FROM i.invoice_date) AS monthkey,
        SUM(i.total) AS total
    FROM public.invoice AS i
    GROUP BY monthkey
)
SELECT 
    ms.customer_id,
    ms.full_name,
    ms.monthkey,
    ms.total,
    (ms.total / ts.total) * 100 AS percentage_of_total
FROM monthly_sales AS ms
JOIN total_sales AS ts ON ms.monthkey = ts.monthkey;

-- Задача №1.3: Нарастающий итог за каждый год для каждого клиента
WITH monthly_sales AS (
    SELECT 
        i.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        EXTRACT(YEAR FROM i.invoice_date) * 100 + EXTRACT(MONTH FROM i.invoice_date) AS monthkey,
        SUM(i.total) AS total
    FROM public.invoice AS i
    JOIN public.customer AS c ON i.customer_id = c.customer_id
    GROUP BY i.customer_id, full_name, monthkey
)
SELECT 
    customer_id,
    full_name,
    monthkey,
    total,
    SUM(total) OVER (PARTITION BY customer_id, EXTRACT(YEAR FROM TO_DATE(monthkey::TEXT, 'YYYYMM')) ORDER BY monthkey) AS running_total
FROM monthly_sales;

-- Задача №1.4: Скользящее среднее за 3 последних периода для каждого клиента
WITH monthly_sales AS (
    SELECT 
        i.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        EXTRACT(YEAR FROM i.invoice_date) * 100 + EXTRACT(MONTH FROM i.invoice_date) AS monthkey,
        SUM(i.total) AS total
    FROM public.invoice AS i
    JOIN public.customer AS c ON i.customer_id = c.customer_id
    GROUP BY i.customer_id, full_name, monthkey
)
SELECT 
    customer_id,
    full_name,
    monthkey,
    total,
    AVG(total) OVER (PARTITION BY customer_id ORDER BY monthkey ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM monthly_sales;

-- Задача №1.5: Разница между суммой текущего периода и суммой предыдущего периода для каждого клиента
WITH monthly_sales AS (
    SELECT 
        i.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        EXTRACT(YEAR FROM i.invoice_date) * 100 + EXTRACT(MONTH FROM i.invoice_date) AS monthkey,
        SUM(i.total) AS total
    FROM public.invoice AS i
    JOIN public.customer AS c ON i.customer_id = c.customer_id
    GROUP BY i.customer_id, full_name, monthkey
)
SELECT 
    customer_id,
    full_name,
    monthkey,
    total,
    total - LAG(total) OVER (PARTITION BY customer_id ORDER BY monthkey) AS difference
FROM monthly_sales;

-- Задача №2: Топ-3 продаваемых альбома за каждый год
WITH album_sales AS (
    SELECT 
        EXTRACT(YEAR FROM i.invoice_date) AS year,
        a.title AS album_title,
        ar.name AS artist_name,
        COUNT(il.invoice_line_id) AS track_count
    FROM public.invoice AS i
    JOIN public.invoice_line AS il ON i.invoice_id = il.invoice_id
    JOIN public.track AS t ON il.track_id = t.track_id
    JOIN public.album AS a ON t.album_id = a.album_id
    JOIN public.artist AS ar ON a.artist_id = ar.artist_id
    GROUP BY year, album_title, artist_name
)
SELECT year, album_title, artist_name, track_count
FROM (
    SELECT 
        year, 
        album_title, 
        artist_name, 
        track_count, 
        RANK() OVER (PARTITION BY year ORDER BY track_count DESC) AS rank
    FROM album_sales
) AS ranked_albums
WHERE rank <= 3;

-- Задача №3.1: Количество клиентов, закреплённых за каждым сотрудником
SELECT 
    c.support_rep_id AS employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    COUNT(*) AS customer_count
FROM public.customer AS c
JOIN public.employee AS e ON c.support_rep_id = e.employee_id
GROUP BY c.support_rep_id, e.first_name, e.last_name;

-- Задача №3.2: Процент от общей клиентской базы для каждого сотрудника
WITH customer_counts AS (
    SELECT 
        c.support_rep_id AS employee_id,
        e.first_name || ' ' || e.last_name AS full_name,
        COUNT(*) AS customer_count
    FROM public.customer AS c
    JOIN public.employee AS e ON c.support_rep_id = e.employee_id
    GROUP BY c.support_rep_id, e.first_name, e.last_name
), total_customers AS (
    SELECT COUNT(*) AS total_count
    FROM public.customer
)
SELECT 
    employee_id,
    full_name,
    customer_count,
    (customer_count::float / total_count::float) * 100 AS customer_percentage
FROM customer_counts, total_customers;

-- Задача №4: Дата первой и последней покупки для каждого клиента и разница в годах
SELECT 
    i.customer_id,
    MIN(i.invoice_date) AS first_purchase,
    MAX(i.invoice_date) AS last_purchase,
    EXTRACT(YEAR FROM AGE(MAX(i.invoice_date), MIN(i.invoice_date))) AS difference_in_years
FROM public.invoice AS i
GROUP BY i.customer_id;
