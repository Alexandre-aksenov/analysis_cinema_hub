-- Fn GetCustomerStatus:
-- customer_id 
-- ->
-- client's status as function of the number of rentals.

drop function if exists GetCustomerStatus(int);


create or replace function GetCustomerStatus(customer_id int)
returns varchar(10) 
language sql as
$$
	select
		case when count(*) < 5 then 'Newbie' when count(*) <= 10 then 'Regular' else 'VIP' end
	from rentals r
	where r.customer_id = GetCustomerStatus.customer_id;
$$;


-- test for client 2 in the current data
select GetCustomerStatus(customer_id => 2) as total_client2;
-- Newbie , as expected.

-- A more complete test (with different numbers of rentals) is located in the script 
-- test_q4.sql

