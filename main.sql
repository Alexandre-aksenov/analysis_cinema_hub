SELECT version();

-- Q1. название фильма и список языков, на которых доступен фильм.
select
	m.title,
	m.additional_info -> 'languages' as languages
from movies m
;
-- -> 31 (movies) x 2
-- -> movies_lang.csv

-- Q2. список фильмов, бюджет которых превышает 100 миллионов долларов.
select
	m.title,
	m.additional_info -> 'budget' as budget
from movies m
where (m.additional_info -> 'budget')::int > 10^8 
;
-- 10(movies) x 2
-- Execution plan: single row.
-- -> title_high_budget.csv


-- Q5. средний бюджет фильмов по жанрам.
select 
	m.genre,
	AVG((m.additional_info -> 'budget')::int) 
from movies m
group by m.genre
order by genre 
;
-- 10(genres) x 2


-- Q4. добавить новый предпочитаемый жанр ""Drama"" в список preferred_genres для всех клиентов,
-- которые подписаны на рассылку новостей (ключ newsletter имеет значение true).
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


-- Q6. список клиентов, у которых в preferences указан предпочитаемый актёр ""Leonardo DiCaprio"".
select 
 	c.first_name,
 	c.last_name
from customers c
where c.preferences -> 'preferred_actors' @> '["Leonardo DiCaprio"]'
;
-- John Doe


-- Q7. список фильмов, отсортированных по значению кассовых сборов box_office из поля additional_info в порядке убывания.
select
	m.title,
	m.additional_info -> 'box_office' as box_office
from movies m
order by box_office desc
;
-- > movies_by_box_office.csv

-- Q8. название фильма, его жанр и количество наград (awards) из additional_info.
select
	m.title,
	m.genre,
	jsonb_array_length(m.additional_info -> 'awards') as num_awards
from movies m
order by num_awards desc, m.title 
;
-- -> movies_awards.csv


-- Q9. количество фильмов, имеющих более чем одну награду в поле awards внутри additional_info
select
	count(*)
from movies m
where jsonb_array_length(m.additional_info -> 'awards') > 1
;
-- -> 6


-- Q10. удалить ключ preferred_actors из поля preferences для всех клиентов.
select 
 	c.first_name, -- customer's name
 	c.last_name,
	c.preferences - 'preferred_actors' as stripped_preference
from customers c
;
-- 31 (customers) x 3
-- -> preference_wo_actors.csv


