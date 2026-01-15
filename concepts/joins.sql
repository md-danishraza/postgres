show databases;
create database joins;
use joins;

create table company(company_id varchar(10),company_name varchar(30),location varchar(100));

create table employee(emp_id varchar(20),emp_name varchar(30),
salary int,dept_id varchar(20),manager_id varchar(20));

create table department(dept_id varchar(20),dept_name varchar(50));

create table manager(manager_id varchar(20),manager_name varchar(50),dept_id varchar(20));

create table project(project_id varchar(20),project_name varchar(100),team_member_id varchar(20));


INSERT INTO Department (dept_id, dept_name)
VALUES
    ('D101', 'HR'),
    ('D102', 'Finance'),
    ('D103', 'IT');

INSERT INTO Manager (manager_id, manager_name, dept_id)
VALUES
    ('M201', 'Eve', 'D101'),
    ('M202', 'Frank', 'D102'),
    ('M203', 'Grace', 'D103');

INSERT INTO Project (project_id, project_name, team_member_id)
VALUES
    ('P301', 'Payroll System', 'E101'),
    ('P302', 'Financial Reporting', 'E102'),
    ('P303', 'Website Redesign', 'E103');

INSERT INTO Employee (emp_id, emp_name, salary, dept_id, manager_id)
VALUES
    ('E101', 'Alice', 60000, 'D101', 'M201'),
    ('E102', 'Bob', 55000, 'D102', 'M202'),
    ('E103', 'Charlie', 70000, 'D101', 'M201');
    
INSERT INTO Employee (emp_id, emp_name, salary, dept_id, manager_id)
VALUES
    ('E104', 'Raza', 100000, 'D104', 'M205');
    
    
# fetch employeename and department name they belong to 
# inner join and join are the same 
#only the dept column will be matched 
select e.emp_name,d.dept_name from employee as e join department as d on 
e.dept_id = d.dept_id;

#left join = inner +additional values in left table

#fetch details of all employees,their manager, their department and the project they works on
select e.emp_name,m.manager_name,d.dept_name,p.project_name from employee as e
left join department as d on e.dept_id = d.dept_id inner join manager as m on d.dept_id = m.dept_id 
left join project as p on p.team_member_id = e.emp_id;

select * from employee;

#full outer join is not available in mysql for this we use left join union right join
#outter join = inner+left+right join

SELECT e.emp_name, d.dept_name
FROM employee AS e
LEFT JOIN department AS d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_name, d.dept_name
FROM employee AS e
RIGHT JOIN department AS d ON e.dept_id = d.dept_id;

#cross joinn : cartesion product of each row with one another 
#used when we need to fetch data from table that is not connected
#we dont need define join condition 
insert into company values ("c001","farzi company","delhi");

# result = 4*1 = 4 row
select e.emp_name,d.dept_name,c.company_name from employee as e join department as d on 
e.dept_id = d.dept_id
cross join company as c;

#natural join 
#doesnt require join condition
#matches the name of column by itself  but if name is changed then do cross join
-- Step 1: Create the GFGemployees table
CREATE TABLE GFGemployees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    manager_id INT
);

-- Step 2: Insert sample data
INSERT INTO GFGemployees (employee_id, employee_name, manager_id)
VALUES
    (1, 'Zaid', 3),
    (2, 'Rahul', 3),
    (3, 'Raman', 4),
    (4, 'Kamran', NULL),
    (5, 'Farhan', 4);
    
select * from gfgemployees;
select employee.employee_id as emp_id,employee.employee_name as empname,
employee.manager_id as manager_id,manager.employee_name as manager
from gfgemployees as employee join gfgemployees as manager on 
employee.manager_id=manager.employee_id;




