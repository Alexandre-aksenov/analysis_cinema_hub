-- Genre_Statistics: table for storing the number of movies per genre
-- Additional feature in this solution: the table is created with the statistics from the existing data.
SELECT 
	m.genre
	, count(*) as count
into Genre_Statistics
FROM movies m
group by m.genre
order by genre 
;
-- Updated Rows 10

select * from Genre_Statistics;
-- -> res/genre_statistics_init.csv


