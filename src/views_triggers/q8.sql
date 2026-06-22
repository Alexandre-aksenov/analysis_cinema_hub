-- Q8. Trigger, which replaces NULL by the current date at update of the field 'return_date' in table 'rentals'
-- and leaves the value without change, if it is after the current date.

-- Added logic in this version:
-- the trigger keeps the date, which has been entered,  raise a warning if it's before or after the current one.

-- Function
create or replace function trg_return_default_current()
returns trigger
language plpgsql
as $$
begin
	IF (new.return_date is null) THEN
		RAISE WARNING 'Replaced the return date (movie with id=%) by the current date',
			new.movie_id; 
		new.return_date := now()::date;
	elsif (new.return_date < now()::date) THEN
		RAISE WARNING 'Reported return date (movie with id=%) is old.',
			new.movie_id;
	elsif (new.return_date > now()::date) THEN
		RAISE WARNING 'Reported return date (movie with id=%) is in future.',
			new.movie_id;
	end if;
	return new;
end
$$;


-- trigger
create trigger set_return_curr_date_as_default
before update
on rentals
for each row
execute function trg_return_default_current()
;



