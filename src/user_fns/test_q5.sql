-- Testing the solution  of Q5 on more varied data

DROP FUNCTION IF EXISTS GetMostPopularGenre_2();
DROP TABLE IF EXISTS rentals_2;
DROP TABLE IF EXISTS movies_2;



CREATE TABLE movies_2 (
    movie_id SERIAL PRIMARY KEY,
    genre VARCHAR(100)
);

INSERT INTO movies_2 (genre) VALUES
('Sci-Fi'),
('Action'),
('Action')
;

CREATE TABLE rentals_2 (
    movie_id INT REFERENCES movies_2(movie_id)
);

INSERT INTO rentals_2 (movie_id) VALUES
(1),
(1),
(2),
(2),
(2)
;

-- Tests
select 
	m.genre
from movies_2 m 
inner join rentals_2 r on m.movie_id = r.movie_id
group  by m.genre
order by count(*) desc
limit 1;
-- "Action" as expected

-- fn
create or replace function GetMostPopularGenre_2()
returns text
language sql
AS
$$
	select 
		m.genre
	from movies_2 m 
	inner join rentals_2 r on m.movie_id = r.movie_id
	group  by m.genre
	order by count(*) desc
	limit 1
$$;

select GetMostPopularGenre_2() as most_popular;
-- "Action" as expected
