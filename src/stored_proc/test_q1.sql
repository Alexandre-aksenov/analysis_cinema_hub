-- Create a small testing table analogous to 'movies'
drop table if exists movies_2;
drop procedure if exists AddNewMovie_2; 

create table movies_2 (like movies including all);


-- insert 2 movies
INSERT INTO movies_2 (title, release_year, genre, rating, duration, description, additional_info) VALUES
('Inception', 2010, 'Sci-Fi', 8.8, 148, 'A thief.', '{"languages": ["English"]}'),
('The Dark Knight', 2008, 'Action', 9.0, 152, 'Batman.', '{"languages": ["English", "Mandarin"]}');
-- Updated Rows: 2

select * from movies_2; 
-- -> 2 movies

-- create analogous procedure, which acts on table 'movies_2' rather than 'movies'
create or replace procedure AddNewMovie_2(
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
	r_existing_movie record;
BEGIN
	-- test whether a new movie is being added
	for r_existing_movie in
		SElECT
			m.title,
			m.release_year
		FROM movies_2 m
		where m.title = p_title AND m.release_year = p_release_year
  	loop
		-- Exception if the movie already exists
		raise exception 'AddNewMovie_2: the movie % already exists', p_title;
	end loop
	;

	-- insert the movie
	insert into movies_2 (title, release_year, genre, rating, duration, description, additional_info) VALUES
	(p_title, p_release_year, p_genre, p_rating, p_duration, p_description, p_additional_info);
END;
$$;
-- Updated Rows: 0

-- try to add an existing movie
call AddNewMovie_2(p_title => 'Inception', p_release_year => 2010, p_genre => 'Sci-Fi');
-- ERROR (expected):  AddNewMovie_2: the movie Inception already exists

SELECT * FROM movies_2;
-- 2 movies (inserted at the beginning of the script)


-- add an existing title with a new year
call AddNewMovie_2(p_title => 'Inception', p_release_year => 2020, p_genre => 'Sci-Fi');
-- Updated Rows: -1

SELECT * FROM movies_2;
-- 3 rows, the new row (duplicate data in the sense that the title is the same as in a previous row)
-- has been added.
-- The procedure allows adding a duplicate title with different release year,
-- as required by the statement.

-- add a true new movie
call AddNewMovie_2('Forrest Gump', 1994, 'Drama', 8.8, 142, 'The presidencies of Kennedy and Johnson.', 
 '{"languages": ["English"]}');
-- Updated Rows: -1

SELECT * FROM movies_2;
-- 4 rows, the last one corresponds to the new data.
