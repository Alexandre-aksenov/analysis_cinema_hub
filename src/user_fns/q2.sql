-- Fn GetMoviesByDirector: 
-- director's name
-- -> 
-- table of all movies of this director with fields:
-- movie's title,
-- release year
-- genre.


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
	-- filter on director, with the cond that the full name in data should contain the argument.
	-- Note: this syntax is specific to PostgreSQL
	where position(director_name IN (m.additional_info -> 'director')::text) > 0
$$;


-- tests
select * from GetMoviesByDirector_v2(director_name => 'Christopher Nolan');
-- 4x3
-- Inception
-- The Dark Knight
-- The Prestige
-- Memento

select * from GetMoviesByDirector_v2(director_name => '"Christopher Nolan"');
-- Same 4 movies.

select * from GetMoviesByDirector_v2(director_name => 'Nolan');
-- Same 4 movies.

-- Ccl. This fn is relatively simple to use,
-- as the user may give only the family name and may omit quotes.

