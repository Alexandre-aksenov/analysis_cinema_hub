-- Q5. Sequence "actor_sequence", which can generate unique ids for new actors
create sequence actor_sequence
  	as bigint
	start with 1000
 	increment by 1
  	no CYCLE
;
-- Updated Rows 0

-- Test the addition to 'actors' on auxiliary table. See: ./src/views_triggers/test_q76auxiliary_table.sql

-- Q6. Add an actor to the table Actor, using the next value from the sequence as the value of actor_id.
begin;
INSERT INTO actors (actor_id, first_name, last_name, birth_date, nationality) VALUES
	(nextval('actor_sequence'), 'George', 'Clooney', '1961-05-06', 'American')
;
select * from actors; -- 31 x 5, new row (number 31) has actor_id = 1000. O
commit;
select * from actors; -- same as before committing.
-- -> 31actors_addition_from_seq.sql


-- Q7. Update the sequence, so that its value is increased by 10.
select setval('actor_sequence', currval('actor_sequence') + 10, false) as add_10_to_seq; -- 1010
select nextval('actor_sequence') as incr_after_adding_10; 
-- 1010

select nextval('actor_sequence') as incr2_after_adding_10;
-- 1011
