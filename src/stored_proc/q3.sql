-- Stored procedure 'UpdateMovieRating', which updates the movie's rating.
-- Input: movie_id, new_rating
-- ->
-- If the movie exists and new rating is between 0.0 and 10.0: 
--   updates the rating
-- else:
--   raises exception.

-- Updates TABLE movies .
create or replace procedure UpdateMovieRating(
	movie_id int,
	new_rating DECIMAL(2,1)
)
language plpgsql
as $$
declare
  	-- id_exists int;
	id_exists boolean;
begin
	-- check the new rating is valid
	if (new_rating < 0) or (new_rating >= 9.95) then
		raise exception 'The new rating = % is invalid.', new_rating;
	end if;

	-- check the id exists. This syntax relies on the fact m.movie_id is the unique primary key. 
	id_exists := (EXISTS 
	(COUNT(*)
		FROM movies m
		WHERE m.movie_id = UpdateMovieRating.movie_id
	));

	if NOT id_exists then
		raise exception 'No movie with id=% could be found.', movie_id;
	end if;

	
	-- update the rating
	UPDATE movies m SET rating = new_rating
	WHERE  m.movie_id = UpdateMovieRating.movie_id;
end;
$$;

-- test in a small table -> ./test_q3.sql
