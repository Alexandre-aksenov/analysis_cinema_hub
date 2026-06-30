-- Q3. Fn CalculateCustomerRentalCost, which takes 2 parameters:
-- customer_id 
-- and a constant price of 1 movie (default: 5$),
-- and returns the total cost of rentals by this client.

drop function if exists CalculateCustomerRentalCost(int, float);


-- TOFIX: this clause 'where' did not filter anything
/*
create function CalculateCustomerRentalCost(customer_id int, unit_price float default 5.0)
returns float as -- Possible improvent in readability: type Money
$$
	select
		count(*) * unit_price
	from rentals r
	where r.customer_id = customer_id;
$$ language sql; 


-- test
select CalculateCustomerRentalCost(2) as total_client2;
-- 150 (== 30 (all rentals) * 5) 
*/

/*
-- Correct fix, but does not fully answer the problem.
create function CalculateCustomerRentalCost(in_customer_id int, unit_price float default 5.0)
returns float as -- Possible improvent in readability: type Money
$$
	select
		count(*) * unit_price
	from rentals r
	where r.customer_id = in_customer_id;
$$ language sql; 

-- test
select CalculateCustomerRentalCost(2) as total_client2;
-- -> 5 , correct
*/

-- -- -- (solution to commit)
-- Names from statement.
-- See: 
-- https://www.telerik.com/blogs/avoiding-ambiguous-postgres-variables-without-prefixes#use-function-names
create function CalculateCustomerRentalCost(customer_id int, unit_price float default 5.0)
returns float as -- Possible improvent in readability: type Money
$$
	select
		count(*) * unit_price
	from rentals r
	where r.customer_id = CalculateCustomerRentalCost.customer_id;
$$ language sql;

-- test for movie 2
select CalculateCustomerRentalCost(2) as total_client2;
-- 5

