-- Create an auxiliary table for testing insertion from a sequence
create table actors_2 (like actors including all);


-- add 2 actors from the main data
INSERT INTO actors_2 (first_name, last_name, birth_date, nationality) VALUES
('Leonardo', 'DiCaprio', '1974-11-11', 'American'),
('Joseph', 'Gordon-Levitt', '1981-02-17', 'American');
-- Updated Rows 2

select * from actors_2;
-- actor_id: 31, 32

-- add the next value fom sequence
INSERT INTO actors_2 (actor_id, first_name, last_name, birth_date, nationality) VALUES
	(nextval('actor_sequence'), 'George', 'Clooney', '1961-05-06', 'American')
;
-- Updated Rows 1

select * from actors_2;
-- actor_id: 31, 32, 1000

-- drop table actors_2;
-- drop sequence actor_sequence;
