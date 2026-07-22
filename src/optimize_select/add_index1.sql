-- This index is designed to simplify the expensive operation:
-- Join Filter: (movies.movie_id = rentals.movie_id)
create index if not exists idx_rentals_date_movie_id on rentals(rental_date, movie_id);


EXPLAIN analyze
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
-- ->
/*
                                                                        QUERY PLAN                                                                        
----------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=13.07..13.08 rows=5 width=460) (actual time=0.171..0.175 rows=5 loops=1)
   ->  Sort  (cost=13.07..13.08 rows=5 width=460) (actual time=0.169..0.172 rows=5 loops=1)
         Sort Key: (count(rentals.rental_id)) DESC, (max(rentals.rental_date)) DESC
         Sort Method: quicksort  Memory: 25kB
         ->  GroupAggregate  (cost=12.89..13.01 rows=5 width=460) (actual time=0.142..0.149 rows=5 loops=1)
               Group Key: customers.first_name, customers.last_name, movies.title
               ->  Sort  (cost=12.89..12.90 rows=5 width=456) (actual time=0.134..0.136 rows=5 loops=1)
                     Sort Key: customers.first_name, customers.last_name, movies.title
                     Sort Method: quicksort  Memory: 25kB
                     ->  Nested Loop  (cost=2.58..12.83 rows=5 width=456) (actual time=0.081..0.104 rows=5 loops=1)
                           ->  Hash Join  (cost=2.44..3.98 rows=5 width=24) (actual time=0.036..0.049 rows=5 loops=1)
                                 Hash Cond: (rentals.movie_id = movies.movie_id)
                                 ->  Seq Scan on rentals  (cost=0.00..1.45 rows=30 width=16) (actual time=0.011..0.017 rows=30 loops=1)
                                       Filter: ((rental_date >= '2021-01-01'::date) AND (rental_date <= '2022-12-31'::date))
                                 ->  Hash  (cost=2.38..2.38 rows=5 width=16) (actual time=0.017..0.017 rows=5 loops=1)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on movies  (cost=0.00..2.38 rows=5 width=16) (actual time=0.007..0.012 rows=5 loops=1)
                                             Filter: ((genre)::text = 'Action'::text)
                                             Rows Removed by Filter: 25
                           ->  Index Scan using customers_pkey on customers  (cost=0.14..1.76 rows=1 width=440) (actual time=0.010..0.010 rows=1 loops=5)
                                 Index Cond: (customer_id = rentals.customer_id)
 Planning Time: 1.203 ms
 Execution Time: 0.237 ms
(23 rows)
*/

-- \timing on 

-- same query , without Explain
-- Time: 1,977 ms




-- New step: 'Hash Join' intead of 'Nested Loop'. The index changed the plan, although it is not called by its name.
-- Bottleneck in the new plan: Sort Key: customers.first_name, customers.last_name, movies.title .
