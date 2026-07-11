-- Stored procedure DeleteCustomerWithLog :
-- Input: customer_id (interpretation of this solution)
-- ->
-- if the customer exists:
--   removes the customer from table 'customers',
--   adds information about this event (ID клиента, email, deletion date) to the table of logs Customer_Deletion_Log;
-- else:
--   raises exception


-- table for logs
drop table if exists Customer_Deletion_Log;

CREATE TABLE Customer_Deletion_Log(
    customer_id int PRIMARY KEY,
    email VARCHAR(255),
    deletion_date DATE
);


-- Algorithm: table customers ->(filter) record with the appropriate row
-- if NULL -> error
-- if 1 row -> move to Customer_Deletion_Log
create or replace procedure DeleteCustomerWithLog(
	customer_id int
)
language plpgsql
as $$
declare
  	v_id int;
	v_email VARCHAR(255);
begin
	-- extract info using id exists among customers
	SELECT
		c.customer_id,
		c.email
	INTO v_id, v_email
	FROM customers c
	WHERE c.customer_id = DeleteCustomerWithLog.customer_id;

	-- check whether the customer exists
	if v_id is null then
		raise exception 'No customer with id=% could be found.', customer_id;
	else
		-- move the customer to Customer_Deletion_Log
		INSERT INTO Customer_Deletion_Log (customer_id, email, deletion_date) VALUES
		(v_id, v_email, now()::date);
	
		DELETE FROM customers c
		WHERE c.customer_id = DeleteCustomerWithLog.customer_id;
	end if;
end;
$$;

-- Test: test_q4.sql
