/*
Автор: Умарзода Отабой
Описание задачи:
Эта задача включает создание ветки в локальном репозитории, переключение на неё, 
а также выполнение и сохранение SQL-запроса в DBeaver под именем hw1_on_sql.sql.
*/

-- 2. Вернуть поля name и genre_id из таблицы track
SELECT name, genre_id
FROM public.track;

-- 3. Вернуть поля name, composer и unit_price, переименовав их на song, author и price соответственно,
--    и расположив их в порядке: название произведения, цена, список авторов
SELECT name AS song, unit_price AS price, composer AS author
FROM public.track;

-- 5. Вернуть название произведения и его длительность в минутах, отсортировав по длительности по убыванию
SELECT name, milliseconds / 60000 AS duration_minutes
FROM public.track
ORDER BY duration_minutes DESC;

-- 6. Вернуть поля name и genre_id, и только первые 15 строк
SELECT name, genre_id
FROM public.track
LIMIT 15;

-- 7. Вернуть все поля и все строки, начиная с 50-й строки
SELECT *
FROM public.track
OFFSET 49;

-- 8. Вернуть названия всех произведений, чей объём больше 100 мегабайт
SELECT name
FROM public.track
WHERE bytes > 104857600;

-- 9. Вернуть поля name и composer, где composer не равен "U2",
--    и вернуть записи с 10-й по 20-ю включительно
SELECT name, composer
FROM public.track
WHERE composer != 'U2'
LIMIT 11 OFFSET 9;

-- Дополнительные запросы на основе предоставленных таблиц

-- Вернуть поля album_id, title и artist_id из таблицы album
SELECT album_id, title, artist_id
FROM public.album;

-- Вернуть поля artist_id и name из таблицы artist
SELECT artist_id, "name"
FROM public.artist;

-- Вернуть все поля из таблицы customer
SELECT customer_id, first_name, last_name, company, address, city, state, country, postal_code, phone, fax, email, support_rep_id
FROM public.customer;

-- Вернуть все поля из таблицы employee
SELECT employee_id, last_name, first_name, title, reports_to, birth_date, hire_date, address, city, state, country, postal_code, phone, fax, email
FROM public.employee;

-- Вернуть поля genre_id и name из таблицы genre
SELECT genre_id, "name"
FROM public.genre;

-- Вернуть все поля из таблицы invoice
SELECT invoice_id, customer_id, invoice_date, billing_address, billing_city, billing_state, billing_country, billing_postal_code, total
FROM public.invoice;

-- Вернуть все поля из таблицы invoice_line
SELECT invoice_line_id, invoice_id, track_id, unit_price, quantity
FROM public.invoice_line;

-- Вернуть поля media_type_id и name из таблицы media_type
SELECT media_type_id, "name"
FROM public.media_type;

-- Вернуть поля playlist_id и name из таблицы playlist
SELECT playlist_id, "name"
FROM public.playlist;

-- Вернуть все поля из таблицы playlist_track
SELECT playlist_id, track_id
FROM public.playlist_track;

-- Вернуть все поля из таблицы track
SELECT track_id, "name", album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price
FROM public.track;
