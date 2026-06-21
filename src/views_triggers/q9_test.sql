-- Create testing tables customers_2 , Customer_Deletion_Log_2.
create table customers_2 (like customers including all);

create table Customer_Deletion_Log_2 (like Customer_Deletion_Log including all);

-- Create an analogous testing trigger
create or replace function trg_old_customers_audit_2()
returns trigger
language plpgsql
as $$
begin
	if tg_op = 'DELETE' then
    	insert into Customer_Deletion_Log_2(customer_id, deletion_date, email)
    	values (old.customer_id, now()::date, old.email);
    	return old;
  	end if;

	return null;
end;
$$;

-- trigger
create trigger log_old_customers_2
after delete
on customers_2
for each row
execute function trg_old_customers_audit_2();


-- Add 2 customers
INSERT INTO customers_2 (first_name, last_name, email, phone_number, address, registration_date, preferences) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '123 Main St', '2022-01-15', 
 '{"preferred_genres": ["Action", "Sci-Fi"], "preferred_actors": ["Leonardo DiCaprio"], "newsletter": true, "notifications": {"email": true, "sms": false}}'),
('Jane', 'Smith', 'jane.smith@example.com', '2345678901', '456 Elm St', '2022-02-20', 
 '{"preferred_genres": ["Drama"], "preferred_actors": ["Scarlett Johansson"], "newsletter": false, "notifications": {"email": false, "sms": true}}')
;

select * from customers_2 c;
-- 2 consecutive ids after 30

-- remove 1 customer
delete from customers_2
where first_name = 'Jane';
-- Updated rows 1.

-- check the new contents of both tables
select * from customers_2 c;
-- 1x8 {deletion went OK}
-- first_name = John Doe

select * from Customer_Deletion_Log_2 l;
-- 1x3
-- id=33
-- deletion_date = today (2026-06-21)
-- email = jane.smith@example.com 
-- { The log of deletion has been recorded. }


-- drop trigger log_old_customers_2 on customers_2;
-- drop table customers_2;
-- drop table Customer_Deletion_Log_2;
-- drop function trg_old_customers_audit_2();
