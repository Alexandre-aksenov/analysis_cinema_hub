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
	
-- TOCHECK: заменяет NULL на 0
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
