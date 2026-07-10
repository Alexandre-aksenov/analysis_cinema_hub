-- Хранимая процедура, которая принимает customer_id и возвращает:
-- количество фильмов, которые этот клиент арендовал, а также сумму всех аренд (общее количество записей).
-- Calls the table: rentals ; customers (for check of existence).

-- Interpretation of the two outputs. If the client rented the same movie twice,
-- this contributes as +1 for the number of movies, but +2 for the num of rentals.
-- Added feauture in this solution: raise an exception if the ID does not exist.
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
-- (test of query)
SELECT
	COUNT(distinct r.movie_id)
FROM rentals r
WHERE r.customer_id = 2
;


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
	raise notice 'The customer with (id=%) rented % different movies, with % total rentals.', fn_id, proc_movies, proc_rentals;
  	-- The fn returns void
  	return;
end
$$;


-- call on an inexisting client
select * from fn_GetCustomerRentalCount(fn_id => 100);
-- -> ERROR (expected): No customer with id=100 could be found.


select * from fn_GetCustomerRentalCount(fn_id => 2);
-- 1 different movies with 1 total rentals


-- Test on surrogate data, where the 2 outputs differ: TODO next

