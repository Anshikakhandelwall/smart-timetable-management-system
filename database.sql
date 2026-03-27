CREATE DATABASE TIMETABLE;
USE TIMETABLE; 

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('student','teacher','admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    department VARCHAR(50),
    designation VARCHAR(50),

    FOREIGN KEY (teacher_id) REFERENCES users(user_id)
    ON DELETE CASCADE
);

CREATE TABLE admins (
    admin_id INT PRIMARY KEY,
    role_type VARCHAR(50),

    FOREIGN KEY (admin_id) REFERENCES users(user_id)
    ON DELETE CASCADE
);

CREATE TABLE schools (
    school_id INT PRIMARY KEY AUTO_INCREMENT,
    school_name VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    school_id INT,

    FOREIGN KEY (school_id) REFERENCES schools(school_id)
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(50),
    course_id INT,

    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE semesters (
    sem_id INT PRIMARY KEY AUTO_INCREMENT,
    sem_number INT,
    branch_id INT,

    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE sections (
    section_id INT PRIMARY KEY AUTO_INCREMENT,
    section_name VARCHAR(10),
    sem_id INT,

    FOREIGN KEY (sem_id) REFERENCES semesters(sem_id)
);

CREATE TABLE students (
 student_id INT PRIMARY KEY,
    section_id int ,
    enrollment   VARCHAR(50)   UNIQUE,
    department   VARCHAR(100),

    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (section_id) REFERENCES sections(section_id)
    ON DELETE CASCADE
);

CREATE TABLE subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(100)
);

CREATE TABLE timetable (
    timetable_id INT PRIMARY KEY AUTO_INCREMENT,
    section_id INT,
    subject_id INT,
    teacher_id INT,
    day VARCHAR(10),
    start_time TIME,
    end_time TIME,
    room VARCHAR(50),

    FOREIGN KEY (section_id) REFERENCES sections(section_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE lecture_log (
    lecture_id INT PRIMARY KEY AUTO_INCREMENT,
    timetable_id INT,
    date DATE,
    teacher_id INT,
    status ENUM('conducted','absent','cancelled','late'),

    FOREIGN KEY (timetable_id) REFERENCES timetable(timetable_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);


CREATE TABLE absence_reports (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    lecture_id INT,
    student_id INT,
    report_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (lecture_id) REFERENCES lecture_log(lecture_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE substitutions (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    lecture_id INT,
    substitute_teacher INT,

    FOREIGN KEY (lecture_id) REFERENCES lecture_log(lecture_id),
    FOREIGN KEY (substitute_teacher) REFERENCES teachers(teacher_id)
);

CREATE TABLE events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(200),
    branch_id INT,
    section_id INT,
    event_date DATE,
    start_time TIME,
    end_time TIME,
    venue VARCHAR(100),
    credits INT,

    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (section_id) REFERENCES sections(section_id)
);

CREATE TABLE student_event (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    event_id INT,
    attendance_status ENUM('registered','attended','absent'),

    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id)
);

CREATE TABLE notifications (
    notif_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    title VARCHAR(200),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('read','unread') DEFAULT 'unread',

    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

