-- Tested on https://sqliteonline.com/, Demo Serber PostgreSQL on 26/5/2026.

SELECT version();
-- PostgreSQL 17.5 (Debian 17.5-1.pgdg120+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 12.2.0-14) 12.2.0, 64-bit



CREATE TABLE ex_customers (
	first_name VARCHAR(100)
)
;

INSERT INTO ex_customers (first_name)VALUES
('John'),
('John')
 ;
 
CREATE TABLE ex_actors (
	first_name VARCHAR(100)
)
;


INSERT INTO ex_actors (first_name) VALUES
('Leonardo')
;


select 
	c.first_name,
	'client'::VARCHAR(10) as type
from ex_customers c
union
select
	a.first_name,
	'actor'::VARCHAR(10) as type
	-- 'actor' as type : is also accepted, but leads to the type VARCHAR(10485760) on my machine
from ex_actors a
;
/*
"Leonardo"	"actor"
"John"	"client"

Conclusion: union also checked for repetition
inside the table "ex_customers" 
*/

select 
	c.first_name,
	'client'::VARCHAR(10) as type
from ex_customers c
union all
select
	a.first_name,
	'actor'::VARCHAR(10) as type
	-- 'actor' as type : is also accepted, but leads to the type VARCHAR(10485760) on my machine
from ex_actors a
;
/*
"John"	"client"
"John"	"client"
"Leonardo"	"actor"
*/

-- drop tables
drop table "ex_customers"
drop table "ex_actors"
