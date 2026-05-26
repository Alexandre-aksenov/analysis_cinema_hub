-- Tested on https://sqliteonline.com/, Demo Serber PostgreSQL on 26/5/2026.

SELECT version();
-- PostgreSQL 17.9 (Debian 17.9-1.pgdg13+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 14.2.0-19) 14.2.0, 64-bit

CREATE TABLE ex_movies (
    movie_id SERIAL PRIMARY KEY,
    genre VARCHAR(100)
);

INSERT INTO ex_movies (genre) VALUES
('Sci-Fi'),
('Action'),
('Action')
;

CREATE TABLE ex_rentals (
    movie_id INT REFERENCES ex_movies(movie_id)
);

INSERT INTO ex_rentals (movie_id) VALUES
(1),
(1),
(2),
(2),
(2)
;

-- Tested queries
select 
	m.movie_id,
	m.genre 
from ex_movies m 
inner join ex_rentals r on m.movie_id = r.movie_id
;
/*
 "movie_id","genre"
1,Sci-Fi
1,Sci-Fi
2,Action
2,Action
2,Action

As many rows for each movie as there are rentals, as expected.  
   */
 

with id_genre as (
		select 
		m.movie_id,
		m.genre 
	from ex_movies m 
	inner join ex_rentals r on m.movie_id = r.movie_id
)
select
	genre,
    count(*)
from id_genre
group by genre
order by count desc
;
/*
"genre","count"
Action,3
Sci-Fi,2

Corresponds to the data in the table "ex_rentals". OK.
 */




-- Drop testing tables 
drop table "ex_rentals";
drop table "ex_movies";
