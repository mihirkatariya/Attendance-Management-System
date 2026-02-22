CREATE DATABASE IF NOT EXISTS attendance_db;
USE attendance_db;

-- Users Table (for login)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('ADMIN', 'TEACHER') DEFAULT 'TEACHER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Students Table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    department VARCHAR(50),
    semester INT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Courses Table
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    semester INT,
    teacher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id)
);

-- Attendance Table
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('PRESENT', 'ABSENT', 'LATE') NOT NULL,
    remarks VARCHAR(255),
    marked_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (marked_by) REFERENCES users(user_id),
    UNIQUE KEY unique_attendance (student_id, course_id, attendance_date)
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, password, full_name, email, role) 
VALUES ('admin', 'admin123', 'System Admin', 'admin@attendance.com', 'ADMIN');

-- Insert sample teacher
INSERT INTO users (username, password, full_name, email, role) 
VALUES ('teacher1', 'teacher123', 'John Doe', 'john@attendance.com', 'TEACHER');

-- Insert sample students
INSERT INTO students (roll_number, name, email, phone, department, semester, created_by) VALUES
('CS001', 'Alice Johnson', 'alice@student.com', '1234567890', 'Computer Science', 5, 1),
('CS002', 'Bob Smith', 'bob@student.com', '1234567891', 'Computer Science', 5, 1),
('CS003', 'Charlie Brown', 'charlie@student.com', '1234567892', 'Computer Science', 5, 1);

-- Insert sample courses
INSERT INTO courses (course_code, course_name, department, semester, teacher_id) VALUES
('CS501', 'Advanced Java Programming', 'Computer Science', 5, 2),
('CS502', 'Database Management', 'Computer Science', 5, 2);