-- Test:
-- Create an mirror of the table "rentals" and put a trigger on it.
create table rentals_3 (like rentals including all);

select * from rentals_3 r;
-- ->  5 columns, but no data

create trigger set_curr_date_as_default_3
before insert 
on rentals_3
for each row
execute function trg_return_default_current()
;
-- Updated rows 0


-- Insert 3 rows with:
-- 		a past return date (expected to be replaced by the current date),
-- 		without a return date (expected to be replaced by the current date),
-- 		a future return date (expected to remain as it is). 
INSERT INTO rentals_3 (customer_id, movie_id, rental_date, return_date) VALUES
(1, 1, '2022-03-10', NULL), -- no return date
(2, 2, '2022-03-10', '2022-03-14'), -- past return date
(3, 3, '2026-04-28', now()::date), -- current return date
(4, 4, '2027-03-10', '2027-03-14') -- future return date
;
-- Updated rows: 4
-- Output:
-- Replaced the return date (movie with id=1) by the current date
-- Reported return date (movie with id=2) is old.
-- Reported return date (movie with id=4) is in future.
-- {the expected warnings have been raised}

select * from rentals_3 r;
-- 3x5, first return date has been replaced by the today's date
-- at the time of execution.
-- -> test_q8_rentals_null_replaced_by_current.csv

-- drop table rentals_3;


