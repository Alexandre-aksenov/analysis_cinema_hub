-- table before replacement
SELECT
	*
FROM "movies";

-- запрос, который выводит список фильмов, где рейтинг является NULL, и заменяет NULL на значение 0.
SELECT
	*
FROM "movies"
WHERE
	rating is null;
-- -> nothing. Replacement shout have no effect.	
	
-- TOCHECK (on an auxiliary table "movies_with_null"): заменяет NULL на 0
update "movies"
set rating = 0
where rating is null;

SELECT
	*
FROM "movies";

-- table afterwards
SELECT
	*
FROM "movies";

-- Q1 without attempt to modify the table
select 
	coalesce(m.movie_id, 0), 
	m.*
from movies m 
where m.movie_id is null
-- -> nothing, as all movies had a rating in initial data.

-- Q2. название фильма и округленное вверх значение рейтинга до ближайшего целого числа.
select
	title,
	ceil(rating) as ceil_rating
from 
	movies;
-- 30 x 2
-- -> res/tile_rating.csv

-- Q3. The list of clients, who registered last month.

-- First interpretation of the question: during the last month until today (2026)
select 
	customer_id,
	first_name,
	last_name,
	registration_date
from customers c 
where c.registration_date between now() - interval '1 month' and now() 
;
-- -> nothing, which is expected: all data in the table is historical, the Database was assembled in 2022.



-- Промежуточная таблица: вывести данные одного пользователя + сколько времени прошло от его регистрации до последней
select 
	customer_id,
	first_name,
	last_name,
	registration_date,
	MAX(registration_date) over () as latest,
	age(MAX(registration_date) over (), registration_date) as dur_before_latest
from customers c
;

-- Query for the 2nd interpretation
select
	customer_id,
	first_name,
	last_name,
	registration_date,
	latest,
	dur_before_latest
from (select 
		customer_id,
		first_name,
		last_name,
		registration_date,
		MAX(registration_date) over () as latest,
		age(MAX(registration_date) over (), registration_date) as dur_before_latest
	from customers c)
where dur_before_latest < interval '1 month'
;
-- -> 1 row x 6 cols 
-- id=12 , Mila Harris, registration date = latest = '2022-12-20'
