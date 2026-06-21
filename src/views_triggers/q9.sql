-- Создайте триггер, который будет записывать информацию о каждом удалении записи из таблицы Customer
-- в отдельную таблицу Customer_Deletion_Log.

-- new table
-- see: ./src/q9_create_table_log.sql


-- fn
create or replace function trg_old_customers_audit()
returns trigger
language plpgsql
as $$
begin
	if tg_op = 'DELETE' then
    	insert into Customer_Deletion_Log(customer_id, deletion_date, email)
    	values (old.customer_id, now()::date, old.email);
    	return old;
  	end if;

	return null;
end;
$$;

-- trigger
create trigger log_old_customers
after delete
on customers
for each row
execute function trg_old_customers_audit();


-- Test on 2 testing tables.
-- see: ./src/q9_test.sql


