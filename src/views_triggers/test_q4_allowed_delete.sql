-- Check that the trigger allows DELETE when it should

create table movies_2 (like movies including all);
-- This table should have DELETE allowed, for all ids are new.

-- put trigger on it.
CREATE TRIGGER check_not_linked_to_rentals_2
BEFORE DELETE
ON movies_2
for each row
execute function trg_exception_if_linked_rentals()
;
-- Updated rows: 0. Done test 5, 20/6

-- add, delete rows
INSERT INTO movies_2 (title, release_year, genre, rating, duration, description, additional_info) VALUES
('Inception', 2010, 'Sci-Fi', 8.8, 148, 'A thief who steals corporate secrets through dream-sharing technology.', 
 '{"languages": ["English", "Japanese", "French"], "budget": 160000000, "box_office": 829895144, "director": "Christopher Nolan", "awards": ["Oscar", "BAFTA"]}'),
('The Dark Knight', 2008, 'Action', 9.0, 152, 'Batman battles the Joker in Gotham City.', 
 '{"languages": ["English", "Mandarin"], "budget": 185000000, "box_office": 1005455211, "director": "Christopher Nolan", "awards": ["Oscar", "Golden Globe"]}')
;
-- Updated rows 2

select * from movies_2 m; 
-- 2x8
-- movie_id = consecutive ints above 30 , exists on 20/6

delete from movies_2 where release_year= 2008;
-- Expected: DELETE should work OK here.
-- Actual: Updated Rows 1

select * from movies_2 m; 
-- Just 1 row, with release_year = 2010.

-- DROP TABLE movies_2;
