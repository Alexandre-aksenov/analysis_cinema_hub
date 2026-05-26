-- Q3. название фильмов, чья продолжительность больше средней продолжительности всех фильмов в базе данных

-- Auxiliary table: add a column for the mean duration
select 
	title,
	duration,
	avg(duration) over () as avg_duration
from movies m
; 
-- 30x3
-- avg(duration) == 131.6 min
-- -> movies_avg.csv

-- Final query
select 
	title
from (select 
		title,
		duration,
		avg(duration) over () as avg_duration
	from movies m) m_avg
where m_avg.duration > m_avg.avg_duration 
;
-- 15 movies, which represent exactly the half of all movies.
-- -> movies_longer_than_avg.csv

-- Q2. список всех клиентов и, если они совершали аренды, то укажите дату последней аренды.
--

-- Join "clients" with "orders".
select
	c.*,
	r.customer_id as rental_cid,
	r.rental_date 
from customers c 
left join rentals r on r.customer_id = c.customer_id 
;

-- Agregate on "client_id": client's data (first), latest rental_date (max)
select
	customer_id,
	string_agg(first_name, ', ' order by first_name) as first_name,
	string_agg(last_name, ', ' order by first_name) as last_name,
	string_agg(email, ', ' order by first_name) as email,
	max(rental_date) as latest_rental
from (
	select
		c.*,
		r.customer_id as rental_cid,
		r.rental_date 
	from customers c 
	left join rentals r on r.customer_id = c.customer_id
	)
group by customer_id
order by customer_id
;
-- 31 (clients) x 5
-- Решение работает, но кажется неоптимальным: если удастся избавиться от промежуточной таблицы,
-- то "движок" Постгрес будет знать, что есть только одно имя на данный id.

