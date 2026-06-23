-- new table
CREATE TABLE Customer_Deletion_Log(
    customer_id integer PRIMARY KEY, -- id of the customer, when his account was active
    deletion_date DATE,
    email VARCHAR(255)
);
