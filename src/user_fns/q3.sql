-- Q3. Fn CalculateCustomerRentalCos:
-- customer_id,
-- a constant price of 1 movie (default: 5$)
-- ->
-- the total cost of rentals by this client.

drop function if exists CalculateCustomerRentalCost(int, float);


create or replace function CalculateCustomerRentalCost(customer_id int, unit_price float default 5.0)
returns float -- Possible improvent in readability: type Money
language sql as
$$
	select
		count(*) * unit_price
	from rentals r
	where r.customer_id = CalculateCustomerRentalCost.customer_id;
$$;


-- test for customer 2
select CalculateCustomerRentalCost(customer_id => 2) as total_client2;
-- 5 , as expected  

