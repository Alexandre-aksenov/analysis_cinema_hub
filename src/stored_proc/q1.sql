-- Stored procedure:
-- Input: data of a new movie
-- ->
-- if the table 'movies' contains no movie with the given name and release date, add the movie,
-- otherwize raise exception.
create or replace procedure AddNewMovie_v2(
	p_title VARCHAR(255),
    p_release_year INT default NULL,
    p_genre VARCHAR(100) default NULL,
    p_rating DECIMAL(2,1) default NULL,
    p_duration INT default NULL,
    p_description TEXT default NULL,
    p_additional_info JSONB default NULL
)
language plpgsql
as $$
declare
	movie_exists boolean; 
BEGIN
	-- test whether a new movie is being added
	movie_exists := (EXISTS (
		SElECT
			m.title,
			m.release_year
		FROM movies m
		where m.title = p_title AND m.release_year = p_release_year	
	));

	if movie_exists  then
		raise exception 'AddNewMovie: the movie % already exists', p_title;
	end if;

	-- insert the movie
	insert into movies (title, release_year, genre, rating, duration, description, additional_info) VALUES
	(p_title, p_release_year, p_genre, p_rating, p_duration, p_description, p_additional_info);
END;
$$;

-- Test on a new table: test_q1.txt

