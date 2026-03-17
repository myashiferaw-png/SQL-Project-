INSERT INTO store (store_name, location)
VALUES
    ('Main Store', 'Downtown'),
    ('Branch Store', 'Uptown');

INSERT INTO city (city)
VALUES
    ('Houston'),
    ('Dallas'),
    ('Austin');

INSERT INTO address (address, district, city_id, postal_code, phone)
VALUES
    ('5205 Chenevert St', 'Midtown', 1, '77004', '240-461-0428'),
    ('100 Main St', 'Central', 2, '75001', '214-111-2222'),
    ('200 Lake Ave', 'North', 3, '73301', '512-333-4444');

INSERT INTO staff (first_name, last_name, email, store_id, active, username)
VALUES
    ('Mike', 'Smith', 'mike@store.com', 1, TRUE, 'msmith'),
    ('Sara', 'Jones', 'sara@store.com', 2, TRUE, 'sjones');

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES
    (1, 'John', 'Doe', 'john@example.com', 1, TRUE),
    (1, 'Jane', 'Miller', 'jane@example.com', 2, TRUE),
    (2, 'David', 'Brown', 'david@example.com', 3, TRUE);

INSERT INTO film (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
VALUES
    ('Inception Point', 'Sci-fi thriller', 2020, 1, 5, 4.99, 148, 19.99, 'PG-13'),
    ('Silent River', 'Drama film', 2019, 1, 3, 3.99, 110, 17.99, 'PG'),
    ('Shadow Night', 'Mystery thriller', 2021, 1, 7, 5.99, 130, 21.99, 'R'),
    ('Golden Path', 'Adventure film', 2018, 1, 4, 2.99, 95, 14.99, 'G'),
    ('Broken Wings', 'Emotional family story', 2022, 1, 6, 4.49, 123, 18.99, 'PG-13');

INSERT INTO inventory (film_id, store_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 1);

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES
    (CURRENT_TIMESTAMP - INTERVAL '10 days', 1, 1, CURRENT_TIMESTAMP - INTERVAL '8 days', 1),
    (CURRENT_TIMESTAMP - INTERVAL '9 days', 3, 2, CURRENT_TIMESTAMP - INTERVAL '7 days', 1),
    (CURRENT_TIMESTAMP - INTERVAL '7 days', 4, 1, CURRENT_TIMESTAMP - INTERVAL '5 days', 1),
    (CURRENT_TIMESTAMP - INTERVAL '5 days', 2, 3, CURRENT_TIMESTAMP - INTERVAL '3 days', 2),
    (CURRENT_TIMESTAMP - INTERVAL '2 days', 6, 2, NULL, 1);

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES
    (1, 1, 1, 4.99, CURRENT_TIMESTAMP - INTERVAL '10 days'),
    (2, 1, 2, 3.99, CURRENT_TIMESTAMP - INTERVAL '9 days'),
    (1, 1, 3, 5.99, CURRENT_TIMESTAMP - INTERVAL '7 days'),
    (3, 2, 4, 4.99, CURRENT_TIMESTAMP - INTERVAL '5 days'),
    (2, 1, 5, 4.49, CURRENT_TIMESTAMP - INTERVAL '2 days');
CREATE TEMP TABLE new_customer (
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
/*Simulate a new rental for this customer.*/
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
/*Insert a corresponding payment record for this rental.*/
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
/*========================================================
SCENARIO 2: A new film is released and needs to be added.
========================================================*/
/*Create a temporary table called new_film.*/
CREATE TEMP TABLE new_film (
    temp_film_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    release_year INT,
    language_id INT,
    rental_duration INT NOT NULL,
    rental_rate NUMERIC(4,2) NOT NULL,
    length INT,
    replacement_cost NUMERIC(5,2) NOT NULL,
    rating VARCHAR(10),
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
/*Insert a record into the new_film table.*/
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
/* Add inventory by inserting 3 copies of the new film.*/
INSERT INTO inventory (film_id, store_id)
VALUES
    ((SELECT MAX(film_id) FROM film), 1),
    ((SELECT MAX(film_id) FROM film), 1),
    ((SELECT MAX(film_id) FROM film), 2);

    /*Insert film records.*/
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
('Silent River', 'Drama story', 2020, 1, 4, 3.99, 115, 17.99, 'PG'),
('Dark Echo', 'Mystery thriller', 2021, 1, 6, 5.99, 140, 21.99, 'R'),
('Golden Path', 'Adventure journey', 2019, 1, 5, 2.99, 98, 14.99, 'G'),
('Broken Wings', 'Family emotional story', 2022, 1, 7, 4.49, 120, 18.99, 'PG'),
('Crimson Storm', 'Action movie', 2018, 1, 4, 3.49, 110, 16.99, 'PG-13'),
('Hidden Truth', 'Crime investigation', 2023, 1, 5, 4.99, 125, 19.99, 'R'),
('Ocean Light', 'Romantic drama', 2021, 1, 3, 2.99, 105, 15.99, 'PG'),
('Iron Fortress', 'War film', 2017, 1, 6, 4.99, 150, 22.99, 'R'),
('Lost Kingdom', 'Fantasy adventure', 2020, 1, 5, 3.99, 135, 20.99, 'PG-13'),
('Shadow City', 'Urban crime story', 2019, 1, 4, 3.99, 112, 17.99, 'R'),
('Blue Horizon', 'Inspiring drama', 2022, 1, 5, 4.49, 118, 18.99, 'PG'),
('Desert Wind', 'Adventure story', 2018, 1, 3, 2.99, 100, 15.99, 'PG'),
('Final Mission', 'Military action', 2023, 1, 6, 5.49, 145, 23.99, 'R'),
('Silver Night', 'Romantic film', 2021, 1, 4, 3.49, 108, 16.99, 'PG'),
('Mystic Forest', 'Fantasy adventure', 2019, 1, 5, 3.99, 122, 19.99, 'PG'),
('Hidden Island', 'Mystery adventure', 2022, 1, 5, 4.49, 128, 20.99, 'PG-13'),
('Silent Hunter', 'Suspense thriller', 2020, 1, 4, 4.99, 138, 21.99, 'R'),
('Golden Empire', 'Historical drama', 2018, 1, 6, 3.99, 142, 22.99, 'PG-13'),
('Crystal Sky', 'Sci-fi adventure', 2023, 1, 5, 4.99, 134, 19.99, 'PG-13');
/*Insert customer records.*/
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@example.com', 1, TRUE),
(1, 'Brian', 'Taylor', 'brian.taylor@example.com', 2, TRUE),
(1, 'Cathy', 'Moore', 'cathy.moore@example.com', 3, TRUE),
(2, 'Daniel', 'White', 'daniel.white@example.com', 1, TRUE),
(2, 'Eva', 'Thomas', 'eva.thomas@example.com', 2, TRUE),
(2, 'Frank', 'Harris', 'frank.harris@example.com', 3, TRUE),
(1, 'Grace', 'Martin', 'grace.martin@example.com', 1, TRUE);
/*--------------------------------------------------------
Insert film records.
This creates a strong dataset with more than 20 films
for meaningful analysis.
--------------------------------------------------------*/
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
('Crimson Storm','Action film',2018,1,4,3.49,110,16.99,'PG-13'),
('Hidden Truth','Crime investigation',2023,1,5,4.99,125,19.99,'R'),
('Ocean Light','Romantic drama',2021,1,3,2.99,105,15.99,'PG'),
('Iron Fortress','War story',2017,1,6,4.99,150,22.99,'R'),
('Lost Kingdom','Fantasy adventure',2020,1,5,3.99,135,20.99,'PG-13'),
('Shadow City','Urban crime',2019,1,4,3.99,112,17.99,'R'),
('Blue Horizon','Inspirational drama',2022,1,5,4.49,118,18.99,'PG'),
('Desert Wind','Adventure story',2018,1,3,2.99,100,15.99,'PG'),
('Final Mission','Military action',2023,1,6,5.49,145,23.99,'R'),
('Silver Night','Romantic film',2021,1,4,3.49,108,16.99,'PG'),
('Mystic Forest','Fantasy adventure',2019,1,5,3.99,122,19.99,'PG'),
('Hidden Island','Mystery adventure',2022,1,5,4.49,128,20.99,'PG-13'),
('Silent Hunter','Suspense thriller',2020,1,4,4.99,138,21.99,'R'),
('Golden Empire','Historical drama',2018,1,6,3.99,142,22.99,'PG-13'),
('Crystal Sky','Sci-fi adventure',2023,1,5,4.99,134,19.99,'PG-13');

/*Insert inventory records.*/
INSERT INTO inventory (film_id, store_id)
SELECT film_id, 1
FROM film
WHERE film_id NOT IN (
    SELECT film_id FROM inventory WHERE store_id = 1
);

INSERT INTO inventory (film_id, store_id)
SELECT film_id, 2
FROM film
WHERE film_id NOT IN (
    SELECT film_id FROM inventory WHERE store_id = 2
);

/*Insert initial rental records.*/
/*--------------------------------------------------------
Strengthen the dataset with additional random rentals.
This generates 60 extra rental transactions using random
inventory, customer, and staff selections.
--------------------------------------------------------*/
INSERT INTO rental (
    rental_date,
    inventory_id,
    customer_id,
    staff_id
)
SELECT
    CURRENT_TIMESTAMP - (random() * INTERVAL '60 days'),
    (SELECT inventory_id FROM inventory ORDER BY random() LIMIT 1),
    (SELECT customer_id FROM customer ORDER BY random() LIMIT 1),
    (SELECT staff_id FROM staff ORDER BY random() LIMIT 1)
FROM generate_series(1,60);
/*--------------------------------------------------------
Guarantee that at least one customer has more than 10 rentals.
This helps ensure the aggregate query for loyal customers
returns meaningful output.
--------------------------------------------------------*/
INSERT INTO rental (
    rental_date,
    inventory_id,
    customer_id,
    staff_id
)
SELECT
    CURRENT_TIMESTAMP - (random() * INTERVAL '20 days'),
    (SELECT inventory_id FROM inventory ORDER BY random() LIMIT 1),
    1,
    1
FROM generate_series(1,15);
/*--------------------------------------------------------
Insert payments for all rentals that do not yet have payments.
This keeps rental and payment data aligned.
--------------------------------------------------------*/

INSERT INTO payment (
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date
)
SELECT
    r.customer_id,
    r.staff_id,
    r.rental_id,
    ROUND((2 + random() * 4)::numeric, 2),
    r.rental_date
FROM rental r
LEFT JOIN payment p
    ON r.rental_id = p.rental_id
WHERE p.rental_id IS NULL;