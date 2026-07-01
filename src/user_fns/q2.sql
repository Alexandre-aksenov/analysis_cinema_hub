-- Fn GetMoviesByDirector: 
-- director's name
-- -> 
-- table of all movies of this director with fields:
-- movie's title,
-- release year
-- genre.

-- Added feature: this function does not require the full name,
-- but can process just a part of it.
-- Current limitation: if the names of several directors contain the given string,
-- the movies of all of them are expected to appear together in the output.


create or replace function GetMoviesByDirector
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


-- Tests.

select * from GetMoviesByDirector(director_name => 'Christopher Nolan');
-- 4x3
-- Inception
-- The Dark Knight
-- The Prestige
-- Memento

select * from GetMoviesByDirector(director_name => '"Christopher Nolan"');
-- Same 4 movies.

select * from GetMoviesByDirector(director_name => 'Nolan');
-- Same 4 movies.

-- Ccl. This fn is relatively simple to use,
-- as the user may give only the family name and may omit quotes.

