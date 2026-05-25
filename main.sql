-- Q1. запрос, который выводит список фильмов, где рейтинг является NULL, и заменяет NULL на значение 0.
-- 
select 
 	movie_id,
	title,
	release_year,
	genre,
	coalesce(m.rating, 0) as rating_replaced_by_zero,
	duration,
	description,
	additional_info
from movies m 
where m.rating is null
;
-- -> nothing, for all movies have a rating in initial data.

-- Auxiliary table for testing the query above. All "low" ratings (< 8) are replaced with nulls
select
	movie_id,
	title,
	release_year,
	genre,
	case when rating < 8 then null else rating  end as rating,
	duration,
	description,
	additional_info
from movies;
-- 30 x 8 like the original table "movies".
-- 3 nulls appear in the new column "rating"
-- -> res/auxiliary_movies.csv

-- Reproduce the SELECT part of the first query on the new table.
-- Selects low-rating movies, their rating being replaced by 0.
select 
	movie_id,
	title,
	release_year,
	genre,
	coalesce(m.rating, 0) as rating_replaced_by_zero, 
	duration,
	description,
	additional_info
from (select
	movie_id,
	title,
	release_year,
	genre,
	case when rating < 8 then null else rating  end as rating,
	duration,
	description,
	additional_info
from movies) m
where m.rating is null
;
-- 3 rows x 8 columns, null ratings in the auxiliary table are replaced by 0 as expected.
-- -> res/low_rating_movies.csv


-- Q2. название фильма и округленное вверх значение рейтинга до ближайшего целого числа.
--
select
	title,
	ceil(rating) as ceil_rating
from 
	movies;
-- 30 x 2
-- -> res/title_rating.csv

-- Q3. The list of clients, who registered last month.
--

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
-- -> id=12 , Mila Harris, registration date = latest = '2022-12-20'


-- Q4. количество дней, в течение которых каждый клиент держал у себя фильм.
select 
	customer_id,
	SUM(return_date - rental_date) over (partition by customer_id) as lending_time_days
from rentals;
-- -> column with all values equal to 4 (4 days, specifically in PostgreSQL:
-- https://wiki.postgresql.org/wiki/Working_with_Dates_and_Times_in_PostgreSQL#1._The_difference_between_two_DATES_is_always_an_INTEGER,_representing_the_number_of_DAYS_difference 
-- ).


-- Q5.запрос, который выводит название фильма в верхнем регистре.
--
select 
	UPPER(m.title) as title_upper
from
	movies m;
-- 30 x 1
-- -> res/TITLE.csv


-- Q6. первые 50 символов описания фильма. 
--
select 
	left(m.description, 50) as start_descr
from
	movies m;
-- 30 x 1


-- Q7. жанр и общее количество фильмов в каждом жанре.
--
select genre,
     count(*)
from movies
group by genre
order by genre
;
-- 10 x 2
-- -> genre_count.csv

-- Q8. название фильма, его рейтинг и место в рейтинге по убыванию рейтинга
--
select 
	title,
	rating,
	row_number() over (order by m.rating desc, title) as place
from movies m
;
-- 30 x 3
-- -> movies_by_rating.csv


-- Q9. название фильма, его рейтинг и рейтинг предыдущего фильма в списке по убыванию рейтинга.
--
select 
	title,
	rating,
	lag(rating) over (order by m.rating desc, title) as prev_rating
from movies m
order by m.rating desc, title
;
-- 30 x 3
-- -> title_rating_previous.csv

-- Q10. для каждого жанра выводит средний рейтинг фильмов в этом жанре, округленный до двух знаков после запятой.
--
select genre,
     round(avg(rating), 2) as avg_rating
from movies
group by genre
order by genre
;
-- 10 x 2
-- -> genres_avg_rating.csv
