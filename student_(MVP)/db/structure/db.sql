CREATE DATABASE student;
USE student;

CREATE TABLE student (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    first_name TEXT NOT NULL,
    name TEXT NOT NULL,
    patronymic TEXT NOT NULL,
    telegram TEXT,
    email TEXT,
    phone_number TEXT,
    git TEXT,
    birthdate DATE NOT NULL
);

ALTER TABLE student AUTO_INCREMENT = 1;

ALTER TABLE student ADD UNIQUE (telegram(255)), ADD UNIQUE (email(255)), ADD UNIQUE (git(255)), ADD UNIQUE (phone_number(255));