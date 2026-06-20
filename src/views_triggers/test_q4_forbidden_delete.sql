-- Check that the trigger prevents DELETE when it should
CREATE TABLE movies_3 (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    genre VARCHAR(100),
    rating DECIMAL(2,1),
    duration INT,
    description TEXT,
    additional_info JSONB
);
-- This table will contain movies with id = 1,2,3, ... : same ones as for the original table "movies".
-- DROP TABLE movies_3;

select * from movies_3 m; 

-- put trigger on it.
CREATE TRIGGER check_not_linked_to_rentals_3
BEFORE DELETE
ON movies_3
for each row
execute function trg_exception_if_linked_rentals()
;
-- Updated rows: 0. Done, test 4, 20/6


-- add 2 rows.
INSERT INTO movies_3 (title, release_year, genre, rating, duration, description, additional_info) VALUES
('Inception', 2010, 'Sci-Fi', 8.8, 148, 'A thief who steals corporate secrets through dream-sharing technology.', 
 '{"languages": ["English", "Japanese", "French"], "budget": 160000000, "box_office": 829895144, "director": "Christopher Nolan", "awards": ["Oscar", "BAFTA"]}'),
('The Dark Knight', 2008, 'Action', 9.0, 152, 'Batman battles the Joker in Gotham City.', 
 '{"languages": ["English", "Mandarin"], "budget": 185000000, "box_office": 1005455211, "director": "Christopher Nolan", "awards": ["Oscar", "Golden Globe"]}')
;
-- Updated rows: 2. Done 3, 20/6

select * from movies_3 m; 
-- 2 rows with movie_id = 1, 2

select count(*)
from rentals r
where r.movie_id = 2;

select count(*)
from movies_3 m
inner join rentals r on r.movie_id = m.movie_id
where m.release_year= 2008;
-- Both queries return 1 : the condition inside fn should be satisfied

-- Attempt to delete fails
delete from movies_3 where release_year= 2008;
-- SQL Error [23503]: ERROR: Cannot remove the movie The Dark Knight .
--  Where: PL/pgSQL function trg_exception_if_linked_rentals() line 14 at RAISE


select * from movies_3 m;
-- Both rows remain
