-- Create 2 testing tables

drop table if exists customers_4;
drop table if exists Customer_Deletion_Log_4;
drop procedure if exists DeleteCustomerWithLog_4;

create table customers_4(
    customer_id int PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone_number VARCHAR(20),
    address VARCHAR(255),
    registration_date DATE,
    preferences JSONB
);

create table Customer_Deletion_Log_4 (like Customer_Deletion_Log including all);
-- Updated Rows 0

-- create 2 customers
INSERT INTO customers_4 (customer_id, first_name, last_name, email, phone_number, address, registration_date, preferences) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '1234567890', '123 Main St', '2022-01-15', 
 '{"preferred_genres": ["Action", "Sci-Fi"]}'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '2345678901', '456 Elm St', '2022-02-20', 
'{"preferred_genres": ["Drama"]}');
-- Updated Rows 2

select * from customers_4 c;
-- 2 rows

-- Create an analogous procedure
create or replace procedure DeleteCustomerWithLog_4(
	customer_id int
)
language plpgsql
as $$
declare
  	v_id int;
	v_email VARCHAR(255);
begin
	-- check the given id exists among customers
	SELECT
		c.customer_id,
		c.email
	INTO v_id, v_email
	FROM customers_4 c
	WHERE c.customer_id = DeleteCustomerWithLog_4.customer_id;

	-- decision on the route
	if v_id is null then
		raise exception 'No customer with id=% could be found.', customer_id;
	else
		-- move the customer to Customer_Deletion_Log
		INSERT INTO Customer_Deletion_Log_4 (customer_id, email, deletion_date) VALUES
		(v_id, v_email, now()::date);
	
		DELETE FROM customers_4 c
		WHERE c.customer_id = DeleteCustomerWithLog_4.customer_id;
	end if;
end;
$$;
-- Updated Rows 2

-- attempt to remove a nonexisting client
call DeleteCustomerWithLog_4(customer_id => 5);
-- ERROR (expected): No customer with id=5 could be found.


select * from customers_4 c; -- both customers
select * from Customer_Deletion_Log_4; -- empty

-- valid delete
call DeleteCustomerWithLog_4(customer_id => 2);
-- Updated Rows -1

select * from customers_4 c; -- only the row id=1 remains
select * from Customer_Deletion_Log_4;
-- id=2 , email=jane.smith@example.com , deletion_date = today's date
-- {Expected result}
