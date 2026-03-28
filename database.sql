CREATE DATABASE IF NOT EXISTS TIMETABLE;

USE TIMETABLE;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student', 'teacher', 'admin') NOT NULL,
    is_first_login BOOLEAN DEFAULT TRUE,
    otp_code VARCHAR(10) DEFAULT NULL,
    otp_expiry DATETIME DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email, password, role)
VALUES
(
  'Rahul Sharma',
  'rahul@college.edu',
  '$2b$10$8Hf7KJw2mQpZsL9vXrTn2eY5cD1gU7bW4mNqP6aR3tY8uI5oL2kGm',
  'student'
),
(
  'Priya Verma',
  'priya@college.edu',
  '$2b$10$4LmN8vQpR2sXcT6yU1wZ9aB5dF7gH3jK0nPqM8rS2tV6yX1zC4dEf',
  'teacher'
),
(
  'Admin User',
  'admin@college.edu',
  '$2b$10$9TgH3kLmP2qRsV8xY1zA5bC7dE4fG6hJ0kN9mQ2rS5tU8vW1xYzAb',
  'admin'
);