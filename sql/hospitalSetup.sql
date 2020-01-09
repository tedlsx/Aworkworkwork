/*

-------------------------------------------- 

File to be run before doing the 2nd assignment

This sets up the Hospital  Tables 

---------------------------------------------

*/
show databases;

create database jiedan_db;
use jiedan_db;
show tables;

DROP TABLE IF EXISTS Hospital_CarriesOut;
DROP TABLE IF EXISTS Hospital_MedicalRecord;
DROP TABLE IF EXISTS Hospital_PhoneNum;
DROP TABLE IF EXISTS Hospital_Operation;
DROP TABLE IF EXISTS Hospital_Patient;
DROP TABLE IF EXISTS Hospital_Doctor;




CREATE TABLE Hospital_Patient (
NINumber CHAR(9) PRIMARY KEY,
fname VARCHAR(30),
lname VARCHAR(30),
dateOfBirth DATE,
street VARCHAR(20),
postcode CHAR(8),
houseno CHAR(4),
city VARCHAR(30),
gender ENUM ('f','m'),
weight DEC(5,2),
height DEC(3)
);

CREATE TABLE Hospital_Doctor (
NINumber CHAR(9) PRIMARY KEY,
fname VARCHAR(30),
lname VARCHAR(30),
dateOfBirth DATE,
street VARCHAR(20),
postcode CHAR(8),
houseno CHAR(4),
city VARCHAR(30),
expertise SET('heart','knee','brain','hip','eye','nose','throat','lungs','liver','spleen','stomach','ear','shoulder','nerve','kidneys','foot'),
salary DEC(7,2),
mentored_by  CHAR(9),
FOREIGN KEY (mentored_by) REFERENCES Hospital_Doctor(NINumber)
);

CREATE TABLE Hospital_PhoneNum(
person CHAR(9),
phoneNumber CHAR(12),
PRIMARY KEY(person,phoneNumber),
FOREIGN KEY (person) REFERENCES Hospital_Doctor(NINumber) 
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE Hospital_Operation(
theatreNo TINYINT UNSIGNED,
startDateTime DATETIME,
optype VARCHAR(60),
duration TIME,
patient CHAR(9) NOT NULL,
PRIMARY KEY(theatreNo,startDateTime),
FOREIGN KEY (patient) REFERENCES Hospital_Patient(NINumber)
);

CREATE TABLE Hospital_CarriesOut(
theatreNo TINYINT UNSIGNED,
startDateTime DATETIME,
doctor CHAR(9),
statement TEXT,
PRIMARY KEY (theatreNo, startDateTime, doctor),
FOREIGN KEY (doctor) REFERENCES Hospital_Doctor(NINumber),
FOREIGN KEY (theatreNo,startDateTime) REFERENCES Hospital_Operation(theatreNo,startDateTime)
ON DELETE CASCADE
ON UPDATE CASCADE
);

INSERT INTO Hospital_Patient VALUES ('AB234CD1X','Steven','Gerrard','1980-06-03','Ship Street','BN13AB','88A','Brighton','m',72.9,181);
INSERT INTO Hospital_Patient VALUES ('YZ999CD1A','Mary','Rose','1950-01-22','Main Street','WA22XC','2','Warmington-On-Sea','f',57.1,160);
INSERT INTO Hospital_Patient VALUES ('UYT00158U','Andy','Pitt','1964-07-07','London Road','MA3ZQ','67','Manchester','m',79.9,178);
INSERT INTO Hospital_Patient VALUES ('ZAS10158U','John','Pitt','1944-11-09','Blatchington Road','BN33AQ','67','Hove','m',69.1,188);
INSERT INTO Hospital_Patient VALUES ('ABC12234Y','Scarlett','Pitt','2000-11-12','Basin Road','FN23AQ','34','Frightfullington','f',59.1,164);

INSERT INTO Hospital_Doctor VALUES ('DD234CD1X','Mike','Hammer','1940-06-13','Maple Street','BN29AB','12','Brighton','knee,liver',80000,NULL);
INSERT INTO Hospital_Doctor VALUES ('DD0094CYY','Barry','Gibbson','1961-10-30','Main Street','BN29AB','2','Hove','knee,lungs,brain',50000,'DD0094CYY');
INSERT INTO Hospital_Doctor VALUES ('AB2323CYA','Peter','Falk','1966-01-30','London Street','LA102W','88','Liverpool','brain',70000.50,NULL);
INSERT INTO Hospital_Doctor VALUES ('DD1199XYZ','John','Smith',NULL,NULL,NULL,NULL,'London','lungs,kidneys',54000,'DD234CD1X');

INSERT INTO Hospital_Operation VALUES (1,'2019-05-04 8:11','heart op','4:11', 'AB234CD1X');
INSERT INTO Hospital_Operation VALUES (2,'2018-05-14 8:00','brain op','7:11', 'ZAS10158U');
INSERT INTO Hospital_Operation VALUES (2,'2018-05-13 19:30','liver op','2:50', 'ABC12234Y');
INSERT INTO Hospital_Operation VALUES (2,'2018-05-15 10:30','super op','2:50', 'ZAS10158U');
INSERT INTO Hospital_Operation VALUES (4,'2019-05-17 15:05','stomach op','2:00', 'UYT00158U');
INSERT INTO Hospital_Operation VALUES (4,'2019-05-12 05:30','ear op','02:14', 'AB234CD1X');
INSERT INTO Hospital_Operation VALUES (1,'2018-05-12 08:15','ear op','2:14', 'YZ999CD1A');
INSERT INTO Hospital_Operation VALUES (1,'2018-05-04 16:15','liver op','00:14', 'ZAS10158U');
INSERT INTO Hospital_Operation VALUES (1,'2018-05-12 00:15','hip and shoulder op','05:54', 'ABC12234Y');
INSERT INTO Hospital_Operation VALUES (2,'2018-05-20 12:30','extreme heart bypass surgery','5:50', 'ABC12234Y');
INSERT INTO Hospital_Operation VALUES (2,'2019-05-12 09:30','emergency op','4:50', 'ABC12234Y');

INSERT INTO Hospital_CarriesOut VALUES (1,'2019-05-04 8:11','DD234CD1X','');
INSERT INTO Hospital_CarriesOut VALUES (1,'2018-05-04 16:15','DD0094CYY','TEST4');
INSERT INTO Hospital_CarriesOut VALUES (2,'2018-05-14 8:00','DD1199XYZ','cut too deep but could stop blood loss');
INSERT INTO Hospital_CarriesOut VALUES (2,'2018-05-15 10:30','DD1199XYZ','cut too deep but could stop blood loss');
INSERT INTO Hospital_CarriesOut VALUES (4,'2019-05-17 15:05','AB2323CYA','cut too deep but could stop blood loss');
INSERT INTO Hospital_CarriesOut VALUES (4,'2019-05-12 05:30','AB2323CYA','needs pace maker');


#### 1.

CREATE table `Hospital_MedicalRecord`(
recNo SMALLINT,  
patient CHAR(9) NOT NULL,
doctor CHAR(9), 
enteredOn DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL, 
diagnosis MEDIUMTEXT NOT NULL, 
treatment VARCHAR(1000),
PRIMARY KEY(recNo, patient),
CONSTRAINT FK_patient foreign key Hospital_MedicalRecord(patient) REFERENCES Hospital_Patient(NINumber)
ON DELETE CASCADE ON UPDATE RESTRICT,
CONSTRAINT FK_doctor foreign key Hospital_MedicalRecord(doctor) REFERENCES Hospital_Doctor(NINumber)
ON DELETE RESTRICT ON UPDATE RESTRICT
);


### 2 
alter table Hospital_MedicalRecord
add column duration time;

### 3
SET SQL_SAFE_UPDATES = 0;
UPDATE Hospital_Doctor
SET salary=0.9*salary where expertise like "%ear%"; 

### 4
select fname, lname, year(dateOfBirth) as born
from Hospital_Patient
where city like "%right%"
order by lname, fname asc;

### 5
select  NINumber, fname, lname, round(weight/power(height/100, 2), 3) as BMI
from  Hospital_Patient
where timestampdiff(year, dateOfBirth, CURDATE()) < 30;

### 6
select count(NINumber) as number from Hospital_Doctor;

### 7
select t3.NINumber, t3.lname, ifnull(t3.operations, 0) from (
select t2.NINumber, t2.lname, t1.operations from
(select Hospital_Doctor.NINumber, count(*) as operations
from Hospital_Doctor
inner join
Hospital_CarriesOut on  Hospital_Doctor.NINumber = Hospital_CarriesOut.doctor
inner join 
Hospital_Operation on Hospital_CarriesOut.theatreNo = Hospital_Operation.theatreNo 
and
Hospital_CarriesOut.startDateTime = Hospital_Operation.startDateTime
where year(Hospital_CarriesOut.startDateTime) = year(curdate())
group by Hospital_Doctor.NINumber)
as t1
right join
(select DISTINCT Hospital_Doctor.NINumber, Hospital_Doctor.lname from 
Hospital_Doctor ) AS t2
on t1.NINumber = t2.NINumber
order by t1.operations desc) AS t3;  


### 8
select t2.NINumber, t2.init, t2.lname from
(select NINumber, mentored_by from Hospital_Doctor) as t1
left join
(select Hospital_Doctor.NINumber, left(Hospital_Doctor.fname, 1) as init, Hospital_Doctor.lname, Hospital_Doctor.mentored_by from
Hospital_Doctor) as t2
on t1.mentored_by = t2.NINumber
where t2.NINumber is not NULL and t2.mentored_by is NULL;

### 9
### need to compare the endDateTime with the other startTime1, 
### if endDateTime is before startTime1 then set the startTime1 of this endDateTime as the startTime2 
select theatreNo as theatre, startDateTime as startTime1, duration, date_add(startDateTime, interval  DATE_FORMAT(duration, "%H:%i") HOUR_MINUTE) as endDateTime
from Hospital_Operation;

select theatreNo as theatre, startDateTime as startTime1, DATE_FORMAT(duration+startDateTime, "%Y-%m-%d %H:%i:%s") from Hospital_Operation;

### 10
select t1.theatreNo, day(t1.Date_Time) as dom, monthname(t1.Date_Time) as month, year(t1.Date_Time) as year, max(t1.op) as numOps from
(SELECT theatreNo, DATE_FORMAT(startDateTime, '%Y-%m-%d') as Date_Time, count(*) as op
FROM Hospital_Operation
GROUP BY Date_Time
ORDER BY theatreNo) as t1
GROUP BY t1.theatreNo
;

### 11
SELECT theatreNo, IFNULL(lastMay, 0) AS lastMay, IFNULL(thisMay, 0) AS thisMay, IFNULL(inc, 0) as increase
FROM(
SELECT DISTINCT HO.theatreNo, lastMay, thisMay, (thisMay - lastMay) AS inc
FROM Hospital_Operation AS HO
LEFT JOIN
(
SELECT theatreNo, count(*) as lastMay
FROM Hospital_Operation
WHERE year(startDateTime) = year(curdate()) - 1 AND month(startDateTime) = 5
GROUP BY theatreNo) AS LASTYEAR
ON HO.theatreNo = LASTYEAR.theatreNo
LEFT JOIN
(
SELECT theatreNo, count(*) as thisMay
FROM Hospital_Operation
WHERE year(startDateTime) = year(curdate()) AND month(startDateTime) = 5
GROUP BY theatreNo) AS THISYEAR
ON LASTYEAR.theatreNo = THISYEAR.theatreNO) T
ORDER BY increase desc;

### 12
###
select * from Hospital_MedicalRecord;
select * from Hospital_CarriesOut;
select * from Hospital_Doctor;
select * from Hospital_Operation;
select * from Hospital_Patient;
select * from Hospital_Phonenum;
DROP FUNCTION usage_theatre;
###
DELIMITER &&
CREATE FUNCTION usage_theatre (theatreNo INT, input_year INT)
   RETURNS VARCHAR(255)
   DETERMINISTIC
	begin
		declare result varchar(255);
			if year(curdate()) < input_year
				then set result = "The year is in the future";
			elseif input_year is NULL
				then set result = concat("There is no operating theatre ", theatreNo);
            else
				set  result = input_year;
            end if;
		return result;
	end &&			
