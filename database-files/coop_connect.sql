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
    IF NOT EXISTS student_past_job (
        student_id INT NOT NULL,
        job_position_id INT NOT NULL,
        PRIMARY KEY (student_id, job_position_id),
        -- one-to-many
        CONSTRAINT fk_student_past_job_student FOREIGN KEY (student_id) REFERENCES student (id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_student_past_job_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE CASCADE
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
INSERT INTO
    coop_connect.college (id, name)
VALUES
    ('1', 'Northeastern');

INSERT INTO
    coop_connect.college (id, name)
VALUES
    ('2', 'Boston University');

-- departments
INSERT INTO
    coop_connect.department (college, name)
VALUES
    ('1', 'Khoury College of Computer Science');

INSERT INTO
    coop_connect.department (college, name)
VALUES
    ('2', 'College of Arts, Media & Design');

-- majors
INSERT INTO
    coop_connect.major (id, name, department)
VALUES
    ('1', 'Computer Science', '1');

INSERT INTO
    coop_connect.major (id, name, department)
VALUES
    ('2', 'Cybersecurity', '1');

INSERT INTO
    coop_connect.major (id, name, department)
VALUES
    ('3', 'Design', '2');

-- co-op advisors
INSERT INTO
    coop_connect.coop_advisor (id, name, email, department_id)
VALUES
    (
        '1',
        'Winston Churchill',
        'w.churchill@northeastern.edu',
        '1'
    );

INSERT INTO
    coop_connect.coop_advisor (id, name, email, department_id)
VALUES
    (
        '2',
        'Amber Jackson',
        'a.jackson@northeastern.edu',
        '2'
    );

-- students
INSERT INTO
    coop_connect.student (
        id,
        name,
        email,
        gpa,
        major_id,
        grad_year,
        advised_by
    )
VALUES
    (
        1,
        'Maura Turner',
        'm.turner@northeastern.edu',
        4.0,
        '1',
        '2027',
        '1'
    );

INSERT INTO
    coop_connect.student (
        id,
        name,
        email,
        gpa,
        major_id,
        grad_year,
        advised_by
    )
VALUES
    (
        2,
        'Wade Wilson',
        'w.wilson@northeastern.edu',
        3.0,
        '1',
        '2027',
        '1'
    );

INSERT INTO
    coop_connect.student (
        id,
        name,
        email,
        gpa,
        major_id,
        grad_year,
        advised_by
    )
VALUES
    (
        3,
        'Matt Smith',
        'm.smith@northeastern.edu',
        3.7,
        '3',
        '2027',
        '1'
    );

INSERT INTO
    coop_connect.student (
        id,
        name,
        email,
        gpa,
        major_id,
        grad_year,
        advised_by
    )
VALUES
    (
        4,
        'Ann Adams',
        'a.adams@northeastern.edu',
        2.5,
        '3',
        '2026',
        '2'
    );

-- industries
INSERT INTO
    coop_connect.industry (id, name)
VALUES
    ('1', 'Tech');

INSERT INTO
    coop_connect.industry (id, name)
VALUES
    ('2', 'Pharmaceuticals');

-- companies
INSERT INTO
    coop_connect.company (
        id,
        name,
        industry,
        location,
        description,
        criteria
    )
VALUES
    ('1', 'Microsoft', '1', 'Seattle', 'abc', 'abc');

INSERT INTO
    coop_connect.company (
        id,
        name,
        industry,
        location,
        description,
        criteria
    )
VALUES
    ('2', 'Apple', '1', 'Los Angeles', 'abc', 'abc');

-- job positions
INSERT INTO
    coop_connect.job_position (
        id,
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
VALUES
    (
        '1',
        'Software Developer',
        'abc',
        '1',
        20,
        'Seattle',
        'teamwork',
        'Computer Science',
        '1'
    );

INSERT INTO
    coop_connect.job_position (
        id,
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
VALUES
    (
        '2',
        'UX Designer',
        'abc',
        '1',
        20,
        'Los Angeles',
        'teamwork',
        'Biology',
        '2'
    );

-- applications
INSERT INTO
    coop_connect.application (id, applicant_id, job_position_id, status)
VALUES
    ('1', '2', '2', 'Pending');

INSERT INTO
    coop_connect.application (id, applicant_id, job_position_id, status)
VALUES
    ('2', '3', '2', 'Rejected');

-- hiring managers
INSERT INTO
    coop_connect.hiring_manager (id, name, position, email, company_id)
VALUES
    (
        '1',
        'Damian Wayne',
        '1',
        'd.wayne@outlook.com',
        '1'
    );

INSERT INTO
    coop_connect.hiring_manager (id, name, position, email, company_id)
VALUES
    ('2', 'Sarah Lewis', '2', 's.lewis@gmail.com', '2');

-- interview questions
INSERT INTO
    coop_connect.interview_question (id, question, job_position_id, author_id)
VALUES
    ('1', 'What is your greatest strength?', '1', '1');

INSERT INTO
    coop_connect.interview_question (id, question, job_position_id, author_id)
VALUES
    ('2', 'What is your greatest weakness?', '2', '3');

-- reviews
INSERT INTO
    coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES
    ('1', '3', 'Review 1', '1', '1');

INSERT INTO
    coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES
    ('2', '4', 'Review 2', '3', '1');

INSERT INTO
    coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES
    ('3', '2', 'Review 3', '1', '2');

-- skills
INSERT INTO
    skill (id, name)
VALUES
    (1, 'Python');

INSERT INTO
    skill (id, name)
VALUES
    (2, 'SQL');

-- many-to-many coop advisors/hiring managers
INSERT INTO
    coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id)
VALUES
    (1, 1);

INSERT INTO
    coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id)
VALUES
    (1, 2);

INSERT INTO
    coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id)
VALUES
    (2, 1);

INSERT INTO
    coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id)
VALUES
    (2, 2);

-- user stories sql crud statements
-- 1. Maura Turner
-- (1.1) See if co-op position she applied for is filled
SELECT
    application.id
FROM
    coop_connect.student
    JOIN coop_connect.application ON student.id = application.applicant_id
    JOIN coop_connect.job_position ON application.job_position_id = job_position.id
WHERE
    student.id = '1'
    AND still_accepting = '0';

-- (1.2) See previous students who had co-ops she is interested in
SELECT
    student.id
FROM
    coop_connect.student
WHERE
    past_job = 'x';

-- (1.3) See previous interview questions for a co-op position
SELECT
    interview_question.question
FROM
    coop_connect.interview_question
    JOIN coop_connect.job_position jp on interview_question.job_position_id = jp.id
    JOIN coop_connect.application a on jp.id = a.job_position_id
    JOIN coop_connect.student s on a.applicant_id = s.id
WHERE
    s.id = '1'
    AND a.job_position_id = '1';

-- (1.4) See reviews from people that worked at companies she is interested in
SELECT
    r.rating,
    r.review,
    jp.title,
    c.name
FROM
    coop_connect.review r
    JOIN coop_connect.job_position jp on r.job_position_id = jp.id
    JOIN coop_connect.company c on jp.company_id = c.id
WHERE
    c.name = 'Microsoft';

-- (1.5) See status of applications
SELECT
    jp.title,
    a.status
FROM
    coop_connect.job_position jp
    JOIN coop_connect.application a on jp.id = a.job_position_id
    JOIN coop_connect.student s on a.applicant_id = s.id
WHERE
    s.id = '1';

-- (1.6) Keep track of applications/apply to positions
INSERT INTO
    coop_connect.application (id, applicant_id, job_position_id, status)
VALUES
    ('3', '1', '1', 'Pending');

-- 2. Wade Wilson
-- (2.1) Share reviews on past positions
INSERT INTO
    coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES
    ('4', '5', 'Review 4', '2', '1');

-- (2.2) Allow other students to contact him about his past position(s)
SELECT
    s.name,
    s.email
FROM
    coop_connect.student s
    JOIN coop_connect.review r on s.id = r.student_id
WHERE
    r.job_position_id = '1';

-- (2.3) Update a past review
UPDATE coop_connect.review
SET
    review = "Review 4 Updated"
WHERE
    id = '4';

-- (2.4) Delete past review that is no longer relevant
DELETE FROM coop_connect.review
WHERE
    review.id = '1';

-- (2.5) Share interview questions
INSERT INTO
    coop_connect.interview_question (id, question, job_position_id, author_id)
VALUES
    (
        '3',
        'What is your past experience in this field?',
        '1',
        '2'
    );

-- (2.6) Get contact information of advisor
SELECT
    ca.email
FROM
    coop_connect.coop_advisor ca
    JOIN coop_connect.student s on ca.id = s.advised_by
WHERE
    s.id = '2';

-- 3.Damian Wayne
-- (3.1) Post job descriptions
INSERT INTO
    coop_connect.job_position (
        id,
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
VALUES
    (
        '3',
        'UX Designer',
        'abc',
        '1',
        20,
        'Houston',
        'Java, Python',
        'Computer Science',
        '1'
    );

-- (3.2) Search for students with a certain major and get their contact info
SELECT
    s.id,
    s.name,
    s.email
FROM
    coop_connect.student s
    JOIN coop_connect.major m ON s.major_id = m.id
WHERE
    m.name = 'Computer Science';

-- (3.3) Update application status
UPDATE coop_connect.application
SET
    status = 'Rejected'
WHERE
    applicant_id = '1';

-- (3.4) Look at reviews for his company's positions
SELECT
    r.rating,
    r.review,
    jp.title
FROM
    coop_connect.review r
    JOIN coop_connect.job_position jp on r.job_position_id = jp.id
    JOIN coop_connect.company c on jp.company_id = c.id
WHERE
    c.name = 'Microsoft';

-- (3.5) Look at job postings from similar companies
SELECT
    jp.title,
    jp.description,
    jp.desired_skills,
    jp.targeted_majors
FROM
    coop_connect.job_position jp
    JOIN coop_connect.company c on jp.company_id = c.id
    JOIN coop_connect.industry i on c.industry = i.id
WHERE
    i.name = 'Tech';

-- (3.6) View students past jobs
SELECT
    jp.id,
    jp.title,
    jp.description
FROM
    coop_connect.job_position jp
    JOIN coop_connect.student s on jp.id = s.past_job
WHERE
    s.id = '1';

-- 4. Winston Churchill
-- (4.1) Look at reviews of various positions
SELECT
    r.rating,
    r.review,
    jp.title,
    c.name
FROM
    coop_connect.review r
    JOIN coop_connect.job_position jp on jp.id = r.job_position_id
    JOIN coop_connect.company c on jp.company_id = c.id
ORDER BY
    c.id,
    jp.id;

-- (4.2) Look for jobs that want a certain major
SELECT
    *
FROM
    coop_connect.job_position
WHERE
    targeted_majors = 'Computer Science';

-- (4.3) Get contact info of recruiter from a certain company
SELECT
    hm.name,
    hm.position,
    hm.email
FROM
    coop_connect.hiring_manager hm
    JOIN coop_connect.company c on c.id = hm.company_id
WHERE
    c.name = 'Microsoft';

-- (4.4) Get contact info of recruiters of job positions that want a certain major
SELECT
    hm.name,
    hm.position,
    hm.email,
    jp.title,
    jp.description
FROM
    coop_connect.hiring_manager hm
    JOIN coop_connect.job_position jp on hm.company_id = jp.company_id
WHERE
    jp.targeted_majors = 'Computer Science';

-- (4.5) Get list of industries and the companies within them
SELECT
    i.name,
    c.name
FROM
    coop_connect.industry i
    JOIN coop_connect.company c on i.id = c.industry
ORDER BY
    i.name,
    c.name;

-- (4.6) Delete students no longer at Northeastern
DELETE FROM coop_connect.student
WHERE
    student.id = 4;

-- insert mockaroo data here NOT DONE YET!!!!
-- College table data
insert into college (id, name) values (1, 'Massachusetts Institute of Technology');
insert into college (id, name) values (2, 'Northeastern University');
insert into college (id, name) values (3, 'Tufts University');
insert into college (id, name) values (4, 'Boston College');
insert into college (id, name) values (5, 'Boston College');
insert into college (id, name) values (6, 'Massachusetts Institute of Technology');
insert into college (id, name) values (7, 'Massachusetts Institute of Technology');
insert into college (id, name) values (8, 'Harvard University');
insert into college (id, name) values (9, 'Boston College');
insert into college (id, name) values (10, 'Boston College');
insert into college (id, name) values (11, 'Boston College');
insert into college (id, name) values (12, 'Northeastern University');
insert into college (id, name) values (13, 'Harvard University');
insert into college (id, name) values (14, 'Boston College');
insert into college (id, name) values (15, 'Boston College');
insert into college (id, name) values (16, 'Boston College');
insert into college (id, name) values (17, 'Boston University');
insert into college (id, name) values (18, 'Boston University');
insert into college (id, name) values (19, 'Northeastern University');
insert into college (id, name) values (20, 'Massachusetts Institute of Technology');
insert into college (id, name) values (21, 'Tufts University');
insert into college (id, name) values (22, 'Massachusetts Institute of Technology');
insert into college (id, name) values (23, 'Northeastern University');
insert into college (id, name) values (24, 'Northeastern University');
insert into college (id, name) values (25, 'Northeastern University');
insert into college (id, name) values (26, 'Harvard University');
insert into college (id, name) values (27, 'Northeastern University');
insert into college (id, name) values (28, 'Massachusetts Institute of Technology');
insert into college (id, name) values (29, 'Boston College');
insert into college (id, name) values (30, 'Harvard University');
insert into college (id, name) values (31, 'Boston University');
insert into college (id, name) values (32, 'Harvard University');
insert into college (id, name) values (33, 'Harvard University');
insert into college (id, name) values (34, 'Northeastern University');
insert into college (id, name) values (35, 'Harvard University');
insert into college (id, name) values (36, 'Massachusetts Institute of Technology');
insert into college (id, name) values (37, 'Tufts University');
insert into college (id, name) values (38, 'Tufts University');
insert into college (id, name) values (39, 'Boston University');
insert into college (id, name) values (40, 'Tufts University');

-- Department table data
insert into department (id, college, name) values (1, '36', 'College of Computer Science');
insert into department (id, college, name) values (2, '30', 'School of Business');
insert into department (id, college, name) values (3, '9', 'School of Business');
insert into department (id, college, name) values (4, '40', 'College of Computer Science');
insert into department (id, college, name) values (5, '11', 'College of Arts and Sciences');
insert into department (id, college, name) values (6, '12', 'College of Computer Science');
insert into department (id, college, name) values (7, '10', 'College of Arts and Sciences');
insert into department (id, college, name) values (8, '34', 'School of Business');
insert into department (id, college, name) values (9, '16', 'School of Business');
insert into department (id, college, name) values (10, '19', 'College of Computer Science');
insert into department (id, college, name) values (11, '33', 'College of Arts and Sciences');
insert into department (id, college, name) values (12, '4', 'School of Business');
insert into department (id, college, name) values (13, '2', 'College of Computer Science');
insert into department (id, college, name) values (14, '28', 'College of Computer Science');
insert into department (id, college, name) values (15, '14', 'School of Business');
insert into department (id, college, name) values (16, '35', 'College of Arts and Sciences');
insert into department (id, college, name) values (17, '39', 'School of Business');
insert into department (id, college, name) values (18, '1', 'School of Business');
insert into department (id, college, name) values (19, '23', 'College of Computer Science');
insert into department (id, college, name) values (20, '15', 'College of Computer Science');
insert into department (id, college, name) values (21, '13', 'College of Computer Science');
insert into department (id, college, name) values (22, '6', 'School of Business');
insert into department (id, college, name) values (23, '20', 'College of Arts and Sciences');
insert into department (id, college, name) values (24, '26', 'College of Arts and Sciences');
insert into department (id, college, name) values (25, '8', 'College of Arts and Sciences');
insert into department (id, college, name) values (26, '17', 'College of Computer Science');
insert into department (id, college, name) values (27, '31', 'College of Arts and Sciences');
insert into department (id, college, name) values (28, '22', 'College of Arts and Sciences');
insert into department (id, college, name) values (29, '24', 'College of Computer Science');
insert into department (id, college, name) values (30, '29', 'College of Computer Science');
insert into department (id, college, name) values (31, '32', 'School of Business');
insert into department (id, college, name) values (32, '27', 'College of Computer Science');
insert into department (id, college, name) values (33, '5', 'School of Business');
insert into department (id, college, name) values (34, '37', 'College of Arts and Sciences');
insert into department (id, college, name) values (35, '7', 'School of Business');
insert into department (id, college, name) values (36, '25', 'School of Business');
insert into department (id, college, name) values (37, '18', 'School of Business');
insert into department (id, college, name) values (38, '21', 'College of Computer Science');
insert into department (id, college, name) values (39, '38', 'College of Computer Science');
insert into department (id, college, name) values (40, '3', 'College of Computer Science');

-- Major table data
insert into major (id, name, department) values (1, 'Data Science', 2);
insert into major (id, name, department) values (2, 'Accounting', 1);
insert into major (id, name, department) values (3, 'Journalism', 3);
insert into major (id, name, department) values (4, 'Cybersecurity', 2);
insert into major (id, name, department) values (5, 'Marketing', 1);
insert into major (id, name, department) values (6, 'French', 3);
insert into major (id, name, department) values (7, 'Journalism', 3);
insert into major (id, name, department) values (8, 'Marketing', 1);
insert into major (id, name, department) values (9, 'Finance', 1);
insert into major (id, name, department) values (10, 'Management', 1);
insert into major (id, name, department) values (11, 'Data Science', 2);
insert into major (id, name, department) values (12, 'Chemistry', 3);
insert into major (id, name, department) values (13, 'Cybersecurity', 2);
insert into major (id, name, department) values (14, 'Cybersecurity', 2);
insert into major (id, name, department) values (15, 'Management', 1);
insert into major (id, name, department) values (16, 'Physics', 3);
insert into major (id, name, department) values (17, 'Philosophy', 3);
insert into major (id, name, department) values (18, 'Management', 1);
insert into major (id, name, department) values (19, 'Accounting', 1);
insert into major (id, name, department) values (20, 'Management', 1);
insert into major (id, name, department) values (21, 'Cybersecurity', 2);
insert into major (id, name, department) values (22, 'Management', 1);
insert into major (id, name, department) values (23, 'Philosophy', 3);
insert into major (id, name, department) values (24, 'Chemistry', 3);
insert into major (id, name, department) values (25, 'Finance', 1);
insert into major (id, name, department) values (26, 'Chemistry', 3);
insert into major (id, name, department) values (27, 'Accounting', 1);
insert into major (id, name, department) values (28, 'Philosophy', 3);
insert into major (id, name, department) values (29, 'Physics', 3);
insert into major (id, name, department) values (30, 'Journalism', 3);
insert into major (id, name, department) values (31, 'Philosophy', 3);
insert into major (id, name, department) values (32, 'Environmental Studies', 3);
insert into major (id, name, department) values (33, 'Accounting', 1);
insert into major (id, name, department) values (34, 'Cybersecurity', 2);
insert into major (id, name, department) values (35, 'Chemistry', 3);
insert into major (id, name, department) values (36, 'Cybersecurity', 2);
insert into major (id, name, department) values (37, 'German', 3);
insert into major (id, name, department) values (38, 'Philosophy', 3);
insert into major (id, name, department) values (39, 'Management', 1);
insert into major (id, name, department) values (40, 'Accounting', 1);

-- Co-op Advisor table data
insert into coop_advisor (id, name, email, department_id) values (1, 'Darrel Swidenbank', 'dswidenbank0@marriott.com', '27');
insert into coop_advisor (id, name, email, department_id) values (2, 'Shaine Greenless', 'sgreenless1@vkontakte.ru', '3');
insert into coop_advisor (id, name, email, department_id) values (3, 'Josi Hallitt', 'jhallitt2@shinystat.com', '10');
insert into coop_advisor (id, name, email, department_id) values (4, 'Shermy Umbers', 'sumbers3@e-recht24.de', '9');
insert into coop_advisor (id, name, email, department_id) values (5, 'Lorrin Suttaby', 'lsuttaby4@arstechnica.com', '1');
insert into coop_advisor (id, name, email, department_id) values (6, 'Dani Young', 'dyoung5@opensource.org', '23');
insert into coop_advisor (id, name, email, department_id) values (7, 'Eydie Vedyasov', 'evedyasov6@wix.com', '21');
insert into coop_advisor (id, name, email, department_id) values (8, 'Kaleb Robertacci', 'krobertacci7@cafepress.com', '5');
insert into coop_advisor (id, name, email, department_id) values (9, 'Morrie Briddock', 'mbriddock8@nature.com', '14');
insert into coop_advisor (id, name, email, department_id) values (10, 'Mathilda Salleir', 'msalleir9@taobao.com', '7');
insert into coop_advisor (id, name, email, department_id) values (11, 'Germana Worsham', 'gworshama@ucla.edu', '29');
insert into coop_advisor (id, name, email, department_id) values (12, 'Michail Loxston', 'mloxstonb@disqus.com', '13');
insert into coop_advisor (id, name, email, department_id) values (13, 'Bryon Loude', 'bloudec@angelfire.com', '12');
insert into coop_advisor (id, name, email, department_id) values (14, 'Cristabel Beri', 'cberid@ovh.net', '16');
insert into coop_advisor (id, name, email, department_id) values (15, 'Milena Dallaway', 'mdallawaye@elpais.com', '18');
insert into coop_advisor (id, name, email, department_id) values (16, 'Elihu Sitlington', 'esitlingtonf@nasa.gov', '19');
insert into coop_advisor (id, name, email, department_id) values (17, 'Kirstin Abeau', 'kabeaug@weather.com', '15');
insert into coop_advisor (id, name, email, department_id) values (18, 'Gertrud Lyne', 'glyneh@cpanel.net', '32');
insert into coop_advisor (id, name, email, department_id) values (19, 'Jae Craft', 'jcrafti@topsy.com', '30');
insert into coop_advisor (id, name, email, department_id) values (20, 'Thorvald Rydings', 'trydingsj@sciencedaily.com', '37');
insert into coop_advisor (id, name, email, department_id) values (21, 'Tom Jaquemar', 'tjaquemark@printfriendly.com', '8');
insert into coop_advisor (id, name, email, department_id) values (22, 'Nickolai Gebbie', 'ngebbiel@goodreads.com', '22');
insert into coop_advisor (id, name, email, department_id) values (23, 'Jaquenette Glasscock', 'jglasscockm@ucla.edu', '36');
insert into coop_advisor (id, name, email, department_id) values (24, 'Derril Serginson', 'dserginsonn@alibaba.com', '39');
insert into coop_advisor (id, name, email, department_id) values (25, 'Harman Pappi', 'hpappio@trellian.com', '31');
insert into coop_advisor (id, name, email, department_id) values (26, 'Holmes Shivlin', 'hshivlinp@webs.com', '25');
insert into coop_advisor (id, name, email, department_id) values (27, 'Kathryn Pinnington', 'kpinningtonq@symantec.com', '4');
insert into coop_advisor (id, name, email, department_id) values (28, 'Tate Castagnaro', 'tcastagnaror@aboutads.info', '26');
insert into coop_advisor (id, name, email, department_id) values (29, 'Frank Gregh', 'fgreghs@cdbaby.com', '2');
insert into coop_advisor (id, name, email, department_id) values (30, 'Megan Antcliff', 'mantclifft@devhub.com', '20');
insert into coop_advisor (id, name, email, department_id) values (31, 'Keeley Roser', 'kroseru@biblegateway.com', '40');
insert into coop_advisor (id, name, email, department_id) values (32, 'Goddard Pettingall', 'gpettingallv@japanpost.jp', '6');
insert into coop_advisor (id, name, email, department_id) values (33, 'Chastity Donnelly', 'cdonnellyw@loc.gov', '28');
insert into coop_advisor (id, name, email, department_id) values (34, 'Melisenda Blue', 'mbluex@vinaora.com', '24');
insert into coop_advisor (id, name, email, department_id) values (35, 'Donnajean Hynd', 'dhyndy@theatlantic.com', '34');
insert into coop_advisor (id, name, email, department_id) values (36, 'Reinold Ing', 'ringz@sfgate.com', '17');
insert into coop_advisor (id, name, email, department_id) values (37, 'Cristina Spikeings', 'cspikeings10@ehow.com', '35');
insert into coop_advisor (id, name, email, department_id) values (38, 'Eolande Selwyn', 'eselwyn11@vkontakte.ru', '11');
insert into coop_advisor (id, name, email, department_id) values (39, 'Linn Mayoh', 'lmayoh12@biblegateway.com', '33');
insert into coop_advisor (id, name, email, department_id) values (40, 'Ariella Chiverstone', 'achiverstone13@smugmug.com', '38');

-- Industry table data
insert into industry (id, name) values (1, 'Healthcare');
insert into industry (id, name) values (2, 'Public Sector');
insert into industry (id, name) values (3, 'Technology');
insert into industry (id, name) values (4, 'Banking');
insert into industry (id, name) values (5, 'Consumer Services');
insert into industry (id, name) values (6, 'Government');
insert into industry (id, name) values (7, 'Energy');
insert into industry (id, name) values (8, 'Energy');
insert into industry (id, name) values (9, 'Education');
insert into industry (id, name) values (10, 'Banking');
insert into industry (id, name) values (11, 'Consumer Services');
insert into industry (id, name) values (12, 'Education');
insert into industry (id, name) values (13, 'Engineering');
insert into industry (id, name) values (14, 'Healthcare');
insert into industry (id, name) values (15, 'Sales and Trading');
insert into industry (id, name) values (16, 'Life Sciences');
insert into industry (id, name) values (17, 'Retail');
insert into industry (id, name) values (18, 'Retail');
insert into industry (id, name) values (19, 'Manufacturing');
insert into industry (id, name) values (20, 'Sales and Trading');
insert into industry (id, name) values (21, 'Energy');
insert into industry (id, name) values (22, 'Government');
insert into industry (id, name) values (23, 'Retail');
insert into industry (id, name) values (24, 'Technology');
insert into industry (id, name) values (25, 'Environment');
insert into industry (id, name) values (26, 'Healthcare');
insert into industry (id, name) values (27, 'Public Sector');
insert into industry (id, name) values (28, 'Sales and Trading');
insert into industry (id, name) values (29, 'Media and Communications');
insert into industry (id, name) values (30, 'Consumer Services');
insert into industry (id, name) values (31, 'Energy');
insert into industry (id, name) values (32, 'Public Sector');
insert into industry (id, name) values (33, 'Banking');
insert into industry (id, name) values (34, 'Environment');
insert into industry (id, name) values (35, 'Healthcare');
insert into industry (id, name) values (36, 'Technology');
insert into industry (id, name) values (37, 'Consumer Services');
insert into industry (id, name) values (38, 'Banking');
insert into industry (id, name) values (39, 'Consumer Services');
insert into industry (id, name) values (40, 'Media and Communications');

-- Company table data
insert into company (id, name, industry, location, description, criteria) values (1, 'Cummings-Brown', '31', 'Chicago', 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.');
insert into company (id, name, industry, location, description, criteria) values (2, 'Schmidt Group', '8', 'London', 'Nunc purus. Phasellus in felis.', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.');
insert into company (id, name, industry, location, description, criteria) values (3, 'McLaughlin, Sauer and Maggio', '36', 'Chicago', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.');
insert into company (id, name, industry, location, description, criteria) values (4, 'Ritchie, Ritchie and Romaguera', '20', 'Miami', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.');
insert into company (id, name, industry, location, description, criteria) values (5, 'Hettinger-Herman', '34', 'Toronto', 'Nunc rhoncus dui vel sem. Sed sagittis.', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into company (id, name, industry, location, description, criteria) values (6, 'Conroy and Sons', '29', 'Los Angeles', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.');
insert into company (id, name, industry, location, description, criteria) values (7, 'Leuschke Inc', '13', 'London', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.');
insert into company (id, name, industry, location, description, criteria) values (8, 'Considine LLC', '11', 'Toronto', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.');
insert into company (id, name, industry, location, description, criteria) values (9, 'Grant, DuBuque and Yundt', '9', 'Toronto', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.');
insert into company (id, name, industry, location, description, criteria) values (10, 'Haag and Sons', '24', 'Los Angeles', 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.');
insert into company (id, name, industry, location, description, criteria) values (11, 'Schmitt-Kiehn', '23', 'Boston', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.');
insert into company (id, name, industry, location, description, criteria) values (12, 'Kuvalis-Bahringer', '12', 'London', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.');
insert into company (id, name, industry, location, description, criteria) values (13, 'Schinner, Smitham and Gutkowski', '38', 'New York City', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.');
insert into company (id, name, industry, location, description, criteria) values (14, 'Gerlach-Kris', '25', 'Los Angeles', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into company (id, name, industry, location, description, criteria) values (15, 'Keebler-Lynch', '3', 'New York City', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.');
insert into company (id, name, industry, location, description, criteria) values (16, 'Mueller-McDermott', '15', 'Boston', 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into company (id, name, industry, location, description, criteria) values (17, 'Bartoletti, Runolfsdottir and Stamm', '19', 'New York City', 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.');
insert into company (id, name, industry, location, description, criteria) values (18, 'McDermott Group', '7', 'Boston', 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.');
insert into company (id, name, industry, location, description, criteria) values (19, 'Bode and Sons', '5', 'London', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.');
insert into company (id, name, industry, location, description, criteria) values (20, 'Feest, Braun and Schaden', '1', 'Boston', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.');
insert into company (id, name, industry, location, description, criteria) values (21, 'Crona, Emmerich and Connelly', '37', 'Boston', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.');
insert into company (id, name, industry, location, description, criteria) values (22, 'Reinger, Dicki and Lowe', '14', 'Boston', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into company (id, name, industry, location, description, criteria) values (23, 'Sipes Inc', '26', 'New York City', 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.');
insert into company (id, name, industry, location, description, criteria) values (24, 'Kirlin-Ankunding', '39', 'Miami', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.');
insert into company (id, name, industry, location, description, criteria) values (25, 'Heller, Dare and Harvey', '18', 'Chicago', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.');
insert into company (id, name, industry, location, description, criteria) values (26, 'Cole and Sons', '21', 'Charlotte', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.');
insert into company (id, name, industry, location, description, criteria) values (27, 'Prohaska-Goyette', '6', 'New York City', 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.');
insert into company (id, name, industry, location, description, criteria) values (28, 'Heidenreich-Daniel', '4', 'Miami', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.');
insert into company (id, name, industry, location, description, criteria) values (29, 'Paucek Inc', '2', 'Toronto', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.');
insert into company (id, name, industry, location, description, criteria) values (30, 'Grady Group', '30', 'Chicago', 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.');
insert into company (id, name, industry, location, description, criteria) values (31, 'Davis, Jones and Bashirian', '27', 'Miami', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.');
insert into company (id, name, industry, location, description, criteria) values (32, 'Haag-Kassulke', '28', 'New York City', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.');
insert into company (id, name, industry, location, description, criteria) values (33, 'Kunze-Herzog', '32', 'Charlotte', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.');
insert into company (id, name, industry, location, description, criteria) values (34, 'Wiegand, Hilpert and Larkin', '10', 'Boston', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into company (id, name, industry, location, description, criteria) values (35, 'Johnston Inc', '33', 'London', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.');
insert into company (id, name, industry, location, description, criteria) values (36, 'Cummings Group', '17', 'Boston', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into company (id, name, industry, location, description, criteria) values (37, 'Huel, Bernier and Goldner', '16', 'London', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.');
insert into company (id, name, industry, location, description, criteria) values (38, 'Durgan Group', '35', 'London', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.');
insert into company (id, name, industry, location, description, criteria) values (39, 'Bartoletti and Sons', '40', 'Boston', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into company (id, name, industry, location, description, criteria) values (40, 'Hilll-Dicki', '22', 'Chicago', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.');
