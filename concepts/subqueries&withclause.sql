show databases;
create database subqueries;
use subqueries;
create table employees (emp_id int,emp_name varchar(50),dept varchar(50)
,salary int, region varchar(30)
);

INSERT INTO employees (emp_id, emp_name, dept, salary, region)
VALUES
  (1, 'John Doe', 'Engineering', 80000, 'US'),
  (2, 'Jane Smith', 'Marketing', 75000, 'Europe'),
  (3, 'Michael Lee', 'Sales', 65000, 'Asia'),
  (4, 'Olivia Brown', 'Finance', 90000, 'US'),
  (5, 'William Miller', 'IT', 70000, 'Europe'),
  (6, 'Sophia Garcia', 'Customer Service', 55000, 'Asia'),
  (7, 'David Davis', 'Engineering', 85000, 'North America'),
  (8, 'Jennifer Williams', 'Marketing', 80000, 'North America'),
  (9, 'Charles Johnson', 'Sales', 72000, 'US'),
  (10, 'Elizabeth Moore', 'Finance', 95000, 'Europe'),
  (11, 'Daniel Garcia', 'IT', 68000, 'Asia'),
  (12, 'Ashley Hernandez', 'Customer Service', 58000, 'North America'),
  (13, 'Robert Young', 'Engineering', 82000, 'US'),
  (14, 'Margaret Allen', 'Marketing', 78000, 'Europe'),
  (15, 'Joseph King', 'Sales', 70000, 'Asia'),
  (16, 'Kimberly Davis', 'Finance', 92000, 'North America'),
  (17, 'Matthew Garcia', 'IT', 65000, 'US'),
  (18, 'Nicole Lopez', 'Customer Service', 52000, 'Europe'),
  (19, 'Richard Baker', 'Engineering', 87000, 'Asia'),
  (20, 'Emily Jones', 'Human Resources', 50000, 'North America');
  
#selecting emp whose salary>avg salary 
select emp_id,emp_name,dept,salary from employees where salary >(select 
avg(salary) from employees);

#types of subqueries
#1.Scalar
#2. multiple rows 

#select employees with highest salary in each dept
select emp_name,dept,salary from employees where salary in (select max(salary) as max_salary
from employees group by dept);

select * from employees where (dept,salary) in 
(select dept,max(salary) from employees group by dept);

#corelated subquery
#find the employee in each dept who earn more than the avg of that dept
#for every record of outer record subquery gets executed
select * from employees as e1 
where salary>
		(select avg(salary) from employees as e2
		where e2.dept=e1.dept
        );
#here inner query is dependent on outer query


CREATE TABLE sales (
    store_id INT,
    store_name VARCHAR(50),
    product_name VARCHAR(50),
    quantity INT,
    price DECIMAL(10, 2)
);
INSERT INTO sales (store_id, store_name, product_name, quantity, price) VALUES
(1, 'Store A', 'Product X', 10, 20.50),
(1, 'Store A', 'Product Y', 5, 15.75),
(1, 'Store A', 'Product Z', 8, 12.99),
(2, 'Store B', 'Product X', 12, 22.75),
(2, 'Store B', 'Product Y', 6, 17.25),
(2, 'Store B', 'Product Z', 9, 14.50),
(3, 'Store C', 'Product X', 15, 25.00),
(3, 'Store C', 'Product Y', 7, 16.50),
(3, 'Store C', 'Product Z', 10, 13.75),
(4, 'Store D', 'Product X', 8, 21.25),
(4, 'Store D', 'Product Y', 4, 18.00),
(4, 'Store D', 'Product Z', 6, 11.99),
(5, 'Store E', 'Product X', 11, 23.99),
(5, 'Store E', 'Product Y', 3, 19.50),
(5, 'Store E', 'Product Z', 7, 10.25),
(6, 'Store F', 'Product X', 9, 24.50),
(6, 'Store F', 'Product Y', 8, 20.75),
(6, 'Store F', 'Product Z', 5, 9.99),
(7, 'Store G', 'Product X', 14, 26.75),
(7, 'Store G', 'Product Y', 2, 22.00);

#find stores whose sale is better than the avg sales across all the stores
select * from sales;
select store_name,sum(quantity*price) as revenue
from sales group by store_name having revenue>(select avg(quantity*price) from sales);


select store_name,sum(quantity*price) as total_sales
from sales group by store_name;
select avg(total_sales) as avg_sales
from (select store_name,sum(quantity*price) as total_sales
from sales group by store_name);

#select emp details and add remarks for those emp who earns > avg salary
select *,
	(case 
		when salary>(select avg(salary) from employees) then "greater"
        else "lower"
        end ) as remarks
from employees;

#find the stores who had sold more units than the avg unit of all the stores
select * from sales;
select store_name,sum(quantity) as unitsold
from sales group by store_name having unitsold >
(select avg(quantity) from sales);

#give 10% increment to all emloyees working in specific region
#bases on max salary earn by emp in each dept
select * from employees;
update employees 
set salary=salary+salary*0.1
where salary = (select max(salary) from employees group by dept
having dept = "us" );

SET SQL_SAFE_UPDATES = 0;

UPDATE employees 
SET salary = salary + salary * 0.1
WHERE dept = 'us'
AND salary = (SELECT MAX(salary) FROM (SELECT * FROM employees WHERE dept = 'us') AS temp);

SET SQL_SAFE_UPDATES = 1;

select * from employees;
#WITH clause in sql
#fetch employee who more than the average salary of all the emplyees
#common table expression cte 
#subquery refactoring 
with temp_table (average) as (
	select round(avg(salary),2) from employees
)
select * from employees,temp_table
where employees.salary>temp_table.average;

# select stores whose sales is greater than avg sales of all the stores
select * from sales;
select store_name,sum(quantity*price) as store_revenue from sales 
group by store_name
;

select avg(revenue) as total_average
from (select store_name,sum(quantity*price) as revenue from sales 
group by store_name) as x;

#using with clause

with total_table (store_name,store_sales) as (
		select store_name,sum(quantity*price) as store_sales from 
        sales group by store_name
        ),
	 average_table (total_avg) as (
		select avg(store_sales) from total_table
        )
select * from total_table as tt
join
average_table as av
on tt.store_sales > av.total_avg;

with dept_avg (dept,salary) as (
		select dept,avg(salary) from employees group by dept 
        )
select * from employees as emp
join dept_avg as av
where emp.salary > av.salary
and emp.dept = av.dept;

        
#test 
use subqueries;
select dept from employees group by dept having count(emp_id) > 2;
with emp_in_dep as 
(select dept,count(emp_id) as count from employees group by dept)
select dept from emp_in_dep where count>2;


select * from employees where dept != "marketing";

#select 3rd highest salary 
select salary from employees order by salary desc limit 1 offset 2;
#2nd max
select max(salary) from employees where salary not in (select max(salary) from
employees); 

#select second highest salary in each dept 
select t.emp_id,t.emp_name,t.dept,t.salary from 
	(
	select *,
	rank() over(partition by dept order by salary desc) as highestsalary
	from employees) as t
where t.highestsalary = 2;

#print alternate records or odd records 
select * from employees where emp_id%2=1;
#using cte 
with temp as 
(select *,
row_number() over(order by emp_id) as rn from employees
)
select * from temp where temp.rn%2=1;

select * from employees;
SET SQL_SAFE_UPDATES = 1;
update employees set salary = 70000 where emp_id = 9 ;

#SELECT EMP WITH SAME SALARIES 
with temp as (
select salary , count(*) as same from employees group by salary)
select e.* from employees e join temp on e.salary=temp.salary 
where temp.same>1;

select distinct e.* from employees e join employees e1 on e.salary = e1.salary and 
e.emp_id != e1.emp_id;

#print one row twice 
select t.* from 
	(select * from employees
	union all
	select * from employees) as t
where t.dept = "Sales" order by t.emp_id ;
