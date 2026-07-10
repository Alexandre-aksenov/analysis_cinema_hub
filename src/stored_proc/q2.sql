-- Stored procedure:
-- Input:  customer_id 
-- ->
-- number of movies, rented by this client, а также сумму всех аренд (общее количество записей).
-- total number of rentals.

-- Calls the tables: rentals ; customers (for check of existence).

-- Interpretation of the outputs in this solution. If the client rented the same movie twice,
-- this contributes as +1 to num of movies, but +2 to the num of rentals.
-- Added feauture in this solution: raise an exception if the client does not exist.
create or replace procedure GetCustomerRentalCount(
	p_id	 	int,
	out_movies	out int,
	out_rentals out int
)
language plpgsql
as $$
declare
  	id_exists int;
begin
	-- check  ID exisis
	SELECT COUNT(*)
	INTO id_exists
	FROM customers c
	WHERE c.customer_id = p_id
	;
	if id_exists = 0 then
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


-- -- --


-- Test the procedure by calling from a fn
create or replace function fn_GetCustomerRentalCount(
	fn_id	int
)
returns Void
language plpgsql
as $$
declare
	proc_movies int;
	proc_rentals int;
begin
	call GetCustomerRentalCount(fn_id, proc_movies, proc_rentals);
	raise notice 'The customer with (id=%) rented % different movie(s), with % total rental(s).', fn_id, proc_movies, proc_rentals;
  	return;
end
$$;


-- call on an inexisting client
select * from fn_GetCustomerRentalCount(fn_id => 100);
-- -> ERROR (expected): No customer with id=100 could be found.


select * from fn_GetCustomerRentalCount(fn_id => 2);
-- 1 different movies with 1 total rentals


-- Test on surrogate data, where the 2 outputs differ: TODO next

