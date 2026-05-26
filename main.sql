-- Q3. Names of movies, whose length is above the mean length of all movies in the data.

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

-- Q2. List of all clients and the date of last rental if they rented movies indeed.
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

-- This soluition works, but seems suboptimal: if the intermediate query is switched to JOIN,
-- Postgres may become aware, that each id correspond to a single name, avoiding "string_agg".

-- Moreover, our data contain a single order per client, not allowing to test the correct selection of _latest_ rental.
-- Test on a tiny dataset may be added to answer this.


-- Q1. List of movies with the first and last names of actors.
-- The result is sorted by by the movie's name and the actor's name.

select
	m.title,
	a.first_name as actor_first_name,
	a.last_name as actor_last_name 
from movies m
left join movie_actors ma  on ma.movie_id = m.movie_id
left join actors a on a.actor_id = ma.actor_id
order by m.title, a.last_name  
;
-- 45 (movies-actors) x 3
-- Only 16 movies (the first 16 from the table "movies") have actors associated to their title,
-- but this corresponds to the lack in data: these movies are the ones which appear
--in the table "movie_actors".
-- -> names_movies_actors.csv

-- Q5. List of unique уникальных actors' names and clients' names.
select 
	c.first_name,
	c.last_name,
	'client'::VARCHAR(10) as type
from customers c
union
select
	a.first_name,
	a.last_name,
	'actor'::VARCHAR(10) as type
	-- 'actor' as type : also accepted, but leads to the type VARCHAR(10485760) on my machine
from actors a
order by "type", last_name 
;
-- 61 x 3
-- -> people.csv
-- This operator "union" filters repetition of clients or  repetition of actors. This is tested on small data 


-- Q4. Number of rents per genre.
-- The genres together with Number of rents. The table is sorted from the most popular to the least popular genre.
--

-- intermediate JOIN, for testing
select 
	m.movie_id,
	m.genre 
from movies m 
inner join rentals r on m.movie_id = r.movie_id
;


-- Full query.
with id_genre as (
		select 
		m.movie_id,
		m.genre 
	from movies m 
	inner join rentals r on m.movie_id = r.movie_id
)
select
	genre,
    count(*)
from id_genre
group by genre
order by count desc
;
-- 10 (genres) x 2
-- -> popularity_by_genre.csv

-- As our data contains one rental per movie, it cannot check whether the join was correct.
-- The answer happens to be the same as without taking rentals into account here:
select
	genre,
    count(*)
from movies
group by genre
order by count desc
;

-- The testing example test_inner_join.sql runs on small (but varied) testing data.
