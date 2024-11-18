DROP DATABASE IF EXISTS coop_connect;

CREATE DATABASE IF NOT EXISTS coop_connect;

USE coop_connect;

-- school tables
CREATE TABLE
    IF NOT EXISTS college (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );

CREATE TABLE
    IF NOT EXISTS department (
        id INT AUTO_INCREMENT PRIMARY KEY,
        college INT NOT NULL,
        name VARCHAR(255) NOT NULL,
        -- one-to-one
        CONSTRAINT fk_department_college FOREIGN KEY (college) REFERENCES college (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS major (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        department INT NOT NULL,
        -- one-to-one
        CONSTRAINT fk_major_department FOREIGN KEY (department) REFERENCES department (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS coop_advisor (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        department_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_coop_advisor_department FOREIGN KEY (department_id) REFERENCES department (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

-- company tables
CREATE TABLE
    IF NOT EXISTS industry (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );

CREATE TABLE
    IF NOT EXISTS company (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        industry INT NOT NULL,
        location VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        criteria TEXT NOT NULL,
        -- one-to-one
        CONSTRAINT fk_company_industry FOREIGN KEY (industry) REFERENCES industry (id) ON UPDATE CASCADE ON DELETE RESTRICT
    );

CREATE TABLE
    IF NOT EXISTS skill (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );

CREATE TABLE
    IF NOT EXISTS hiring_manager (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        position VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        company_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_hiring_manager_company FOREIGN KEY (company_id) REFERENCES company (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS hiring_manager_coop_advisor (
        hiring_manager_id INT NOT NULL,
        coop_advisor_id INT NOT NULL,
        PRIMARY KEY (hiring_manager_id, coop_advisor_id),
        -- one-to-many
        CONSTRAINT fk_hmca_hiring_manager FOREIGN KEY (hiring_manager_id) REFERENCES hiring_manager (id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_hmca_coop_advisor FOREIGN KEY (coop_advisor_id) REFERENCES coop_advisor (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS job_position (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        still_accepting BOOLEAN NOT NULL,
        num_applicants INT NOT NULL,
        postedAt DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        location VARCHAR(255) NOT NULL,
        desired_skills TEXT NOT NULL,
        targeted_majors TEXT NOT NULL,
        company_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_job_position_company FOREIGN KEY (company_id) REFERENCES company (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

-- student tables
CREATE TABLE
    IF NOT EXISTS student (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        gpa DECIMAL(3, 2) NOT NULL,
        major_id INT NOT NULL,
        grad_year INT NOT NULL,
        advised_by INT NOT NULL,
        hired_by INT,
        past_job INT,
        -- one-to-one
        CONSTRAINT fk_student_major FOREIGN KEY (major_id) REFERENCES major (id) ON UPDATE CASCADE ON DELETE RESTRICT,
        CONSTRAINT fk_advised_by FOREIGN KEY (advised_by) REFERENCES coop_advisor (id) ON UPDATE CASCADE ON DELETE RESTRICT,
        CONSTRAINT fk_hired_by FOREIGN KEY (hired_by) REFERENCES hiring_manager (id) ON UPDATE CASCADE ON DELETE SET NULL,
        CONSTRAINT fk_past_job FOREIGN KEY (past_job) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE SET NULL
    );

CREATE TABLE
    IF NOT EXISTS review (
        id INT AUTO_INCREMENT PRIMARY KEY,
        rating INT NOT NULL,
        review TEXT NOT NULL,
        student_id INT NOT NULL,
        job_position_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_review_student FOREIGN KEY (student_id) REFERENCES student (id),
        CONSTRAINT fk_review_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id)
    );

CREATE TABLE
    IF NOT EXISTS interview_question (
        id INT AUTO_INCREMENT PRIMARY KEY,
        question TEXT NOT NULL,
        job_position_id INT NOT NULL,
        author_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_interview_question_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE RESTRICT,
        CONSTRAINT fk_interview_question_author FOREIGN KEY (author_id) REFERENCES student (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS application (
        id INT AUTO_INCREMENT PRIMARY KEY,
        applicant_id INT NOT NULL,
        job_position_id INT NOT NULL,
        status ENUM ('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
        applied_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        -- one-to-many
        CONSTRAINT fk_application_student FOREIGN KEY (applicant_id) REFERENCES student (id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_application_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

-- Populating tables
-- colleges
INSERT INTO coop_connect.college (id, name)
VALUES ('1', 'Northeastern');
INSERT INTO coop_connect.college (id, name)
VALUES ('2', 'Boston University');
-- departments
INSERT INTO coop_connect.department (college, name)
VALUES ('1', 'Khoury College of Computer Science');
INSERT INTO coop_connect.department (college, name)
VALUES ('2', 'College of Arts, Media & Design');
-- majors
INSERT INTO coop_connect.major (id, name, department)
VALUES ('1', 'Computer Science', '1');
INSERT INTO coop_connect.major (id, name, department)
VALUES ('2', 'Cybersecurity', '1');
INSERT INTO coop_connect.major (id, name, department)
VALUES ('3', 'Design', '2');
-- co-op advisors
INSERT INTO coop_connect.coop_advisor (id, name, email, department_id)
VALUES ('1', 'Winston Churchill', 'w.churchill@northeastern.edu',
        '1');
INSERT INTO coop_connect.coop_advisor (id, name, email, department_id)
VALUES ('2', 'Amber Jackson', 'a.jackson@northeastern.edu',
        '2');
-- students
INSERT INTO coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by)
VALUES ( 1, 'Maura Turner', 'm.turner@northeastern.edu',4.0,
        '1', '2027', '1');
INSERT INTO coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by)
VALUES ( 2, 'Wade Wilson', 'w.wilson@northeastern.edu',3.0,
        '1', '2027', '1');
INSERT INTO coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by)
VALUES ( 3, 'Matt Smith', 'm.smith@northeastern.edu',3.7,
        '3', '2027', '1');
INSERT INTO coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by)
VALUES ( 4, 'Ann Adams', 'a.adams@northeastern.edu',2.5,
        '3', '2026', '2');
-- industries
INSERT INTO coop_connect.industry (id, name)
VALUES ('1', 'Tech');
INSERT INTO coop_connect.industry (id, name)
VALUES ('2', 'Pharmaceuticals');
-- companies
INSERT INTO coop_connect.company (id, name, industry, location, description, criteria)
VALUES ('1', 'Microsoft', '1', 'Seattle', 'abc',
        'abc');
INSERT INTO coop_connect.company (id, name, industry, location, description, criteria)
VALUES ('2', 'Apple', '1', 'Los Angeles', 'abc',
        'abc');
-- job positions
INSERT INTO coop_connect.job_position (id, title, description, still_accepting,
                                       num_applicants, location, desired_skills,
                                       targeted_majors, company_id)
VALUES ('1', 'Software Developer', 'abc', '1',
        20, 'Seattle', 'teamwork',
        'Computer Science', '1');
INSERT INTO coop_connect.job_position (id, title, description, still_accepting,
                                       num_applicants, location, desired_skills,
                                       targeted_majors, company_id)
VALUES ('2', 'UX Designer', 'abc', '1',
        20, 'Los Angeles', 'teamwork',
        'Biology', '2');
-- applications
INSERT INTO coop_connect.application
    (id, applicant_id, job_position_id, status)
VALUES ('1','2','2', 'Pending');
INSERT INTO coop_connect.application
    (id, applicant_id, job_position_id, status)
VALUES ('2','3','2', 'Rejected');
-- hiring managers
INSERT INTO coop_connect.hiring_manager (id, name, position, email, company_id)
VALUES ('1', 'Damian Wayne', '1', 'd.wayne@outlook.com',
        '1');
INSERT INTO coop_connect.hiring_manager (id, name, position, email, company_id)
VALUES ('2', 'Sarah Lewis', '2', 's.lewis@gmail.com',
        '2');
-- interview questions
INSERT INTO coop_connect.interview_question (id, question, job_position_id, author_id)
VALUES ('1', 'What is your greatest strength?', '1', '1');
INSERT INTO coop_connect.interview_question (id, question, job_position_id, author_id)
VALUES ('2', 'What is your greatest weakness?', '2', '3');
-- reviews
INSERT INTO coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES ('1', '3', 'Review 1', '1', '1');
INSERT INTO coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES ('2', '4', 'Review 2', '3', '1');
INSERT INTO coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES ('3', '2', 'Review 3', '1', '2');
-- skills
INSERT INTO skill (id, name)
VALUES (1, 'Python');
INSERT INTO skill (id, name)
VALUES (2, 'SQL');
