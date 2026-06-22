-- Genre_Statistics: table for storing the number of movies per genre
-- Additional feature in this solution: the table is created with the statistics from existing data.
SELECT 
	m.genre
	, count(*) as count -- number -> count
into Genre_Statistics
FROM movies m
group by m.genre
order by genre 
;
-- Updated Rows 10

select * from Genre_Statistics;
-- genre_statistics_init.csv

-- drop table Genre_Statistics;
