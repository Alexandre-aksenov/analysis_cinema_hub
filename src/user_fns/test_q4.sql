drop function if exists GetCustomerStatus_2(int);
drop table if exists rentals_2;

-- create a table with all 3 situations for testing the answer to q4.



create table rentals_2 (like rentals including all);



-- insert 4 clients
-- (by hand in this ver; can be made shorter via calling fn on table(?), but this would make the test less obvious)
INSERT INTO rentals_2 (customer_id, movie_id, rental_date, return_date) values
(1, 1, '2022-03-01', '2022-03-05'),
(2, 1, '2022-03-02', '2022-03-06'), -- 5 rented
(2, 2, '2022-03-02', '2022-03-06'),
(2, 3, '2022-03-02', '2022-03-06'),
(2, 4, '2022-03-02', '2022-03-06'),
(2, 5, '2022-03-02', '2022-03-06'),
(3, 1, '2022-03-03', '2022-03-07'), -- 10 rented
(3, 2, '2022-03-03', '2022-03-07'),
(3, 3, '2022-03-03', '2022-03-07'),
(3, 4, '2022-03-03', '2022-03-07'),
(3, 5, '2022-03-03', '2022-03-07'),
(3, 6, '2022-03-03', '2022-03-07'),
(3, 7, '2022-03-03', '2022-03-07'),
(3, 8, '2022-03-03', '2022-03-07'),
(3, 9, '2022-03-03', '2022-03-07'),
(3, 10, '2022-03-03', '2022-03-07'),
(4, 1, '2022-03-04', '2022-03-08'), -- 11 rented
(4, 2, '2022-03-04', '2022-03-08'),
(4, 3, '2022-03-04', '2022-03-08'),
(4, 4, '2022-03-04', '2022-03-08'),
(4, 5, '2022-03-04', '2022-03-08'),
(4, 6, '2022-03-04', '2022-03-08'),
(4, 7, '2022-03-04', '2022-03-08'),
(4, 8, '2022-03-04', '2022-03-08'),
(4, 9, '2022-03-04', '2022-03-08'),
(4, 10, '2022-03-04', '2022-03-08'),
(4, 11, '2022-03-04', '2022-03-08')
;
-- updated rows 27


select * from rentals_2 r;
-- 27 x 5

-- create an analogous function for this table
create or replace function GetCustomerStatus(customer_id int)
returns varchar(10) 
language sql as
$$
	select
		case when count(*) < 5 then 'Newbie' when count(*) <= 10 then 'Regular' else 'VIP' end
	from rentals_2 r
	where r.customer_id = GetCustomerStatus.customer_id;
$$;


-- test the case 'Newbie'
select count(*) 
from rentals_2 r
where r.customer_id = 1;
-- 1

select GetCustomerStatus(1) as total_client1;
-- 'Newbie'


-- test the case 'Regular' (5 rentals)
select count(*) 
from rentals_2 r
where r.customer_id = 2;
-- 5

select GetCustomerStatus(2) as total_client2;
-- 'Regular'


-- test the case 'Regular' (10 rentals)
select count(*) 
from rentals_2 r
where r.customer_id = 3;
-- 10

select GetCustomerStatus(3) as total_client3;
-- 'Regular'


-- test the case 'VIP' (11 rentals)
select count(*) 
from rentals_2 r
where r.customer_id = 4;
-- 11

select GetCustomerStatus(4) as total_client4;
-- 'VIP'

-- All tests went as expected.

