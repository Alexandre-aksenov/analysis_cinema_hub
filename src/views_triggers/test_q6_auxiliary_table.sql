-- Create an auxiliary table and sequence for testing insertion from a sequence
drop table if exists actors_2;
drop sequence if exists actor_sequence_2;

create table actors_2 (like actors including all);

create sequence actor_sequence_2
  	as bigint
	start with 1000
 	increment by 1
  	no CYCLE
;
-- Updated Rows 0

-- add 2 actors from the main data
INSERT INTO actors_2 (first_name, last_name, birth_date, nationality) VALUES
('Leonardo', 'DiCaprio', '1974-11-11', 'American'),
('Joseph', 'Gordon-Levitt', '1981-02-17', 'American');
-- Updated Rows 2

select * from actors_2;
-- actor_id: 2 consecutive above 30

-- add the next value fom sequence
INSERT INTO actors_2 (actor_id, first_name, last_name, birth_date, nationality) VALUES
	(nextval('actor_sequence_2'), 'George', 'Clooney', '1961-05-06', 'American')
;
-- Updated Rows 1

select * from actors_2;
-- actor_id: same id as above, 1000.
