-- This index is designed to simplify ordering and grouping on a customer's name (initially divided in two fields).

create index if not exists idx_customers_full_name on customers(first_name, last_name);

-- same query
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
/*
                                                                QUERY PLAN                                                                 
-------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=5.69..5.70 rows=5 width=460) (actual time=0.118..0.123 rows=5 loops=1)
   ->  Sort  (cost=5.69..5.70 rows=5 width=460) (actual time=0.116..0.120 rows=5 loops=1)
         Sort Key: (count(rentals.rental_id)) DESC, (max(rentals.rental_date)) DESC
         Sort Method: quicksort  Memory: 25kB
         ->  HashAggregate  (cost=5.58..5.63 rows=5 width=460) (actual time=0.103..0.107 rows=5 loops=1)
               Group Key: customers.first_name, customers.last_name, movies.title
               Batches: 1  Memory Usage: 24kB
               ->  Hash Join  (cost=4.04..5.52 rows=5 width=456) (actual time=0.082..0.093 rows=5 loops=1)
                     Hash Cond: (customers.customer_id = rentals.customer_id)
                     ->  Seq Scan on customers  (cost=0.00..1.31 rows=31 width=440) (actual time=0.013..0.017 rows=31 loops=1)
                     ->  Hash  (cost=3.98..3.98 rows=5 width=24) (actual time=0.061..0.063 rows=5 loops=1)
                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                           ->  Hash Join  (cost=2.44..3.98 rows=5 width=24) (actual time=0.049..0.060 rows=5 loops=1)
                                 Hash Cond: (rentals.movie_id = movies.movie_id)
                                 ->  Seq Scan on rentals  (cost=0.00..1.45 rows=30 width=16) (actual time=0.006..0.012 rows=30 loops=1)
                                       Filter: ((rental_date >= '2021-01-01'::date) AND (rental_date <= '2022-12-31'::date))
                                 ->  Hash  (cost=2.38..2.38 rows=5 width=16) (actual time=0.019..0.020 rows=5 loops=1)
                                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                       ->  Seq Scan on movies  (cost=0.00..2.38 rows=5 width=16) (actual time=0.008..0.015 rows=5 loops=1)
                                             Filter: ((genre)::text = 'Action'::text)
                                             Rows Removed by Filter: 25
 Planning Time: 0.763 ms
 Execution Time: 0.212 ms
(23 rows)

*/

-- query without Explain
-- Time: 2,078 ms . Slightly slower, than on iteration 1, but the "Cost" in the plan is 2.5 times lower.

-- New step: 'HashAggregate' instead of the previous 'GroupAggregate'. 
-- Once again, the new index 'idx_customers_full_name' is not mentioned in the plan. 

