-- триггер, который при обновлении поля return_date в таблице rentals устанавливает текущую дату, если поле NULL,
-- и оставляет значение без изменений, если оно больше текущей даты

-- Added logic in this version: 
-- keep the date if it's before the current one, raise a warning if it's after.

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
before insert 
on rentals
for each row
execute function trg_return_default_current()
;



