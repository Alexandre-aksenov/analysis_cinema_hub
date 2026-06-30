-- Создайте функцию GetCustomerStatus, 
-- которая принимает customer_id и возвращает статус клиента в зависимости от количества аренд.

drop function if exists GetCustomerStatus(int);


create function GetCustomerStatus(customer_id int)
returns varchar(10) as
$$
	select
		-- num_rentals_to_status(count(*)) -- optimization, to call 'count' only once.
		case when count(*) < 5 then 'Newbie' when count(*) <= 10 then 'Regular' else 'VIP' end
	from rentals r
	where r.customer_id = GetCustomerStatus.customer_id;
$$ language sql;


-- test for client 2 in the current data
select GetCustomerStatus(2) as total_client2;
-- Newbie , as expected.

