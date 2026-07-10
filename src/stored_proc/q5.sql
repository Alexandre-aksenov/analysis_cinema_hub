-- Stored procedure, которая  рассчитывает общую выручку от аренды фильмов для указанного клиента.
-- Input: customer_id, unit_price (added optional parameter)
-- ->
-- print the total cost for this client.
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
call CalculateRentalRevenue(2);
-- The customer with id=2 spent 5 on renting movies.
