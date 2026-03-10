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