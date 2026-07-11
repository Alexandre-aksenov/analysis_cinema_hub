-- Stored procedure, which computes the total amount spent by a client, by cliing the procedure in Q2.
-- Input: customer_id, unit_price (added optional parameter)
-- ->
-- if the customer exists in table 'customers':
--   print the total amount spent by this client,
-- else:
--   raise exception.
create or replace procedure CalculateRentalRevenue(
	customer_id int,
	unit_price float default 5.0
)
language plpgsql
as $$
declare
	num_movies int;
	num_rentals int;
	total_amount float;
begin
	-- body of the procedure
	call GetCustomerRentalCount(customer_id, num_movies, num_rentals); -- procedure from Q2
	total_amount := unit_price * num_rentals;

	-- print the result
	raise notice 'The customer with id=% spent % on renting movies.', customer_id, total_amount;
end
$$;

-- test
-- nonexisting client
call CalculateRentalRevenue(100);
-- ERROR (expected): No customer with id=100 could be found.

call CalculateRentalRevenue(2);
-- The customer with id=2 spent 5 on renting movies.
