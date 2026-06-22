-- Test:
-- Create an mirror of the table "rentals" and put a trigger on it.

drop trigger set_curr_date_as_default_3 on rentals_3;
drop table if exists rentals_3;


create table rentals_3 (like rentals including all);

select * from rentals_3 r;
-- ->  5 columns, but no data

-- trigger


create trigger set_curr_date_as_default_3
before update
on rentals_3
for each row
execute function trg_return_default_current()
;
-- Updated rows 0


-- 4 customers rent movies, which leads to INSERTing 4 rows without return_date.
INSERT INTO rentals_3 (customer_id, movie_id, rental_date, return_date) VALUES
(1, 1, '2026-03-10', NULL),
(2, 2, '2026-03-10', NULL),
(3, 3, '2026-04-28', NULL),
(4, 4, '2026-05-10', NULL)
;



select * from rentals_3 r;
-- 4x5, 4 consecutive rental_id above 30 

-- The customers return movies, which leads to  UPDATing return_date.
update rentals_3 r set return_date = NULL
where customer_id = 1;
-- Replaces the return date (movie with id=1) by the current date
-- raising a warning:


select * from rentals_3 r;
-- 4x5.
-- id=1 -> return_date = today.

update rentals_3 r set return_date = '2022-03-14' -- past return date
where customer_id = 2;
-- Replaces the return date (movie with id=2) by the given date,
-- raising a warning: Reported return date (movie with id=2) is old.

select * from rentals_3 r;
-- 4x5


update rentals_3 r set return_date = now()::date -- current return date
where customer_id = 3;
-- Replaces the return date (movie with id=1) by the current date.

select * from rentals_3 r;
-- 4x5.

update rentals_3 r set return_date = '2027-03-14' -- future return date
where customer_id = 4;
-- Replaces the return date (movie with id=2) by the given date,
-- raising a warning: Reported return date (movie with id=4) is in future.

select * from rentals_3 r;
-- 4x5, all NULLs are filled.

