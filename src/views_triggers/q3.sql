-- Q3. триггер, который автоматически обновляет поле rental_date в таблице rentals на текущую дату, 
-- если пользователь пытается вставить запись с пустым значением rental_date.

-- Function
create or replace function trg_curr_date()
returns trigger
language plpgsql
as $$
begin
	IF new.rental_date is null THEN
		new.rental_date := now()::date;
	end if;
	return new;
end
;
$$;
-- Updated Rows: 0


create trigger set_curr_date_as_default
before insert 
on rentals
for each row
execute function trg_curr_date()
;
-- Updated Rows: 0



-- Test.

-- Create an copy of the table "rentals" and put a trigger on it.
create table rentals_2 (like rentals including all);

select * from rentals_2 r;
-- ->  5 columns, but no data

create trigger set_curr_date_as_default_2
before insert 
on rentals_2
for each row
execute function trg_curr_date()
;


-- Insert a row with a rental date
INSERT INTO rentals_2 (customer_id, movie_id, rental_date, return_date) VALUES
(1, 1, '2022-03-10', '2022-03-14')
;
-- Updated rows: 1

select * from rentals_2 r;
-- 1x6
-- RDBMS incremented the sequence: rental_id = 32


-- Insert a row without, meaning that the customer is renting the movie today. 
INSERT INTO rentals_2 (customer_id, movie_id, rental_date, return_date) VALUES
(1, 1, NULL, NULL);
-- Updated rows: 1


select * from rentals_2 r;
-- 2x6
-- RDBMS incremented the sequence: rental_id = 33
-- and replaced 'rental_date' in the 2nd row by 2026-06-19 (today)
-- -> res/rentals_q3.csv


