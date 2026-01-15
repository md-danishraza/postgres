create database ORG;
use ORG;

CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);
describe worker;

INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, '14-02-20 09.00.00', 'HR'),
		(002, 'Niharika', 'Verma', 80000, '14-06-11 09.00.00', 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, '14-02-20 09.00.00', 'HR'),
		(004, 'Amitabh', 'Singh', 500000, '14-02-20 09.00.00', 'Admin'),
		(005, 'Vivek', 'Bhati', 500000, '14-06-11 09.00.00', 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, '14-06-11 09.00.00', 'Account'),
		(007, 'Satish', 'Kumar', 75000, '14-01-20 09.00.00', 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, '14-04-11 09.00.00', 'Admin');

select * from worker;

CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
	(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
		(001, 5000, '16-02-20'),
		(002, 3000, '16-06-11'),
		(003, 4000, '16-02-20'),
		(001, 4500, '16-02-20'),
		(002, 3500, '16-06-11');
        
CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2016-02-20 00:00:00'),
 (002, 'Executive', '2016-06-11 00:00:00'),
 (008, 'Executive', '2016-06-11 00:00:00'),
 (005, 'Manager', '2016-06-11 00:00:00'),
 (004, 'Asst. Manager', '2016-06-11 00:00:00'),
 (007, 'Executive', '2016-06-11 00:00:00'),
 (006, 'Lead', '2016-06-11 00:00:00'),
 (003, 'Lead', '2016-06-11 00:00:00');
 
#extract first name and in upper case
select first_name as workname from worker;
select upper(first_name) from worker;

#fetch unique dept
select distinct(department) from worker;

#first three char of firstname 
select substr(first_name,1,3) from worker;

#find first occurencef "b" or position 
select instr(first_name,"b") from worker where first_name = "amitabh";

#removing white spaces from name Rtrim and Ltrim
select rtrim(first_name) from worker;
select ltrim(department) from worker;

#unique dept and its length
select distinct(department),length(department) from worker;

#print firstname after replacing a with A
select replace(first_name,"a","A") from worker;
#merge names 
select concat(first_name," ",last_name) as name from worker;
#displace order details order by first_name 
select * from worker order by first_name,last_name desc ;

#fetch details for worker with firstname "satish" and "vipul"
 select * from worker where first_name = "satish" or first_name = "vipul";
select * from worker where first_name in ("satish","vipul");
select * from worker where first_name not in ("satish","vipul");

#fetch details with dept name as admin
select * from worker where department = "admin";
#like for wildcard pattern matching 
#fetch workers whose first name contains "a"
select * from worker where first_name like "%a%";
#fetch workers whose first name end with "h" and contains 6 letters
select * from worker where first_name like "______h";
#worker whose salary lies between 1l and 5l
select * from worker where 100000<salary<500000;

#find details who join in feb 2014
select * from worker where month(joining_date) = 2  and year(joining_date)=2014;

#count of no of emp in admin
select department,count(*) as total_emp from worker
group by department having department = "admin";
#fetch full name with salary 50000<10000
select concat(first_name," ",last_name) as fullname,salary from worker
where 50000<salary<100000;

-- Q-23. Write an SQL query to fetch the no. of workers
-- for each department in the descending order.
select department,count(*) as workers from worker group by department
order by workers desc;
-- Q-24. Write an SQL query to print details of the Workers
-- who are also Managers.
select * from worker where worker_id in (select worker_ref_id from
title);
select e.worker_id,concat(e.first_name," ",e.last_name) as Name ,t.worker_title
from worker e join title t on e.worker_id=t.worker_ref_id;

-- Q-25. Write an SQL query to fetch number (more than 1) of same
-- titles in the ORG of different types.
select worker_title, count(*) as ttitles from title group by worker_title
having ttitles>1;

-- Q-26. Write an SQL query to show only odd rows from a table.
select * from worker where mod(worker_id,2) != 0;
select * from worker where mod(worker_id,2) = 0;

-- Q-28. Write an SQL query to clone a new table from another table.
create table work_clone like worker;
insert into work_clone (
select * from worker);
select * from work_clone;

-- Q-29. Write an SQL query to fetch intersecting records of two tables.
#we use "using()" condition when keyname are same
select w.* from worker w join work_clone wd using(worker_id);

-- Q-30. Write an SQL query to show records from one table that another table does not have.
select * from worker where worker_id not in (select worker_ref_id from title);
select *
from worker w left join title t on w.worker_id = t.worker_ref_id 
where t.worker_ref_id is null;

-- Q-31. Write an SQL query to show the current date and time.
select now();
select curdate();
select current_timestamp();

-- Q-32. Write an SQL query to show the top n (say 5) records of a table order by descending salary.

select * from worker order by salary desc limit 5;

-- Q-33. Write an SQL query to determine the nth (say n=5) highest salary from a table.
select * from (
select *,
rank() over(order by salary desc) as ranks
from worker) as w
where w.ranks = 5;


# 4 offset will start from 5th and give me 1 value
select * from worker order by salary desc limit 4,1;

-- Q-35. Write an SQL query to fetch the list of employees with the same salary.
#self join with different id
select concat(w1.first_name,w1.last_name) as name,w1.salary from worker w1
join worker w2 on w1.salary = w2.salary and w1.worker_id!=w2.worker_id;

-- Q-36. Write an SQL query to show the second highest salary from a table using sub-query
select max(salary) from worker where salary not in (select max(salary) from worker);

-- Q-37. Write an SQL query to show one row twice in results from a table.
select * from worker union all 
select * from worker order by worker_id;

-- Q-38. Write an SQL query to list worker_id who does not get bonus.
select * from worker where worker_id not in (select worker_ref_id from bonus);
select w.*
from worker w left join bonus b on w.worker_id=b.worker_ref_id 
where b.worker_ref_id is null;

-- Q-39. Write an SQL query to fetch the first 50% records from a table.
select * from worker where worker_id <= (select count(worker_id)/2 from worker);

-- Q-40. Write an SQL query to fetch the departments that have less than 4 people in it.
select department from worker group by department having count(*) < 4;
select * from worker;

-- Q-41. Write an SQL query to show all departments along with the number of people in there.
select department,count(*) as num_emp from worker group by department;

-- Q-42. Write an SQL query to show the last record from a table.
select * from worker order by worker_id desc limit 1;

-- Q-43. Write an SQL query to fetch the first row of a table.
select * from worker where worker_id = (select min(worker_id) from worker);

-- Q-44. Write an SQL query to fetch the last five records from a table.
select * from (select * from worker order by worker_id desc limit 5) as x
order by x.worker_id;

-- Q-45. Write an SQL query to print the name of employees
-- having the highest salary in each department.
select * from worker where salary in (
select max(salary) from worker group by department);

with rankedsalaris as (
select *,
rank() over(partition by department order by salary desc) as ranks
from worker
)
select * from rankedsalaris where rankedsalaris.ranks=1;

-- Q-49. Write an SQL query to fetch departments along with the total salaries paid for each of them.
select department,sum(salary) as totalsalary from worker group by department;

-- Q-50. Write an SQL query to fetch the names of workers who earn the highest salary.
select concat(first_name,last_name) as name,salary from worker
where salary = (select max(salary) from worker);




-- Q-46. Write an SQL query to fetch three max salaries from a table using co-related subquery



