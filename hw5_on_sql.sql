-- Задача №1.1: Количество клиентов, закреплённых за каждым сотрудником
SELECT 
    support_rep_id AS employee_id,
    (SELECT first_name || ' ' || last_name FROM public.employee WHERE employee_id = c.support_rep_id) AS full_name,
    COUNT(*) AS customer_count
FROM public.customer AS c
GROUP BY support_rep_id;

-- Задача №1.2: Процент от общей клиентской базы
WITH customer_counts AS (
    SELECT 
        support_rep_id AS employee_id,
        (SELECT first_name || ' ' || last_name FROM public.employee WHERE employee_id = c.support_rep_id) AS full_name,
        COUNT(*) AS customer_count
    FROM public.customer AS c
    GROUP BY support_rep_id
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

-- Задача №2: Альбомы, треки из которых вообще не продавались
SELECT 
    a.title AS album_title,
    ar.name AS artist_name
FROM public.album AS a
JOIN public.artist AS ar ON a.artist_id = ar.artist_id
WHERE NOT EXISTS (
    SELECT 1
    FROM public.invoice_line AS il
    JOIN public.track AS t ON il.track_id = t.track_id
    WHERE t.album_id = a.album_id
);

-- Задача №3: Сотрудники, у которых нет подчинённых
SELECT 
    employee_id,
    first_name || ' ' || last_name AS full_name
FROM public.employee
WHERE employee_id NOT IN (SELECT DISTINCT reports_to FROM public.employee WHERE reports_to IS NOT NULL);

-- Задача №4: Треки, продавались как в США так и в Канаде
SELECT 
    t.track_id,
    t.name AS track_name
FROM public.track AS t
JOIN public.invoice_line AS il ON t.track_id = il.track_id
JOIN public.invoice AS i ON il.invoice_id = i.invoice_id
WHERE i.billing_country = 'USA'
AND t.track_id IN (
    SELECT t2.track_id
    FROM public.track AS t2
    JOIN public.invoice_line AS il2 ON t2.track_id = il2.track_id
    JOIN public.invoice AS i2 ON il2.invoice_id = i2.invoice_id
    WHERE i2.billing_country = 'Canada'
);

-- Задача №5: Треки, продавались в Канаде, но не продавались в США
SELECT 
    t.track_id,
    t.name AS track_name
FROM public.track AS t
JOIN public.invoice_line AS il ON t.track_id = il.track_id
JOIN public.invoice AS i ON il.invoice_id = i.invoice_id
WHERE i.billing_country = 'Canada'
AND t.track_id NOT IN (
    SELECT t2.track_id
    FROM public.track AS t2
    JOIN public.invoice_line AS il2 ON t2.track_id = il2.track_id
    JOIN public.invoice AS i2 ON il2.invoice_id = i2.invoice_id
    WHERE i2.billing_country = 'USA'
);
