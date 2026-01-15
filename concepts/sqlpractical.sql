create database student_society;
use student_society;

#creating student table
create table student (
RollNo char(6),StudentName varchar(20),Course varchar(10),
DOB date,primary key (RollNo)
);

#creating society table
create table society (
SocID char(6),SocName varchar(20),MentorName varchar(15),
TotalSeats int unsigned,
primary key (SocID)
);

#creating enrollment table
create table enrollment (
RollNo char(6),SID char(6),DateOfEnrollment date,
foreign key (RollNo) references student(RollNo),
foreign key (SID) references society(SocID)
);

#inserting into students
INSERT INTO Student (rollno, studentname, course, dob)
VALUES
	('S12101', 'Aarav', 'Math', '2000-05-15'),
    ('S12202', 'Mayank', 'Physics', '1999-08-22'),
    ('S12303', 'Rahul', 'Chemistry', '2001-02-10'),
    ('S12404', 'Raju', 'History', '2000-11-30'),
    ('S12505', 'Chatur', 'English', '1998-07-05'),
    ('S12606', 'Manav', 'Com. Sci', '1999-12-18'),
    ('S12807', 'Dav', 'Biology', '2001-06-25'),
    ('S12908', 'Shiva', 'Geography', '2000-03-12'),
    ('X13009', 'Ritesh', 'Economics', '1998-09-08'),
    ('S13010', 'Sophia Martin', 'Psychology', '2001-04-03'),
	('S12627', 'Abhi', 'Com. Sci.', '2003-08-19'),
    ('S12713', 'Harsh Dubey', 'B.Voc. SD', '2005-02-11'),
    ('S12722', 'Nitish Singh', 'B.Voc. SD', '2005-01-22'),
    ('S12724', 'Prasant Kumar', 'B.Voc. SD', '2005-02-01'),
    ('S12726', 'Ranjana Gupta', 'B.Voc. SD', '2005-03-16'),
    ('S12727', 'Rishab Gupta', 'B.Voc. SD', '2005-05-19'),
    ('S12728', 'Ritik Gupta', 'B.Voc. SD', '2003-02-11'),
    ('S12735', 'Sahil Yadav', 'B.Voc. SD', '2004-02-02'),
    ('X12736', 'Saniya Batt', 'B.Voc. BNK', '2005-08-15'),
    ('X12739', 'Senha kumari', 'B.Voc. BNK', '2005-09-17'),
    ('Y12741', 'Suajl R kumar', 'B.Voc. SD', '2005-04-18'),
    ('Z12762', 'Amit Pal', 'B.Voc. SD', '2005-06-18'),
    ('S2766', 'Mridul', 'BMS', '2005-09-01'),
    ('Z2669', 'Sujit kumar', 'Com. Sci.', '2005-07-17');
    
#inserting into society
INSERT INTO Society (SocID, SocName, mentorName, totalSeats) VALUES
('Soc001', 'Math Club', 'Professor Aman', 50),
('Soc002', 'History Society', 'Dr. Rajendra', 40),
('Soc003', 'Physics Association', 'Professor Gupta', 30),
('Soc004', 'Chemistry Guild', 'Dr. Dayanand', 35),
('Soc014', 'CS Club', 'Prof. Mahesh', 60),
('Soc006', 'Biology Alliance', 'Dr. Kamal', 25),
('Soc007', 'English Society', 'Dr Harish', 45),
('Soc008', 'Economics Forum', 'Dr. Anand', 55),
('Soc009', 'Psychology Club', 'Prof. Ankit', 40),
('Soc010', 'Sociology Network', 'Dr. Rakesh', 30),
('Soc011', 'NCC', 'Dr. Akash', 30),
('Soc005', 'Debating', 'Dr. Ramesh', 40),
('Soc012', 'Dance', 'Prof. Vikram', 44),
('Soc013', 'Sashakt', 'Dr. Ajay', 35);

#inserting into enrollment
INSERT INTO Enrollment (RollNo, Sid, DateOfEnrollment) VALUES
('S12101', 'Soc001', '2024-03-01'),
('S12202', 'Soc002', '2024-03-05'),
('S12303', 'Soc003', '2024-03-10'),
('S12404', 'Soc004', '2024-03-15'),
('S12505', 'Soc005', '2024-03-20'),
('S12606', 'Soc006', '2024-03-25'),
('S12807', 'Soc007', '2024-03-30'),
('S12908', 'Soc008', '2024-04-05'),
('X13009', 'Soc009', '2024-04-10'),
('S13010', 'Soc010', '2024-04-15'),
('S12627', 'Soc005', '2024-04-20'),
('S12713', 'Soc011', '2024-04-25'),
('S12722', 'Soc013', '2024-05-01'),
('S12724', 'Soc013', '2024-05-05'),
('S12726', 'Soc013', '2024-05-10'),
('S12727', 'Soc013', '2024-05-15'),
('S12728', 'Soc012', '2024-05-20'),
('S12735', 'Soc012', '2024-05-25'),
('X12736', 'Soc013', '2024-05-30'),
('X12739', 'Soc013', '2024-06-05'),
('Y12741', 'Soc011', '2024-06-10'),
('Z12762', 'Soc011', '2024-06-15'),
('S2766', 'Soc011', '2024-06-20'),
('Z2669', 'Soc005', '2024-06-25');

# 1. Retrieve names of students enrolled in any society.
select s.studentname as Student_in_any_Soc from student as s
join enrollment as e on s.rollno=e.rollno;

# 2. Retrieve all society names.
select socname from society;

# 3. Retrieve students' names starting with letter ‘A’.
select studentname from student where studentname like 'a%';

#4. Retrieve students' details studying in courses
#   ‘computer science’ or ‘chemistry’.
select * from student;
select * from student where course ="com. sci." or course="chemistry";

# 5. Retrieve students’ names whose roll no either starts with ‘X’ or 
# ‘Z’ and ends with ‘9’
select rollno,studentname from student where rollno like 'x%9' 
or rollno like 'z%9';

# 7. Update society table for mentor name of a specific society
update society set mentorname="rishabh" where socID = "soc001";

# 8. Find society names in which more than five students have enrolled
select * from enrollment;
select s.socname,count(e.rollno) as enrolled_count 
from society as s join enrollment
as e on s.socid=e.sid group by s.socname having enrolled_count>5;

select socname from society where socid in (select sid from enrollment
group by sid having count(sid)>5);

# 9. Find the name of youngest student enrolled in society ‘Ncc’
select s.studentname,s.dob from student as s join enrollment as e on 
s.rollno = e.rollno join society as so on e.sid = so.socid where 
so.socname = "ncc" order by s.dob limit 1;

# 10. Find the name of most popular society (on the basis of enrolled students)
select * from enrollment;

select so.socname,count(e.rollno) as popularity 
from society as so join enrollment
as e on so.socid=e.sid group by e.sid order by popularity desc limit 5;

select count(rollno) as tolalEnrolled,sid from enrollment group by sid order by totalenrolled desc;

# 11. Find the name of two least popular societies (on the basis of enrolled students)
select so.socname,count(e.rollno) as popularity 
from society as so join enrollment
as e on so.socid=e.sid group by e.sid order by popularity limit 2;

select socname from society where socid in (select sid from enrollment
group by sid order by count(sid)) limit 1;

# 12. Find the student names who are not enrolled in any society
select s.studentname,e.sid from student as s left join enrollment as e
on s.rollno = e.rollno where e.sid is null;

select studentname from student 
where rollno not in (select rollno from enrollment);

select * from student;
select * from enrollment;
select * from society;
insert into enrollment values 
("s12102","soc002","2024-10-20"),
("s12102","soc003","2023-09-12");

# 13. Find the student names enrolled in at least two societies

select studentname from student as s where rollno in (select e.rollno from 
enrollment as e group by rollno having count(e.sid)>=2);

# 14. Find society names in which maximum students are enrolled
select socid,socname from society where socid = (select sid from enrollment
group by sid order by count(rollno) desc limit 1);

with total (soc_id,stcount) as (
		select sid,count(rollno) from enrollment 
        group by sid)
select s.socname,tt.stcount from society as s
join total as tt on tt.soc_id=s.socid order by tt.stcount desc limit 1;

# 15. Find names of all students who have enrolled in any society and society names in which at least one 
# student has enrolled
select distinct s.studentname from student as s 
join enrollment as e on s.rollno=e.rollno
union 
select distinct so.socname from society as so 
join enrollment as e on so.socid=e.sid;