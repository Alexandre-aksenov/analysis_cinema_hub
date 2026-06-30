-- Fn GetMoviesByDirector: 
-- имя режиссера в качестве 
-- -> таблицу с названием фильма,
-- годом выпуск
-- и жанром для всех фильмов этого режиссера.


create or replace function GetMoviesByDirector_v2
(director_name text)
returns table (
	title VARCHAR(255),
	release_year INT,
	genre VARCHAR(100)
)
language sql as
$$
	select
		m.title
		, m.release_year
		, m.genre
	from movies	m
	-- filter on director, this instruction is specific to PostgreSQL
	where position(director_name IN (m.additional_info -> 'director')::text) > 0
$$;


-- tests
select * from GetMoviesByDirector_v2(director_name => 'Christopher Nolan');
-- 4x3
-- Inception
-- The Dark Knight
-- The Prestige
-- Memento
-- Time: 0.241

select * from GetMoviesByDirector_v2(director_name => '"Christopher Nolan"');
-- Same 4 movies.

-- Ccl. This fn is relatively simple to use,
-- as it can be called without extra quotes.

