-- Fn GetMostPopularGenre:
-- (no input) -> the genre with most rentals.

-- This solution is based on Q4 from ./main2.sql ,
-- but the logic is optimized and adapted to a single output string


drop function if exists GetMostPopularGenre();
drop function if exists GetMostPopularGenre_v2();

/*
 -- query from homework 4.
  
with id_genre as (
		select 
		m.movie_id,
		m.genre 
	from movies m 
	inner join rentals r on m.movie_id = r.movie_id
)
select
	genre,
	count(*) as _cnt
from id_genre
group by genre
order by _cnt desc, genre
limit 1
;
-- genre=Animation , count=7
-- T=0.420
*/

/*
-- double CTE. this can be optimized
create function GetMostPopularGenre
( out genre text) AS
$$
with id_genre as (
		select 
		m.movie_id,
		m.genre 
	from movies m 
	inner join rentals r on m.movie_id = r.movie_id
),
count_genre as (
select
	genre,
	count(*)
from id_genre
group by genre
order by count desc, genre
limit 1 )
SELECT genre 
from count_genre
;
$$ language sql;

-- test
select GetMostPopularGenre() as most_popular;
-- most_popular=Animation


-- Check a shorter query (smaller num of subtables)
select 
	m.genre
	-- , count(*) -- led to T=0.392
from movies m 
inner join rentals r on m.movie_id = r.movie_id
group  by m.genre
order by count(*) desc
limit 1
;
-- time: 361
*/

-- faster fn
create or replace function GetMostPopularGenre()
returns text
language sql
AS
$$
	select 
		m.genre
	from movies m 
	inner join rentals r on m.movie_id = r.movie_id
	group  by m.genre
	order by count(*) desc
	limit 1
$$;

-- test
select GetMostPopularGenre() as most_popular;
-- most_popular=Animation

-- For testing that the answer is indeed based on rentals,
-- a second test on data, where the movies and rentals
-- lead to different answers,
-- is in the script ./test_q5.sql .



