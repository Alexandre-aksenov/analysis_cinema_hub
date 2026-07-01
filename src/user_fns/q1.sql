-- Q1. Fn: movie_id -> length in hours (rounded to 2 decimals)

drop function if exists GetMovieDurationInHours(int);

create or replace function GetMovieDurationInHours(m_id int)
returns DECIMAL(3,2)
language sql as
$$
	SELECT round(m.duration / 60., 2)::decimal(3,2)
	from movies m
	WHERE m.movie_id = m_id
$$;

-- test
select GetMovieDurationInHours(2) as duration_movie2;
--  -> 2.53 h
-- Converted as expected from 152 min.
