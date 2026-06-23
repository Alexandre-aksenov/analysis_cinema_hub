-- Q1. View CustomerMovieRentalView, which joins information about clients and movies they rented.
-- Added feature in this solution:
-- 		an added column 'rental_date' allows the view to have enough information
--  	for the following select.

drop view if exists CustomerMovieRentalView;

create or replace view CustomerMovieRentalView as
select
	c.first_name
	, c.last_name
	, c.phone_number
	, m.title
	, r.return_date - r.rental_date as rental_duration
	, r.rental_date -- added in this solution to ensure the view contains enough data for the next query
from rentals r
join customers c on c.customer_id = r.customer_id
join movies m on m.movie_id = r.movie_id
;
-- Updated rows: 0


-- Q2. All movies, rented in March 2022.
-- Preliminary step, without filtering
select
	v_cr.title
	, date_trunc('month', v_cr.rental_date)::date as r_month
from CustomerMovieRentalView v_cr
;
-- all 30 movies, filtering seems unnecessary on this data, for all renting reported in the data happened during one month.


select
	v_cr.title
	, date_trunc('month', v_cr.rental_date)::date as r_month
from CustomerMovieRentalView v_cr
where date_trunc('month', v_cr.rental_date)::date = '2022-03-01'::date
;
-- 30 (all movies) x 2
-- -> ./res/movies_rented_mar2022.csv

