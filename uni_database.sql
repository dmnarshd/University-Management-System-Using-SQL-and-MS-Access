CREATE TABLE Department
(   departmentName varchar(25) PRIMARY KEY,
    phoneNo int,
    faxNo int,
    managerStartDate date,
    location varchar(15));


CREATE TABLE Course
(   courseCode varchar(25) PRIMARY KEY,
    courseTitle varchar(25),
    durationYears date
)

CREATE TABLE Module (
    moduleCode varchar(25) PRIMARY KEY,
    moduleTitle int,
    startDate date,
    endDate date,
    texts varchar(50),
    courseworkMarkPercentage int,
    examMarkPercentage int);

CREATE TABLE Student (
    userID varchar(10) PRIMARY KEY,
    matricNo int UNIQUE,
    firstName varchar(20),
    lastName varchar(20),
    town varchar(20),
    street varchar(20),
    postCode varchar(10),
    dateOfBirth date,
    sex char,
    financialLoan BOOLEAN DEFAULT FALSE NOT NULL);

  CREATE TABLE NextOfKin
  (
    nextOfKinID int PRIMARY KEY,
    name varchar(20),
    address varchar(50),
    phone int,
    relationship varchar(10)
    );  

CREATE TABLE academicStaff (
    staffNo varchar(10) PRIMARY KEY,
    userID varchar(10) UNIQUE,
    firstName varchar(20),
    lastName varchar(20),
    phoneExtNo int,
    officeNo varchar(5),
    sex char,
    salary NUMBER(10,2),
    post varchar(10),
    qualifications varchar(25),
    address varchar(30),
    departmentName varchar(25) REFERENCES Department(departmentName)
);

CREATE TABLE Enrollment (
    matricNo int REFERENCES Student(matricNo),
    moduleCode varchar(25) REFERENCES Module(moduleCode),
    PRIMARY KEY (matricNo,moduleCode)
);

CREATE TABLE TeachingSchedule (
    staffNo varchar(10) REFERENCES AcademicStaff(staffNo),
    moduleCode varchar(25) REFERENCES Module(moduleCode),
    PRIMARY KEY (staffNo,moduleCode),
    hoursPerWeek int
);

--Adding Foreign Keys to the inital tables --
ALTER TABLE Department ADD (staffNo varchar(10));
ALTER TABLE Department ADD CONSTRAINT fk_staffNo FOREIGN KEY (staffNo) 
REFERENCES AcademicStaff(staffNo);

ALTER TABLE Course ADD (staffNo varchar(10));
ALTER TABLE Course ADD (departmentName varchar(25));
ALTER TABLE Course ADD CONSTRAINT fk_CoursestaffNo FOREIGN KEY (staffNo) 
REFERENCES AcademicStaff(staffNo);
ALTER TABLE Course ADD CONSTRAINT fk_CourseDep FOREIGN KEY (departmentName) 
REFERENCES Department(departmentName);

ALTER TABLE Module ADD (staffNo varchar(10));
ALTER TABLE Module ADD (courseCode varchar(25));
ALTER TABLE Module ADD CONSTRAINT fk_modstaffNo FOREIGN KEY (staffNo) 
REFERENCES AcademicStaff(staffNo);
ALTER TABLE Module ADD CONSTRAINT fk_modCourse FOREIGN KEY (courseCode) 
REFERENCES Course(courseCode);

ALTER TABLE Student ADD (nextOfKinID int);
ALTER TABLE Student ADD (courseCode varchar(25));
ALTER TABLE Student ADD CONSTRAINT fk_stukin FOREIGN KEY (nextOfKinID) 
REFERENCES NextOfKin(nextOfKinID);
ALTER TABLE Student ADD CONSTRAINT fk_stuCourse FOREIGN KEY (courseCode) 
REFERENCES Course(courseCode);

---------------------Schema Created--------------------------
----ficing errors
ALTER TABLE Course MODIFY (durationYears NUMBER(2,1));
ALTER TABLE Module MODIFY (moduleTitle varchar(100));

-----adding checks
ALTER TABLE AcademicStaff ADD CONSTRAINT chk_sex_academic CHECK (sex IN ('M', 'F'));
ALTER TABLE Student ADD CONSTRAINT chk_sex_student CHECK (sex IN ('M', 'F'));
ALTER TABLE Module ADD CONSTRAINT chk_coursework_percent CHECK (courseworkMarkPercentage BETWEEN 0 AND 100);
ALTER TABLE Module ADD CONSTRAINT chk_exam_percent CHECK (examMarkPercentage BETWEEN 0 AND 100);
ALTER TABLE TeachingSchedule ADD CONSTRAINT chk_hours_positive CHECK (hoursPerWeek > 0 AND hoursPerWeek <= 40);

---Adding Indexes for Performace on FKS
CREATE INDEX idx_enroll_module ON Enrollment(moduleCode);
CREATE INDEX idx_teach_module ON TeachingSchedule(moduleCode);
CREATE INDEX idx_student_course ON Student(courseCode);
CREATE INDEX idx_module_course ON Module(courseCode);

-----Inserting Data
-- 1. First: Tables with NO foreign keys (parents)
INSERT INTO Department VALUES ('CIS', 1234, 5678, '01-JAN-2020', 'E Block', NULL);
INSERT INTO Department VALUES ('Business', 2345, 6789, '15-MAR-2019', 'A Block', NULL);
INSERT INTO Department VALUES ('Engineering', 3456, 7890, '10-JUN-2021', 'B Block', NULL);
INSERT INTO Department VALUES ('Humanities', 4567, 8901, '20-AUG-2020', 'C Block', NULL);
INSERT INTO Department VALUES ('Science', 5678, 9012, '05-MAY-2022', 'E Block', NULL);


-- 2. AcademicStaff (references Department)
INSERT INTO AcademicStaff VALUES ('S001', 'U001', 'John', 'Smith', 123, 'A101', 'M', 55000.00, 'Manager', 'PhD', '10 College Rd', 'CIS');
INSERT INTO AcademicStaff VALUES ('S002', 'U002', 'Jane', 'Doe', 124, 'A102', 'F', 60000.00, 'Manager', 'MSc', '20 Main St', 'CIS');
INSERT INTO AcademicStaff VALUES ('S003', 'U003', 'Bob', 'Brown', 125, 'A103', 'M', 45000.00, 'Lecturer', 'PhD', '30 Oak Ave', 'CIS');
INSERT INTO AcademicStaff VALUES ('S004', 'U004', 'Alice', 'White', 126, 'A104', 'F', 42000.00, 'Lecturer', 'PhD', '40 Pine Rd', 'Business');
INSERT INTO AcademicStaff VALUES ('S005', 'U005', 'Charlie', 'Black', 127, 'A105', 'M', 48000.00, 'Lecturer', 'MSc', '50 Cedar Ln', 'Engineering');


-- 3. Update Department managers (FK to AcademicStaff)
UPDATE Department SET staffNo = 'S001' WHERE departmentName = 'CIS';
UPDATE Department SET staffNo = 'S002' WHERE departmentName = 'Business';
UPDATE Department SET staffNo = 'S005' WHERE departmentName = 'Engineering';
UPDATE Department SET staffNo = 'S004' WHERE departmentName = 'Humanities';
UPDATE Department SET staffNo = 'S003' WHERE departmentName = 'Science';

-- 4. NextOfKin (no dependencies)
INSERT INTO NextOfKin VALUES (1, 'Mary Smith', '5 Elm St', 111222, 'Mother');
INSERT INTO NextOfKin VALUES (2, 'Tom Doe', '6 Maple Ave', 333444, 'Father');
INSERT INTO NextOfKin VALUES (3, 'Lisa Brown', '7 Pine St', 555666, 'Sister');
INSERT INTO NextOfKin VALUES (4, 'Paul White', '8 Oak Rd', 777888, 'Brother');
INSERT INTO NextOfKin VALUES (5, 'Ann Black', '9 Cedar Ave', 999000, 'Spouse');

-- 5. Course (references Department and AcademicStaff)
INSERT INTO Course VALUES ('PgDIT', 'Pg Diploma IT', 1.0, 'S001', 'CIS');
INSERT INTO Course VALUES ('MScCS', 'MSc Computer Science', 2.0, 'S003', 'CIS');
INSERT INTO Course VALUES ('BScIT', 'BSc IT', 3.0, 'S004', 'Business');
INSERT INTO Course VALUES ('MBA', 'Masters Business Admin', 1.5, 'S002', 'Business');
INSERT INTO Course VALUES ('BScEng', 'BSc Engineering', 3.0, 'S005', 'Engineering');

-- 6. Module (references AcademicStaff and Course)
INSERT INTO Module VALUES ('M101', 'Multi Media', '01-SEP-2025', '15-DEC-2025', 'Book1', 40, 60, 'S003', 'PgDIT');
INSERT INTO Module VALUES ('M102', 'Databases', '01-SEP-2025', '15-DEC-2025', 'Book2', 50, 50, 'S001', 'PgDIT');
INSERT INTO Module VALUES ('M103', 'Programming', '01-FEB-2026', '30-MAY-2026', 'Book3', 30, 70, 'S004', 'MScCS');
INSERT INTO Module VALUES ('M104', 'Networking', '01-SEP-2025', '15-DEC-2025', 'Book4', 40, 60, 'S003', 'BScIT');
INSERT INTO Module VALUES ('M105', 'Cyber Security', '01-FEB-2026', '30-MAY-2026', 'Book5', 50, 50, 'S005', 'BScEng');

-- 7. Student (references NextOfKin and Course)
INSERT INTO Student VALUES ('STU001', 1001, 'Tom', 'Jones', 'London', '1 High St', 'AB1 2CD', '15-MAY-2000', 'M', FALSE, 1, 'PgDIT');
INSERT INTO Student VALUES ('STU002', 1002, 'Sarah', 'Lee', 'London', '2 Low St', 'AB2 3DE', '20-JUN-2001', 'F', TRUE, 2, 'PgDIT');
INSERT INTO Student VALUES ('STU003', 1003, 'Mike', 'Wong', 'Bristol', '3 Hill Rd', 'BC3 4EF', '10-JUL-2000', 'M', FALSE, 1, 'MScCS');
INSERT INTO Student VALUES ('STU004', 1004, 'Emma', 'Davis', 'Birmingham', '4 Queen St', 'CD4 5FG', '05-AUG-2002', 'F', FALSE, 3, 'BScIT');
INSERT INTO Student VALUES ('STU005', 1005, 'James', 'Wilson', 'Manchester', '5 King Rd', 'DE5 6GH', '12-SEP-2001', 'M', TRUE, 4, 'MBA');

-- 8. Enrollment (references Student and Module)
INSERT INTO Enrollment VALUES (1001, 'M101', 'Pass');
INSERT INTO Enrollment VALUES (1001, 'M102', 'Pass');
INSERT INTO Enrollment VALUES (1002, 'M101', 'Fail');
INSERT INTO Enrollment VALUES (1002, 'M102', 'Pass');
INSERT INTO Enrollment VALUES (1003, 'M103', 'Pass');

-- 9. TeachingSchedule (references AcademicStaff and Module)
INSERT INTO TeachingSchedule VALUES ('S003', 'M101', 8);
INSERT INTO TeachingSchedule VALUES ('S001', 'M102', 5);
INSERT INTO TeachingSchedule VALUES ('S004', 'M103', 10);
INSERT INTO TeachingSchedule VALUES ('S003', 'M104', 7);
INSERT INTO TeachingSchedule VALUES ('S005', 'M105', 9);

-----Running queries
SELECT * FROM Department
WHERE location = 'E Block';

SELECT moduleTitle, startDate, endDate
FROM Module
WHERE courseCode= 'PgDIT';

SELECT firstName, lastName, address, salary 
FROM AcademicStaff
WHERE sex = 'F' AND post = 'Manager';

SELECT firstName, lastName, sex, salary 
FROM AcademicStaff
WHERE post ='Lecturer' AND qualifications='PhD';

SELECT lastName, post, qualifications
FROM AcademicStaff 
WHERE departmentName='CIS';

SELECT s.matricNo, s.lastName, s.sex
FROM Student s
JOIN Enrollment sm ON s.matricNo = sm.matricNo
JOIN Module m ON sm.moduleCode = m.moduleCode
WHERE m.moduleTitle = 'Multi Media';

SELECT staffNo, lastName, post, sex
FROM AcademicStaff 
WHERE salary>(SELECT AVG(salary) FROM AcademicStaff);

SELECT c.courseTitle, COUNT(s.matricNo) AS NumberOfStudents
FROM Course c
JOIN Student s ON c.courseCode = s.courseCode
GROUP BY c.courseCode, c.courseTitle
HAVING COUNT(s.matricNo) > 10;

SELECT sex, COUNT(staffNo) AS NumberOfStaff
FROM AcademicStaff
WHERE departmentName = 'CIS'
GROUP BY sex;

SELECT DISTINCT a.lastName, m.moduleTitle, t.hoursPerWeek
FROM AcademicStaff a
JOIN TeachingSchedule t ON a.staffNo = t.staffNo
JOIN Module m ON t.moduleCode=m.moduleCode
WHERE t.hoursPerWeek > 6;

-----------view 1---

CREATE VIEW DepartmentSummary AS
SELECT d.departmentName, d.location, a.firstName || ' ' || a.lastName AS managerName, d.managerStartDate
FROM Department d
JOIN AcademicStaff a ON d.staffNo = a.staffNo;

Select * From DepartmentSummary;

-----------view 2---

CREATE VIEW StudentPerformance AS
SELECT s.matricNo, s.firstName || ' ' || s.lastName AS studentName, c.courseTitle, 
       COUNT(e.moduleCode) AS modulesTaken,
       SUM(CASE WHEN e.performance = 'Pass' THEN 1 ELSE 0 END) AS modulesPassed
FROM Student s
JOIN Course c ON s.courseCode = c.courseCode
JOIN Enrollment e ON s.matricNo = e.matricNo
GROUP BY s.matricNo, s.firstName || ' ' || s.lastName, c.courseTitle;

Select * from StudentPerformance;

-----------view 3---
CREATE VIEW StaffTeachingLoad AS
SELECT a.staffNo, a.firstName || ' ' || a.lastName AS staffName, 
       COUNT(DISTINCT t.moduleCode) AS modulesTaught,
       SUM(t.hoursPerWeek) AS totalWeeklyHours
FROM AcademicStaff a
LEFT JOIN TeachingSchedule t ON a.staffNo = t.staffNo
GROUP BY a.staffNo, a.firstName || ' ' || a.lastName;

SELECT * FROM StaffTeachingLoad

-----------view 4---

CREATE VIEW ModuleEnrollmentStats AS
SELECT m.moduleCode, m.moduleTitle, COUNT(e.matricNo) AS enrolledStudents,
       SUM(CASE WHEN e.performance = 'Pass' THEN 1 ELSE 0 END) AS passedCount,
       ROUND(AVG(CASE WHEN e.performance = 'Pass' THEN 100 ELSE 0 END), 2) AS passRate
FROM Module m
LEFT JOIN Enrollment e ON m.moduleCode = e.moduleCode
GROUP BY m.moduleCode, m.moduleTitle;

SELECT * FROM ModuleEnrollmentStats

--------Aggregated Columns

------First column

ALTER TABLE Student ADD (totalModulesPassed NUMBER(3));

UPDATE Student s
SET totalModulesPassed = (
    SELECT COUNT(*)
    FROM Enrollment e
    WHERE e.matricNo = s.matricNo AND e.performance = 'Pass');

SELECT totalModulesPassed from Student;

-------Second Coumn

ALTER TABLE Module ADD (studentEnrollmentCount NUMBER(4));

UPDATE Module m
SET studentEnrollmentCount = (
    SELECT COUNT(*)
    FROM Enrollment e
    WHERE e.moduleCode = m.moduleCode);
SELECT studentEnrollmentCount FROM Module;

-------Third Column

ALTER TABLE academicStaff ADD (totalTeachingHours NUMBER(5));

UPDATE academicStaff a
SET totalTeachingHours = (
    SELECT SUM(t.hoursPerWeek)
    FROM TeachingSchedule t
    WHERE t.staffNo = a.staffNo);

SELECT totalTeachingHours FROM AcademicStaff;

-------Fourth Column

ALTER TABLE Course ADD (totalEnrolledStudents NUMBER(4));

UPDATE Course c
SET totalEnrolledStudents = (
    SELECT COUNT(*)
    FROM Student s
    WHERE s.courseCode = c.courseCode);
SELECT totalEnrolledStudents FROM Course;

-----Adding Cardinalities

-----NOT NULL Constraints

-- Course must have modules (1..*)
ALTER TABLE Module MODIFY (courseCode NOT NULL);

-- Module must have coordinator (1..*)
ALTER TABLE Module MODIFY (staffNo NOT NULL);

-- Student must be enrolled in a course
ALTER TABLE Student MODIFY (courseCode NOT NULL);

-- Student must have next of kin
ALTER TABLE Student MODIFY (nextOfKinID NOT NULL);

-----UNIQUE Constraints

ALTER TABLE Course ADD CONSTRAINT uk_courseTitle UNIQUE (courseTitle);
ALTER TABLE Module ADD CONSTRAINT uk_moduleTitle UNIQUE (moduleTitle);

-- Each next of kin belongs to one student only
ALTER TABLE Student ADD CONSTRAINT uk_student_nextofkin UNIQUE (nextOfKinID);