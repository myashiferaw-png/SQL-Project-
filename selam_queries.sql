-- DVD Rental Capstone Project
-- Author: Selam 
-- Branch: Selam

-- Scenario 1
-- Create temporary table for new customer

-- 1. Write the DDL to create a new temporary table called new_customer 
-- with appropriate fields (first_name, last_name, email, address_id, active, etc.).

CREATE TABLE new_customer (
    customer_id INT,
    store_id SMALLINT,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    email VARCHAR(30),
    address_id smallINT,
    active  BOOLEAN,
    Create_date DATE,
    last_update TIMESTAMP
);

-- 2. Insert a record for the new customer into the new_customer table.

INSERT INTO new_customer
(customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
VALUES
(600, 2, 'johnny', 'Deep', 'johnny@email.com', 605, TRUE, CURRENT_DATE, CURRENT_TIMESTAMP)

-- 3.Insert the customer into the main customer table based on the record in new_customer.

INSERT INTO customer
(customer_id, store_id, first_name, last_name, email, address_id, activebool, create_date, last_update)
SELECT
    customer_id,
    store_id,
    first_name,
    last_name,
    email,
    address_id,
    activebool,
    create_date,
    last_update
FROM new_customer
WHERE customer_id = 600;


-- 4. Insert a new rental:
-- Insert a new record into the rental table for this customer, including rental date, inventory_id (assume it's available), and staff_id.


INSERT INTO rental
(rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES
(CURRENT_TIMESTAMP, 5, 600, NULL, 1);
-- null because not returned yet 

-- 5. Insert a corresponding payment record into the payment table for this rental, recording the amount and payment date.

-- Question 5
-- Insert payment for the rental

INSERT INTO payment
(customer_id, staff_id, rental_id, amount, payment_date)
VALUES (600,1,