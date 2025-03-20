/*
Имя: Атобой Умаров
Задача: Создание SQL консоли и выполнение домашних заданий по SQL.

Информация о задаче:
1. Создать локальный репозиторий и ветку hw26.
2. Переключиться на новую ветку.
3. В DBeaver выбрать команду Open SQL console.
4. Сохранить файл в репозитории под именем hw1_on_sql.sql.
*/

-- 1
SELECT name, genre_id
FROM track;

-- 2
SELECT name AS song, unit_price AS price, composer AS author
FROM track;


-- 3
SELECT name AS song, duration / 60.0 AS duration_in_minutes
FROM track
ORDER BY duration_in_minutes DESC;


-- 4
SELECT name, genre_id
FROM track
LIMIT 15;


-- 5
SELECT *
FROM track
LIMIT 18446744073709551615 OFFSET 49;


-- 6
SELECT name
FROM track
WHERE size > 100 * 1048576;


-- 7
SELECT name, composer
FROM track
WHERE composer <> 'U2'
LIMIT 11 OFFSET 9;