-- Test the procedure 'GetCustomerRentalCount_v2' on a small table, 
-- where a movie has been rented twice by the same client.

DROP TABLE if exists rentals_2;
DROP PROCEDURE if exists GetCustomerRentalCount_2;
DROP FUNCTION if exists fn_GetCustomerRentalCount_2(int);


create table rentals_2 (like rentals including all);



-- insert a client,
-- who rented 2 movies, one of them twice.
INSERT INTO rentals_2 (customer_id, movie_id, rental_date, return_date) values
(1, 1, '2022-03-01', '2022-03-05'),
(1, 2, '2022-03-02', '2022-03-06'), -- rented twice
(1, 2, '2022-03-10', '2022-03-15');


-- Create an analogous procedure
create or replace procedure GetCustomerRentalCount_2(
	p_id	 	int,
	out_movies	out int,
	out_rentals out int
)
language plpgsql
as $$
declare
	id_exists boolean;
begin
	-- check  ID exists
	id_exists := (EXISTS (
		SELECT * FROM  customers c
		WHERE c.customer_id = p_id	
	));

	if not id_exists  then
		raise exception 'No customer with id=% could be found.', p_id;
	end if;

	-- count unique movies
	SELECT
		COUNT (distinct r.movie_id)
	INTO out_movies
	FROM rentals_2 r
	WHERE r.customer_id = p_id
	;

	-- count all rentals
	SELECT
		COUNT (*)
	INTO out_rentals
	FROM rentals_2 r
	WHERE r.customer_id = p_id
	;
end
$$;


-- call through a function
create or replace function fn_GetCustomerRentalCount_2(
	fn_id	int
)
returns Void
language plpgsql
as $$
declare
	proc_movies int;
	proc_rentals int;
begin
	call GetCustomerRentalCount_2(fn_id, proc_movies, proc_rentals);
	raise notice 'The customer with (id=%) rented % different movie(s), with % total rental(s).', fn_id, proc_movies, proc_rentals;
  	-- The fn returns void
  	return;
end
$$;



select * from fn_GetCustomerRentalCount_2(fn_id => 1);
-- The customer with (id=1) rented 2 different movie(s), with 3 total rental(s).
