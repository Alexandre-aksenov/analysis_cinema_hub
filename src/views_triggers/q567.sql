-- Q5. последовательность actor_sequence, которая будет генерировать уникальные значения для новых актеров
create sequence actor_sequence
  	as bigint
	start with 1000
 	increment by 1
  	no CYCLE
;
-- Updated Rows 0

-- Test the addition to 'actors' on auxiliary table. See: ./src/test_q7_auxiliary_table.sql 
-- Recreate the sequence.

-- Q6. Добавьте нового актера в таблицу Actor, используя значение из созданной последовательности для поля actor_id.
begin;
INSERT INTO actors (actor_id, first_name, last_name, birth_date, nationality) VALUES
	(nextval('actor_sequence'), 'George', 'Clooney', '1961-05-06', 'American')
;
select * from actors; -- 31 x 5, new 1 row (number 31) has actor_id = 1000. OK
commit;
commit;
select * from actors; -- same as before committing.

-- select nextval('actor_sequence') as fst_val;

-- Обновите последовательность, чтобы начальное значение было на 10 больше последнего созданного значения
select setval('actor_sequence', currval('actor_sequence') + 10, false) as add_10_to_seq; -- 1010
select nextval('actor_sequence') as incr_after_adding_10; 
-- 1010

select nextval('actor_sequence') as incr2_after_adding_10;
-- 1011
