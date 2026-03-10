CREATE TABLE store (
    store_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
CREATE TABLE city(
city_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
city VARCHAR(50)NOT NULL
);
CREATE TABLE address(
address_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
address VARCHAR(100) NOT NULL,
district VARCHAR(50),
city_id INT NOT NULL,
postal_code VARCHAR(20),
phone VARCHAR(20),
last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_address_city
	FOREIGN KEY (city_id) REFERENCES city(city_id)
	);
CREATE TABLE staff (
staff_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
first_name VARCHAR(45)NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(50),
store_id INT NOT NULL,
active BOOLEAN NOT NULL DEFAULT TRUE,
username VARCHAR(45) NOT NULL,
last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_staff_store
FOREIGN KEY (store_id)REFERENCES store(store_id)
);
CREATE TABLE customer (
    customer_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    store_id INT NOT NULL,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    email VARCHAR(50),
    address_id INT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_store
        FOREIGN KEY (store_id) REFERENCES store(store_id),
    CONSTRAINT fk_customer_address
        FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE film (
    film_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
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
CREATE TABLE inventory (
    inventory_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film_id INT NOT NULL,
    store_id INT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_film
        FOREIGN KEY (film_id) REFERENCES film(film_id),
    CONSTRAINT fk_inventory_store
        FOREIGN KEY (store_id) REFERENCES store(store_id)
);
CREATE TABLE rental (
    rental_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rental_date TIMESTAMP NOT NULL,
    inventory_id INT NOT NULL,
    customer_id INT NOT NULL,
    return_date TIMESTAMP,
    staff_id INT NOT NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rental_inventory
        FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
    CONSTRAINT fk_rental_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_rental_staff
        FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
CREATE TABLE payment (
    payment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    staff_id INT NOT NULL,
    rental_id INT NOT NULL,
    amount NUMERIC(5,2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_payment_staff
        FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    CONSTRAINT fk_payment_rental
        FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
);