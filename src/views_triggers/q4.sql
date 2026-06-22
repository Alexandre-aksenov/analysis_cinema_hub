-- Q4. Trigger, which prevents deleting records about movies, which have already been rented.
-- Added value compared to Foreign Key Constraint (already present in the table 'rentals' in the current scheme):
-- the custom error message contains the title of the movie.

-- fn for checking whether the attempted delete is used in rentals.
create or replace function trg_exception_if_linked_rentals()
returns trigger
language plpgsql
as $$
declare
  rent_cnt int;
begin
  -- Only check a DELETE operation
	if tg_op = 'DELETE' then
		select count(*) into rent_cnt
		from rentals r
		where r.movie_id = old.movie_id;

		-- if the movie's id is in the table "rentals", DELETE should be prevented
	    if rent_cnt > 0 then 
      		raise exception
        	'Cannot remove the movie % .',
        	old.title
        	using errcode = '23503'; -- Same code as for Foreign Key Constraint
    	end if;
	
	end if;
  	
	return old;
end;
$$;
-- Updated rows: 0. 


CREATE TRIGGER check_not_linked_to_rentals
BEFORE DELETE
ON movies
for each row
execute function trg_exception_if_linked_rentals()
;
-- Updated rows: 0

-- Tests.
-- The trigger allows DELETE, as expected, in:  /src/views_triggers/test_q4_allowed_delete.sql 
-- The trigger forbids DELETE, as expected, in: /src/views_triggers/test_q4_forbidden_delete.sql

