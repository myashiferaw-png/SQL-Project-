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
select *
from customer;

--3. Insert the customer into the main customer table based on the record in new_customer.
insert into customer (store_id, first_name, last_name, email, address_id, active)
select 1,first_name, last_name, email,address_id,active
from new_customer;

select *
from customer
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