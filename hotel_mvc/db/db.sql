CREATE DATABASE hotel;
USE hotel;

CREATE TABLE rooms (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    number TEXT NOT NULL,
    capacity INTEGER NOT NULL,
    price INTEGER NOT NULL
);

ALTER TABLE rooms AUTO_INCREMENT = 1;
ALTER TABLE rooms ADD UNIQUE (number(255));

CREATE TABLE guests (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    firstname TEXT NOT NULL,
    lastname TEXT NOT NULL,
    email TEXT,
    phone_number TEXT,
    birthdate DATE NOT NULL
);

ALTER TABLE guests AUTO_INCREMENT = 1;
ALTER TABLE guests ADD UNIQUE (email(255)), ADD UNIQUE (phone_number(255));
