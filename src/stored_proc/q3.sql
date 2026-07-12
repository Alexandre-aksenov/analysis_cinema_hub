-- Attempts to convert the input to DECIMAL(2,1),
-- returns -1 if input is out of range.
-- In terms of specific constants:
-- if  0.0 <= input < 9.95: 
--   returns input converted to  DECIMAL(2,1)
-- else:
--   returns -1.
create or replace function Attempt_convert_to_decimal21(
	input float
)
returns DECIMAL(2,1)
language plpgsql as
$$
declare
begin
	return input::DECIMAL(2,1);
	exception
    when numeric_value_out_of_range then
		return -1::DECIMAL(2,1); -- -1 encodes an input out of bounds
end;
$$;


-- Stored procedure 'UpdateMovieRating', which updates the movie's rating.
-- Input: movie_id, new_rating
-- ->
-- If the movie exists and 0.0 <= new rating < 9.95: 
--   updates the rating
-- else:
--   raises exception.

-- The upper bound 9.95 for the new rating guarantees the possibility to
-- convert to the type DECIMAL(2,1) .
-- As for the lower bound, this procedure rejects any negative input.


-- Updates TABLE movies .
create or replace procedure UpdateMovieRating(
	movie_id int,
	new_rating DECIMAL(2,1)
)
language plpgsql
as $$
declare
	id_exists boolean;
begin
	-- check the new rating is valid
	if Attempt_convert_to_decimal21(new_rating) < 0 then
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
