-- Create table analogous to 'movies'
drop table if exists movies_3;
drop procedure if exists UpdateMovieRating_3; 

CREATE TABLE movies_3 (
    movie_id smallint PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    genre VARCHAR(100),
    rating DECIMAL(2,1),
    duration INT,
    description TEXT,
    additional_info JSONB
);

-- insert 2 movies
INSERT INTO movies_3 (movie_id, title, release_year, genre, rating, duration, description, additional_info) VALUES
(1, 'Inception', 2010, 'Sci-Fi', 8.8, 148, 'A thief.', '{"languages": ["English"]}'),
(2, 'The Dark Knight', 2008, 'Action', 9.0, 152, 'Batman.', '{"languages": ["English", "Mandarin"]}');
-- Updated Rows: 2

select * from movies_3;
-- 2 movies with ratings 8.8, 9


-- create analogous procedure, which acts on the table 'movies_3' instead of 'movies'.
create or replace procedure UpdateMovieRating_3(
    movie_id int,
    new_rating DECIMAL(2,1)
)
language plpgsql
as $$
declare
    id_exists boolean;
begin
    -- check the new rating is valid
	if (new_rating < 0) or (new_rating >= 9.95) then
        raise exception 'The new rating = % is invalid.', new_rating;
    end if;

    -- check the id exists. This syntax relies on the fact m.movie_id is the unique primary key. 
    id_exists := (EXISTS (
	SELECT *
        FROM movies_3 m
        WHERE m.movie_id = UpdateMovieRating_3.movie_id
    ));

    if NOT id_exists then
        raise exception 'No movie with id=% could be found.', movie_id;
    end if;

    
    -- update the rating
    UPDATE movies_3 m SET rating = new_rating
    WHERE  m.movie_id = UpdateMovieRating_3.movie_id;
end;
$$;


-- tests
-- try to assign rating 10.5 ,
call UpdateMovieRating_3(2, 10.5);
-- ERROR (expected): The new rating = 10.5 is invalid.

-- Try to assign rating 10.0 to movie number 1. Both ways fail the value check in the procedure.
call UpdateMovieRating_3(1, 10.0);
-- ERROR (expected): The new rating = 10.0 is invalid.
call UpdateMovieRating_3(1, 9.99);
-- ERROR (expected): The new rating = 9.99 is invalid.

-- try to assign rating 9.5 to an inexisting movie 5
call UpdateMovieRating_3(5, 9.5);
-- ERROR (expected): No movie with id=5 could be found.

select * from movies_3;
-- same 2 movies as initially

-- assign rating 9.5 to movie number 2 
call UpdateMovieRating_3(2, 9.5);
-- Updated Rows: -1

select * from movies_3;
-- 2 movies with ratings 8.8, 9.5 , as expected.




call UpdateMovieRating_3(1, 9.27);
-- Updated Rows: -1

select * from movies_3;
-- Rounded the input and wrote the new rating of the movie 1 equal 9.3


