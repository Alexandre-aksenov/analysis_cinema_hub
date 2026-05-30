SELECT version();
--"PostgreSQL 17.9 (Debian 17.9-1.pgdg13+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 14.2.0-19) 14.2.0, 64-bit"


-- Q1. Title of each movie and the list of available languages.
select
	m.title,
	m.additional_info -> 'languages' as languages
from movies m
;
-- -> 31 (movies) x 2
-- -> movies_lang.csv

-- Q2. List of movies with budget above 100 million $.
select
	m.title,
	m.additional_info -> 'budget' as budget
from movies m
where (m.additional_info -> 'budget')::int > 10^8 
;
-- 10(movies) x 2
-- Execution plan: single row.
-- -> titles_high_budget.csv


-- Q3. For each client, create a JSON-object containing 2 fields:
-- 		full_name (fulle clienbt's name),
-- 		contact (email and the phone number).
-- Show customer_id and the new JSON-object.
select
	c.customer_id,
	json_build_object
		(
		'full_name', c.first_name || ' ' || c.last_name ,
		'contact', json_build_object
			(
			'email', c.email,
			'phone', c.phone_number
			)
		) as contact
from customers c
;
-- 31 (clients) x 2
-- -> clients_name_contact.csv



-- Q4. Add a new genre ""Drama"" to the array of preferred_genres for all customers,
-- who are sighed in for the newsletter (detected by the key 'newsletter').
select 
 	c.first_name, -- for keeping all data from table
 	c.last_name,
 	c.email,
 	c.phone_number,
 	c.address,
 	c.registration_date,
 	case when (c.preferences -> 'newsletter')::bool
 		then jsonb_insert(c.preferences, '{preferred_genres,0}', '"Drama"'::jsonb)
 		else c.preferences
 	end
from customers c
;
-- 31 (clients) x 7
-- -> clients_expanded_preferences.csv


-- Q5. Average movie budget for each genre, rounded to the closest integer.
select 
	m.genre,
	AVG((m.additional_info -> 'budget')::int)::int 
from movies m
group by m.genre
order by genre 
;
-- 10(genres) x 2
-- -> genres_avg_budget.csv


-- Q6. Customers, whose preferences include the actor ""Leonardo DiCaprio"".
select 
 	c.first_name,
 	c.last_name
from customers c
where c.preferences -> 'preferred_actors' @> '["Leonardo DiCaprio"]'
;
-- John Doe


-- Q7. Movies, ordered by their box_office income from the column 'additional_info' in decreasing order.
select
	m.title,
	m.additional_info -> 'box_office' as box_office
from movies m
order by box_office desc
;
-- > movies_by_box_office.csv


-- Q8. Movie title, genre and the number of awards from additional_info.
select
	m.title,
	m.genre,
	jsonb_array_length(m.additional_info -> 'awards') as num_awards
from movies m
order by num_awards desc, m.title 
;
-- -> movies_awards.csv


-- Q9. Number of movies with >1 award (field 'awards' inside additional_info)
select
	count(*)
from movies m
where jsonb_array_length(m.additional_info -> 'awards') > 1
;
-- -> 6


-- Q10. Remove the key 'preferred_actors' from the column 'preferences' for all customers.
select 
 	c.first_name, -- customer's name
 	c.last_name,
	c.preferences - 'preferred_actors' as stripped_preference
from customers c
;
-- 31 (customers) x 3
-- -> preference_wo_actors.csv


