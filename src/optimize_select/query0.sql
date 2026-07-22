/*
Extract information about rentals of movies of the genre 'Action', which happened in 2021 or 2022.
Extract the number of rentals and the date of the last rental in this period for each pair
customer-title.
*/

/*
The tables have been renamed to adapt to the data:

Customer -> customers
Movie -> movies
Rental -> rentals
 
 */

EXPLAIN analyze -- -> res/plan0.csv
SELECT 
    customers.first_name, 
    customers.last_name, 
    movies.title,
    COUNT(rentals.rental_id) AS rental_count, 
    MAX(rentals.rental_date) AS last_rental_date
FROM 
    customers
JOIN 
    rentals ON customers.customer_id = rentals.customer_id
JOIN 
    movies ON rentals.movie_id = movies.movie_id
WHERE 
    movies.genre = 'Action'
    AND rentals.rental_date BETWEEN '2021-01-01' AND '2022-12-31'
GROUP BY 
    customers.first_name,
    customers.last_name, 
    movies.title
ORDER BY 
    rental_count DESC, 
    last_rental_date DESC
LIMIT 10;
-- -> 5 
-- (the table count_genres.csv shows indeed that the data contains just 5 movies of genre 'Action'
-- and the table count_rentals_per_movie.csv shows that each movie has been rented at most once) 
-- x 5 (1st, last name, title, rental_count, last_rental_date)
-- -> res/answer.csv

-- Time: 3.6 ms.

/*
According to this plan, the most expensive operations are:
   two sorts, Join: (movies.movie_id = rentals.movie_id) via a nested loop.
   2 Seq scans (movies, rentals) already are quite cheap, but indices can be added for them.
*/


