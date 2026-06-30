-- Q1. Fn: movie_id -> length in hours (rounded to 2 decimals)

drop function if exists GetMovieDurationInHours(int);

create function GetMovieDurationInHours(m_id int)
returns float as -- Possible improvent in readability: type DECIMAL(3,2)
$$
	SELECT round(m.duration / 60., 2)
	from movies m
	WHERE m.movie_id = m_id
$$ language sql;

-- test
select GetMovieDurationInHours(2) as duration_movie2;
--  -> 2.53 h
-- Converted as expected from 152 min.
