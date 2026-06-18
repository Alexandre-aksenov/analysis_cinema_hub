-- Создайте представление CustomerMovieRentalView, которое объединяет информацию о клиентах и фильмах, которые они брали в аренду.
-- Включите следующие столбцы:
-- фио клиента, его номер телефона, название фильма, количество дней в аренде фильма у клиента
create or replace view CustomerMovieRentalView as
select
	c.first_name
	, c.last_name
	, c.phone_number
	, m.title
	, r.return_date - r.rental_date as rental_duration
	, r.rental_date -- added to get enough data for the next query
from rentals r
join customers c on c.customer_id = r.customer_id
join movies m on m.movie_id = r.movie_id
;
-- Updated rows: 0

-- drop view CustomerMovieRentalView


-- Q2. запрос, который покажет все фильмы, взятые в аренду клиентами в марте 2022 года
-- Step 1, without filtering
select
	v_cr.title
	, date_trunc('month', v_cr.rental_date)::date as r_month
from CustomerMovieRentalView v_cr
-- where 
;
-- all 30 movies, filtering seems unnecessary.


select
	v_cr.title
	, date_trunc('month', v_cr.rental_date)::date as r_month
from CustomerMovieRentalView v_cr
where date_trunc('month', v_cr.rental_date)::date = '2022-03-01'::date
;
-- 30 (all movies) x 2
-- -> ./movies_rented_mar2022.csv

