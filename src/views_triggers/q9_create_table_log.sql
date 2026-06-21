-- new table
CREATE TABLE Customer_Deletion_Log(
    customer_id integer PRIMARY KEY, -- id of the customer, when he has an active account
    deletion_date DATE,
    email VARCHAR(255)
);
