/*SQL PROJECT*/
/*Betsegaw
Maya
Selam*/

/*Section 1: DDL and DML (Scenario-Based)
Scenario 1: A new customer walks into the store to rent a movie. You need to capture all the necessary information.
1. Write the DDL to create a new temporary table called new_customer with appropriate fields (first_name, last_name, email, address_id, active, etc.).*/CREATE TEMP TABLE new_customer (
    temp_customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    store_id INT NOT NULL DEFAULT 1,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    phone VARCHAR(20),
    address_id INT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);
/*2. Insert a record for the new customer into the new_customer table.*/
INSERT INTO new_customer (
    store_id,
    first_name,
    last_name,
    email,
    phone,
    address_id,
    active,
    notes
)
VALUES (
    1,
    'Betsegaw',
    'Tereda',
    'betsegaw@example.com',
    '240-111-2222',
    1,
    TRUE,
    'New customer registering for movie rental'
);
3. Insert the customer into the main customer table based on the record in new_customer.
INSERT INTO customer (
    store_id,
    first_name,
    last_name,
    email,
    address_id,
    active,
    create_date,
    last_update
)
SELECT
    store_id,
    first_name,
    last_name,
    email,
    address_id,
    active,
    create_date,
    last_update
FROM new_customer;
/*4. Simulate a new rental:
Insert a new record into the rental table for this customer, including rental date, inventory_id (assume it's available), and staff_id.*/
INSERT INTO rental (
    rental_date,
    inventory_id,
    customer_id,
    staff_id
)
VALUES (
    CURRENT_TIMESTAMP,
    1,
    (SELECT MAX(customer_id) FROM customer),
    1
);
/*5. Insert a corresponding payment record into the payment table for this rental, recording the amount and payment date.*/
INSERT INTO payment (
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date
)
VALUES (
    (SELECT MAX(customer_id) FROM customer),
    1,
    (SELECT MAX(rental_id) FROM rental),
    4.99,
    CURRENT_TIMESTAMP
);
/*Scenario 2: A new film is released and needs to be added to the system.
6. Create a temporary table new_film with fields such as title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, and rating.*/
INSERT INTO new_film (
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating
)
VALUES (
    'The Last Horizon',
    'A sci-fi adventure about survival and discovery at the edge of the galaxy.',
    2026,
    1,
    5,
    3.99,
    125,
    19.99,
    'PG-13'
);
/*Insert the new film into the main film table using data
from the new_film table.*/
INSERT INTO film (
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating,
    last_update
)
SELECT
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating,
    last_update
FROM new_film;
/*Insert the new film into the main film table using the data from new_film.*/
INSERT INTO film (
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating
)
VALUES
('The Last Horizon', 'Sci-fi adventure', 2024, 1, 5, 4.99, 130, 19.99, 'PG-13'),
;
/*Add inventory: insert 3 available copies of this new film into the inventory table, assigning them to different store locations.*/
INSERT INTO inventory (film_id, store_id)
VALUES
    ((SELECT MAX(film_id) FROM film), 1),
    ((SELECT MAX(film_id) FROM film), 1),
    ((SELECT MAX(film_id) FROM film), 2);

	/*Section 2: DQL — Data Query Language (SELECT, WHERE, Aggregates, GROUP BY, HAVING, ORDER BY, JOINS, Subqueries)
General Analysis
8. List the top 10 longest movies along with their length and title.*/
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 10;
/*. Find all customers who have rented more than 10 movies.*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 10
ORDER BY total_rentals DESC;
/*Get the average rental rate for each movie rating (G, PG, R, etc.).*/

SELECT rating,avg(rental_rate) AS avg_rental_rate
FROM film
GROUP BY rating
ORDER BY rating;
/*Find the top 5 cities with the most customers.*/
SELECT count(c.customer_id) AS total_customer,ci.city
FROM customer c 
JOIN address a
ON c.address_id=a.address_id
JOIN city ci
ON a.city_id=ci.city_id
GROUP BY ci.city
ORDER BY total_customer DESC
LIMIT 5;
/*Show the total revenue (payment amount) collected by each staff member.*/
select s.staff_id,
       s.first_name,
	   sum(p.amount) AS total_revenue
from staff s
join payment p
ON s.staff_id=p.staff_id
Group by s.staff_id,s.first_name,s.last_name
ORDER BY total_revenue DESC
/*Retrieve the 10 most rented films along with how many times each was rented.*/
SELECT
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS times_rented
FROM film f
JOIN inventory i
    ON f.film_id = i.film_id
JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY times_rented DESC
LIMIT 10;
/*Find the customer who has spent the most in total payments.*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;
/* List all movies that have never been rented.*/
SELECT
    f.film_id,
    f.title
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
ORDER BY f.title;
/*DQL Case Study Questions*/
/*Case Study 1: Customer Behavior Analysis*/
 /*A marketing team wants to identify loyal customers to send special discount offers.*/

/*Write a query to find customers who rented more than 20 movies and spent more than $100 in total.
Return their full name, email, total rentals, and total amount paid.
Sort the results by the total amount spent, highest first.*/
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    rental_summary.total_rentals,
    payment_summary.total_amount_paid
FROM customer c
JOIN (
    SELECT
        customer_id,
        COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY customer_id
) AS rental_summary
    ON c.customer_id = rental_summary.customer_id
JOIN (
    SELECT
        customer_id,
        SUM(amount) AS total_amount_paid
    FROM payment
    GROUP BY customer_id
) AS payment_summary
    ON c.customer_id = payment_summary.customer_id
WHERE rental_summary.total_rentals > 20
  AND payment_summary.total_amount_paid > 100
ORDER BY payment_summary.total_amount_paid DESC;
/*Case Study 2: Film Performance Review
 The store manager wants to know which movies are underperforming and might be removed from inventory.

Find all films that have been rented fewer than 5 times.
Return the film title, rental count, and average rental rate for each.
Sort the result by rental count, lowest first, and limit to 20 films.*/
SELECT
    f.title,
    COUNT(r.rental_id) AS rental_count,
    AVG(f.rental_rate) AS avg_rental_rate
FROM film f
LEFT JOIN inventory i
    ON f.film_id = i.film_id
LEFT JOIN rental r
    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) < 5
ORDER BY rental_count ASC, f.title
LIMIT 20;
