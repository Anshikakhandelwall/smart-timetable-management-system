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
  '$2b$10$aW6NSulM2c5qqV2Bjq2RAu4Lu1hD3DryB1HFPQ0.aBNkphnonvavi',
  'student'
),
(
  'Priya Verma',
  'priya@college.edu',
  '$2b$10$TudXkvtucvkAtdzFfXjp2.FAgEqaNSRcvd5oJIQ2Bwwt9dscS.Wau',
  'student'
),
(
  'Admin User',
  'admin@college.edu',
  '$2b$10$ooAsFzd6QWXI93HTikvGbO9myMbKGBtRsBCM3r3/TXVuqOQfVsaGe',
  'admin'
);