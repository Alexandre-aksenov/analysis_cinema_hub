-- Создайте триггер, который после добавления новой записи в таблицу Movie
-- автоматически будет увеличивать количество фильмов данного жанра в таблице Genre_Statistics.
-- TOADAPT from q4 (counting)

-- fn
create or replace function trg_incement_genre_cnt()
returns trigger
language plpgsql
as $$
declare
  rows_genre_cnt smallint; -- shoud be 0 or 1.
begin
	-- Only increment after an INSERT operation
	if tg_op = 'INSERT' then
		select count(*) into rows_genre_cnt
		from Genre_Statistics s
		where s.genre = new.genre;

		-- insert row if needed
		if rows_genre_cnt = 0 then
	    	insert into Genre_Statistics(genre, count)
    		values (new.genre, 0);
		end if;

		-- increment value
		UPDATE Genre_Statistics SET count = count + 1
		where genre = new.genre;
	end if;
	return new;
end
$$;

-- trigger
create trigger incement_genre_cnt
after insert 
on movies
for each row
execute function trg_incement_genre_cnt();

-- Test on new tables movies_2, Genre_Statistics_2
-- See: ./src/test_q_10.sql
