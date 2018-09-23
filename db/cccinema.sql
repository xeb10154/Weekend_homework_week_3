DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS screening;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS film;


CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255),
  price INT4
);

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR (255),
  funds INT4
);

CREATE TABLE screenings (
  id SERIAL4 PRIMARY KEY,
  start_time VARCHAR(255), --May change
  empty_seats INT4,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE
);

CREATE TABLE tickets (
  id SERIAL4 PRIMARY KEY,
  film_id INT4 REFERENCES films(id) ON DELETE CASCADE,
  customer_id INT4 REFERENCES customers(id) ON DELETE CASCADE,
  screening_id INT4 REFERENCES screenings(id) ON DELETE CASCADE
);
