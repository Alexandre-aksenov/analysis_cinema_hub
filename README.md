## Analysis of activity of a cinema hub.

A fictional cinema hub holds copies of several movies. Its sample database is created and queried in this repository.

## Data.

The main table is "movies" with information about the movies of the fictional company. It is linked to the table "actors" (not queried) through the intermediate table "movie_actors", and to the table "customers", containing the information about the company's clients, and linked to "movies" through the auxiliary table "rentals".

The tables' structure is defined in <code>create_tables_cinema_hub.sql</code>, they are filled with data in <code>insert_data_cinema_hub.sql</code>.

All tables are in the third Normal Form.

## Queries

The main scripts <code>main1.sql</code>, <code>main2.sql</code>, <code>main3.sql</code> contain the queries and summary of the answers.

The RDBMS used: PostgreSQL 17.

## Results.

The results (whenever they are non-trivial) are exported to the folder <code>res</code> in the format CSV.

## Possible improvements.

1. The nature of the particular dataset does not call (therefore, does not test) some features provided in the queries. Although an additional table has been created for testing the management of Nulls in Question 1 in <code>main1.sql</code>, an analogous procedure is possible  for testing the summation of durations of orders by the same client in Question 4.

2. Again, in Question 4 in <code>main1.sql</code>, the number of days is produced using a syntax specific to PostgreSQL. A syntax, which makes the conversion to days explicit, would lead to easier reading.

## Feedback and additional questions.

All questions about the source code should be adressed to its author Alexandre Aksenov:
* GitHub: Alexandre-aksenov
* Email: alexander1aksenov@gmail.com
