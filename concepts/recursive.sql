create database recursiv;
use recursiv;

#A common table expression in MySQL is a temporary 
#result whose scope is confined to a single statement. 
#You can refer this expression multiple times with in the statement.

#A recursive CTE is a named temporary result set that refers to itself within the subquery.
#It’s particularly useful for scenarios like series generation and traversal of hierarchical or tree-structured data.

#syntax
WITH RECURSIVE cte_name (col1, col2, ...) AS (
    SELECT initial_query
    UNION [ALL]
    SELECT recursive_query
);

#generate number from 1 to 10
with recursive num(n) as (
select 1 
union all
select n+1 from num where n<10)
select * from num;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    manager_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

INSERT INTO employees (employee_id, manager_id, first_name, last_name) VALUES
    (1, NULL, 'John', 'Doe'),
    (2, 1, 'Alice', 'Smith'),
    (3, 1, 'Bob', 'Johnson'),
    (4, 2, 'Carol', 'Brown'),
    (5, 2, 'David', 'Lee'),
    (6, 3, 'Eva', 'Garcia'),
    (7, 3, 'Frank', 'Rodriguez'),
    (8, 4, 'Grace', 'Clark'),
    (9, 4, 'Henry', 'White'),
    (10, 5, 'Isabel', 'Martinez');
    
select e.employee_id,concat(e.first_name,e.last_name) as _name,
ed.manager_id as manager,concat(ed.first_name,ed.last_name) as managername  from employees as e
inner join employees as ed on e.manager_id=ed.employee_id;

-- SQL script to create an "employees" table with sample data

CREATE TABLE employees2 (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2),
    manager_id INT,
    designation VARCHAR(50)
);

INSERT INTO employees2 (emp_id, name, salary, manager_id, designation) VALUES
    (1, 'John Doe', 80000.00, NULL, 'CEO'),
    (2, 'Alice Smith', 60000.00, 1, 'Manager'),
    (3, 'Bob Johnson', 55000.00, 1, 'Manager'),
    (4, 'Carol Brown', 50000.00, 2, 'Team Lead'),
    (5, 'David Lee', 48000.00, 2, 'Team Lead'),
    (6, 'Eva Garcia', 45000.00, 3, 'Team Lead'),
    (7, 'Frank Rodriguez', 44000.00, 3, 'Team Lead'),
    (8, 'Grace Clark', 42000.00, 4, 'Developer'),
    (9, 'Henry White', 41000.00, 4, 'Developer'),
    (10, 'Isabel Martinez', 40000.00, 5, 'Developer');
    
#find the hierarchy of employees under a given manager "john doe"

WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, name, manager_id, designation,1 as lvl
    FROM employees2
    WHERE name = 'John Doe'  -- Replace with the desired manager's name
    UNION ALL
    SELECT e.emp_id, e.name, e.manager_id, e.designation,eh.lvl+1 as lvl
    FROM employees2 e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmployeeHierarchy;


#find the heirarchy of managers for employee 'grace clark';

WITH RECURSIVE EmployeeHierarchy AS (
    SELECT emp_id, name, manager_id, designation,1 as lvl
    FROM employees2
    WHERE name = 'grace clark'  -- Replace with the desired manager's name
    UNION ALL
    SELECT e.emp_id, e.name, e.manager_id, e.designation,eh.lvl+1 as lvl
    FROM employees2 e
    JOIN EmployeeHierarchy eh ON e.emp_id = eh.manager_id
)
SELECT * FROM EmployeeHierarchy;




