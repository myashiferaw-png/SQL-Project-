--1. Write the DDL to create a new temporary table called new_customer with appropriate fields
--(first_name, last_name, email, address_id, active, etc.).

SELECT *
FROM customer;

DROP TABLE IF EXISTS new_customer;

create temporary table new_customer (
customer_id INT generated always as identity primary key,
first_name varchar(100) not null,
last_name varchar (100) not null,
email varchar (100) not null,
address_id int not null,
active int not null,
create_date timestamp default current_timestamp);

--2. Insert a record for the new customer into the new_customer table.
insert into new_customer(first_name, last_name, email,address_id,active)
values ('mya', 'mayaye', 'myamyaye@gmail.com', 110, 1);

select *
from new_customer;


--3. Insert the customer into the main customer table based on the record in new_customer.
insert into customer (store_id, first_name, last_name, email, address_id, active)
select 1,first_name, last_name, email,address_id,active
from new_customer;

select *
from new_customer
order by customer_id desc;

--4. Simulate a new rental:Insert a new record into the rental table for this customer, including rental date,
--inventory_id (assume it's available), and staff_id.

select * 
from rental;
select inventory_id
from inventory;

insert into rental(rental_date, inventory_id, customer_id, staff_id)
values (current_timestamp,45, 604,2 );

select customer_id,rental_date, inventory_id, customer_id, staff_id
from rental
where customer_id =604
limit 10;

--5. Insert a corresponding payment record into the payment table for this rental, 
--recording the amount and payment date.

select payment_id
from payment;

select *
from payment;

insert into payment (customer_id, staff_id,rental_id, amount,payment_date)
values ( 604, 2, 200, 92.99,current_timestamp);

select *
from payment 
where customer_id =604;

--6. Create a temporary table new_film with fields such as title, description, 
--release_year, language_id, rental_duration, rental_rate, length, replacement_cost,
--and rating.

create temporary table new_film (
title varchar (100) not null, 
description varchar (100) not null, 
release_year int not null, 
language_id smallint not null,
rental_duration int not null,
length int not null);

--7. Insert a record for the new film into new_film table.

insert into new_film (title, description, release_year, language_id, 
rental_duration, length)
values ('The sleeper Agent', 'Agent Mya must find the mole within the agency', 
2026,1, 4, 140);

select *
from new_film
where length = 140;

select *
from film
order by film_id desc;


--8. Add inventory: insert 3 available copies of this new film into the inventory 
--table, assigning them to different store locations.
select *
from inventory;

insert into inventory (film_id, store_id)
values (1001, 1), (1002, 1), (1003, 1);

--10. List the top 10 longest movies along with their length and title.

select length, title
from film
order by length desc 
limit 10;

--11. Find all customers who have rented more than 10 movies.
select customer_id,
count (*) as total_rental
from rental
group by customer_id
having  count (*) > 10;

--12 Get the average rental rate for each movie rating (G, PG, R, etc.).

select *
from film; 

select rating, avg(rental_rate) as avg_rental_rate
from film 
group by rating ;
--13. Find the top 5 cities with the most customers.

select *
from city;

select *
from customer;


select ci.city, count (c.customer_id ) as total_customer
from customer c 
join address a on c.address_id=a.address_id
join city ci on a. city_id= ci.city_id
group by ci. city
limit 5;

--13. Retrieve the 10 most rented films along with how many times each was rented.

select *
from inventory; 

select * 
from rental; 

select *
from film;

select f. title, count (r.rental_id) as total_rental
from rental r
join inventory i on r.inventory_id= i.inventory_id
join film f on i.film_id=f.film_id
group by f.title
limit 10;

--14. Find the customer who has spent the most in total payments.
select c.customer_id, c.first_name, c.last_name, sum (p.amount) as total_amount
from customer c
join payment p on c.customer_id= p.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_amount
limit 2;

--15. List all movies that have never been rented.

select *
from film;

select *
from inventory;

select *
from rental; 

select f.title, f.film_id
from film f 
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
where r.rental_id is null ;

--Case Study 1: Customer Behavior Analysis
--A marketing team wants to identify loyal customers to send special discount offers.
--Write a query to find customers who rented more than 20 movies and spent more than $100 in total.
--Return their full name, email, total rentals, and total amount paid.
--Sort the results by the total amount spent, highest first.


select *
from payment;

select *
from customer;

select *
from rental; 

select c.first_name, c.last_name, c.customer_id,
count(r.rental_id) as total_rental, sum(p.amount) as rental_amount
from customer c
join rental r on c.customer_id  = r.customer_id
join payment p on r.customer_id= p.customer_id
group by c.first_name, c.last_name, c.customer_id
having count (r.rental_id) >20 and sum(p.amount)  >100
order by rental_amount desc;

--The store manager wants to know which movies are underperforming and might be removed from inventory.
--Find all films that have been rented fewer than 5 times.
--Return the film title, rental count, and average rental rate for each.
--Sort the result by rental count, lowest first, and limit to 20 films.

select *
from rental;

select *
from film;

select *
from inventory;

select f.title, f.rental_rate, count (r.rental_id) as total_rental, avg (f.rental_rate) as average_rental
from film f 
join inventory i on f.film_id=i.film_id
join rental r on i.inventory_id= r.inventory_id
group by f.title, f.rental_rate
having count(r.rental_id) <5
order by total_rental
limit 20;