-- Stored procedure:
-- Input: customer_id 
-- ->
-- if the customer exists in table 'customers':
--   returns the number of movies, rented by this client,
--   and the total number of rentals,
-- else:
--   raise exception.


-- Calls the tables: rentals ; customers (for check of existence).

-- Interpretation of the outputs in this solution. If the client rented the same movie twice,
-- this contributes as +1 to num of movies, but +2 to the num of rentals.
-- Added feauture in this solution: raise an exception if the client does not exist.
create or replace procedure GetCustomerRentalCount_v2(
	p_id	 	int,
	out_movies	out int,
	out_rentals out int
)
language plpgsql
as $$
declare
  	-- id_exists int;
	id_exists boolean;
begin
	-- check  ID exisis -- -> EXISTS, see: https://blog.jooq.org/dont-even-use-count-for-primary-key-existence-checks/
	/*
	SELECT COUNT(*)
	INTO id_exists
	FROM customers c
	WHERE c.customer_id = p_id
	;
	*/ -- ->
	id_exists := (EXISTS (
		SELECT *
		FROM  customers c
		WHERE c.customer_id = p_id	
	));

	if not id_exists  then
		raise exception 'No customer with id=% could be found.', p_id;
	end if;

	-- count unique movies
	SELECT
		COUNT (distinct r.movie_id)
	INTO out_movies
	FROM rentals r
	WHERE r.customer_id = p_id
	;

	-- count all rentals
	SELECT
		COUNT (*)
	INTO out_rentals
	FROM rentals r
	WHERE r.customer_id = p_id
	;
end
$$;

-- --

-- Test the procedure by calling from a fn
create or replace function fn_GetCustomerRentalCount_v2(
	fn_id	int
)
returns Void
language plpgsql
as $$
declare
	proc_movies int;
	proc_rentals int;
begin
	call GetCustomerRentalCount_v2(fn_id, proc_movies, proc_rentals);
	raise notice 'The customer with (id=%) rented % different movie(s), with % total rental(s).', fn_id, proc_movies, proc_rentals;
  	return;
end
$$;


-- call on an inexisting client
select * from fn_GetCustomerRentalCount_v2(fn_id => 100);
-- -> ERROR (expected): No customer with id=100 could be found.

select * from fn_GetCustomerRentalCount_v2(fn_id => 2);
-- 1 different movies with 1 total rentals
