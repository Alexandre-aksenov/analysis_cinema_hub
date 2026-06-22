-- Q3. Trigger, which sets the field 'rental_date' in the table 'rentals' to the today's date 
-- if the user tries to insert a row with null value of 'rental_date'.

-- Function
create or replace function trg_curr_date()
returns trigger
language plpgsql
as $$
begin
	IF new.rental_date is null THEN
		new.rental_date := now()::date;
	end if;
	return new;
end
;
$$;
-- Updated Rows: 0


create trigger set_curr_date_as_default
before insert 
on rentals
for each row
execute function trg_curr_date()
;
-- Updated Rows: 0



-- Test.
-- See: ./src/views_triggers/test_q3.sql
