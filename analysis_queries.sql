/* Find all customers who have rented more than 10 movies.*/
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
/*Get the average rental rate for each movie rating.*/

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
/* Show the total revenue collected by each staff member.*/

select s.staff_id,
       s.first_name,
	   sum(p.amount) AS total_revenue
from staff s
join payment p
ON
s.staff_id=p.staff_id
Group by s.staff_id,s.first_name,s.last_name
ORDER BY total_revenue DESC;
/*Retrieve the 10 most rented films along with how many
times each was rented.*/
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
/* Find the customer who has spent the most in total payments.*/
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


/* List the top 10 longest movies along with their title and length.*/
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 10;
/*Find all customers who have rented more than 10 movies.*/
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


/*DQL case study*/
/*case study 1-Find customers who rented more than 20 movies and spent more
than $100 in total. Return full name, email, total rentals,
and total amount paid. Sort by total amount spent, highest first.*/
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
/*Case study-2 The store manager wants to know which movies are underperforming
and might be removed from inventory.*/

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

