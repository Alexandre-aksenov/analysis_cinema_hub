-- 2 additional tables: movies_2, Genre_Statistics_2
create table movies_2  (like movies including all);
create table Genre_Statistics_2
	(genre VARCHAR(100),
	count int
);


-- This testing trigger is analogous to the main one.
create or replace function trg_incement_genre_cnt_2()
returns trigger
language plpgsql
as $$
declare
  rows_genre_cnt smallint; -- shoud be 0 or 1.
begin
	-- Only increment after an INSERT operation
	if tg_op = 'INSERT' then
		select count(*) into rows_genre_cnt
		from Genre_Statistics_2 s
		where s.genre = new.genre;

		-- insert row if needed
		if rows_genre_cnt = 0 then
	    	insert into Genre_Statistics_2(genre, count)
    		values (new.genre, 0);
		end if;

		-- increment value
		UPDATE Genre_Statistics_2 SET count = count + 1
		where genre = new.genre;
	end if;
	return new;
end
$$;

-- trigger
create trigger incement_genre_cnt_2
after insert 
on movies_2
for each row
execute function trg_incement_genre_cnt_2();


-- add 3 movies, 2 of which of the same genre, one by one.
INSERT INTO movies_2 (title, release_year, genre, rating, duration, description, additional_info) VALUES
('Inception', 2010, 'Sci-Fi', 8.8, 148, 'A thief', 
 '{"languages": ["English", "Japanese", "French"]}');

select * from movies_2; -- 1x8
select * from Genre_Statistics_2;
-- 1x2.
-- genre = 'Sci-Fi' , count = 1
-- {row added correctly}

INSERT INTO movies_2 (title, release_year, genre, rating, duration, description, additional_info) VALUES
('The Dark Knight', 2008, 'Action', 9.0, 152, 'Batman', 
 '{"languages": ["English", "Mandarin"]}');

select * from movies_2; -- 2x8
select * from Genre_Statistics_2;
-- 2x2.
-- Row 1. genre = 'Sci-Fi' , count = 1
-- Row 2. genre = 'Action' , count = 1
-- {rows added correctly}

INSERT INTO movies_2 (title, release_year, genre, rating, duration, description, additional_info) VALUES
('Avatar', 2009, 'Sci-Fi', 7.8, 162, 'A paraplegic Marine', 
 '{"languages": ["English", "Spanish"]}');

select * from movies_2; -- 3x8
select * from Genre_Statistics_2;
-- 2x2.
-- Row 1. genre = 'Action' , count = 1
-- Row 2. genre = 'Sci-Fi' , count = 2
-- {the count for 'Sci-Fi' incremented correctly}
-- {Remark: the genres switched places, but this does not violate specifications, for the order of rows is not specified for this table}


-- drop function trg_incement_genre_cnt_2() CASCADE;
-- drop table movies_2;
-- drop table Genre_Statistics_2;
