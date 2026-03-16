-- DVD Rental Capstone Project
-- Author: Selam 
-- Branch: Selam

-- Scenario 1
-- Create temporary table for new customer

--  Write the DDL to create a new temporary table called new_customer 
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

--. Insert a record for the new customer into the new_customer table.

INSERT INTO new_customer
(customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
VALUES
(600, 2, 'johnny', 'Deep', 'johnny@email.com', 605, TRUE, CURRENT_DATE, CURRENT_TIMESTAMP)

-- .Insert the customer into the main customer table based on the record in new_customer.

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


-- Insert a new rental:
-- Insert a new record into the rental table for this customer, including rental date, inventory_id (assume it's available), and staff_id.


INSERT INTO rental
(rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES
(CURRENT_TIMESTAMP, 5, 600, NULL, 1);
-- null because not returned yet 

-- Insert a corresponding payment record into the payment table for this rental, recording the amount and payment date.

-- Question 5
-- Insert payment for the rental

-- first we create a new renta_id since we added a new customer. current rental_id= 16044

INSERT INTO rental
(rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES
(CURRENT_TIMESTAMP, 5, 600, NULL, 1);

--after inserting new rental  rental_id will automatically become:= 16045

INSERT INTO payment
(customer_id, staff_id, rental_id, amount, payment_date)
VALUES
(600, 1, 16045, 4.99, CURRENT_TIMESTAMP);


-- Scenario 2: A new film is released and needs to be added to the system.
-- Create a temporary table new_film with fields such as title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, and rating.

CREATE TEMP TABLE new_film (
    film_id SERIAL PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    release_year INT,
    language_id INT,
    rental_duration INT,
    rental_rate NUMERIC(4,2),
    length INT,
    replacement_cost NUMERIC(5,2),
    rating VARCHAR(10)
);

-- note: We do not include film_id because:it is SERIAL SQL auto generates it.

--Insert a record for the new film into new_film table.

INSERT INTO new_film 
(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
VALUES
('Alex the analyst', 'A story about a YouTuber who helps future data analysts master SQL.', 2026, 1, 5, 4.99, 160, 19.99, 'PG-13');


-- Insert the new film into the main film table using the data from new_film.


INSERT INTO film 
(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
SELECT
title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating
FROM new_film;

-- Add inventory: insert 3 available copies of this new film into the inventory table, assigning them to different store locations.

INSERT INTO inventory (film_id, store_id)
VALUES
((SELECT film_id FROM film WHERE title = 'Alex the Analyst'), 1),
((SELECT film_id FROM film WHERE title = 'Alex the Analyst'), 2),
((SELECT film_id FROM film WHERE title = 'Alex the Analyst'), 1);


-- Section 2: DQL — Data Query Language (SELECT, WHERE, Aggregates, GROUP BY, HAVING, ORDER BY, JOINS, Subqueries)
-- General Analysis

-- List the top 10 longest movies along with their length and title.

SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 10;

--Find all customers who have rented more than 10 movies.

SELECT customer_id, COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY customer_id
HAVING COUNT(rental_id) > 10;

-- Get the average rental rate for each movie rating (G, PG, R, etc.).

SELECT rating, AVG(rental_rate) AS avg_rental_rate
FROM film
GROUP BY rating
ORDER BY rating;

--Find the top 5 cities with the most customers.

SELECT ci.city, COUNT(c.customer_id) AS total_customers
FROM customer c
JOIN address a
ON c.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
GROUP BY ci.city
ORDER BY total_customers DESC
LIMIT 5;

-- Show the total revenue (payment amount) collected by each staff member.

SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_revenue
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY total_revenue DESC;

--. Retrieve the 10 most rented films along with how many times each was rented.

--. Find the customer who has spent the most in total payments.

SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;


-- list all movies that have never been rented.

SELECT f.title
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
LEFT JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;