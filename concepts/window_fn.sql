create database windowfn;
use windowfn;

#SQL Window Functions are powerful tools that allow you to perform 
#calculations across a set of rows related to the current row.
 #Unlike aggregate functions (which summarize data for an entire group),
 #window functions operate on a window of rows defined by a 
 #specific condition or partition.
 
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(255),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO Employee (employee_id, full_name, department, salary)
VALUES
    (100, 'Mary Johns', 'SALES', 1000.00),
    (101, 'Sean Moldy', 'IT', 1500.00),
    (102, 'Peter Dugan', 'SALES', 2000.00),
    (103, 'Lilian Penn', 'SALES', 1700.00),
    (104, 'Milton Kowarsky', 'IT', 1800.00),
    (105, 'Mareen Bisset', 'ACCOUNTS', 1200.00),
    (106, 'Airton Graue', 'ACCOUNTS', 1100.00);
    
select *,
max(salary) over(partition by department) as max from employee;

#selecting emp with max salary in each dept
select * from employee where salary in 
(select max(salary) over(partition by department) from employee);

# row_number()

#ranking by salary
select * from (
	select 
	*,row_number() over(partition by department order by salary desc) as top_salary
	from employee
    ) as e
where e.top_salary<=2;


#rank()
#give same rank for duplicate conditional values and skip that no of rank 
#for this we use dense_rank() which doesn't skip values
#fetch top 2 employee in each dep based on their salary same as above
select * from (
	select *,
	rank() over(partition by department order by salary desc)  as ranks
	from employee) as e 
where e.ranks<=2;

#The LAG() function retrieves the value from the row that precedes the current row.
#It’s useful for comparing values with the previous row.
#expression: The column or expression whose value you want to access from the next row.
#N: The number of rows succeeding the current row (optional; default is 1).
#default: The default value returned if no row succeeds the current row by N rows (optional; default is NULL).

select * ,
lag(salary) over (partition by department order by salary) as lagged
from employee;

select e.*,
lag(salary) over (partition by department order by salary) as lagged,
case when e.salary > lag(salary) over (partition by department order by salary) then "higher"
	 when e.salary = lag(salary) over (partition by department order by salary) then "equal"
     when e.salary < lag(salary) over (partition by department order by salary) then "lower"
     end as sal_range
from employee as e;

#The LEAD() function retrieves the value from the row that succeeds the current row.
#It’s useful for comparing values between consecutive rows.

CREATE TABLE products (
    prod_category VARCHAR(50),
    brand VARCHAR(50),
    prod_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (prod_category, brand, prod_name, price) VALUES
    ('smartwatch', 'Apple', 'MacBook Pro', 610.1),
    ('phone', 'Samsung', 'Galaxy Watch', 450.25),
    ('laptop', 'Dell', 'Inspiron', 707.75),
    ('phone', 'Sony', 'Xperia', 899.0),
    ('laptop', 'Lenovo', 'ThinkPad', 1200.5),
    ('smartwatch', 'Asus', 'ZenBook', 800.0),
    ('phone', 'Google', 'Pixel', 699.99),
    ('laptop', 'Xiaomi', 'Redmi', 550.0),
    ('smartwatch', 'LG', 'G8', 400.75),
    ('phone', 'Samsung', 'Galaxy S21', 999.0);
    
    
#first and last value value 
#frame clause
#The FRAME clause specifies the range of rows within the window. 
#It determines which rows are included in the calculation.
#e.g., BETWEEN 2 PRECEDING AND 1 FOLLOWING
#rows and range(current row :-
# rows - will only considers till current row
# range - will consider last row of repeated value 
select *,
first_value(prod_name) over(partition by prod_category order by price desc) 
as expensive,
last_value(prod_name) over(partition by prod_category order by price desc
					range between unbounded preceding and unbounded following) 
as least_expensive,
last_value(prod_name) over(partition by prod_category order by price desc
					rows between unbounded preceding and current row) 
as roww
from products;

# this will calculate avg in each category one by one 
select *,
AVG(price) OVER (PARTITION BY prod_category ORDER BY price ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as average
from products;


#nth value 
# q. write a query to display the second most expensive prod in each category
select *,
first_value(prod_name) over w as most_expensive,
last_value(prod_name) over w as least_expensive,
nth_value(prod_name,2) over w as 2nd_exp
from products
window w as (partition by prod_category order by price desc
		range between unbounded preceding and unbounded following) ;
        
        
#ntile
#buckets within a category/window with equal partition eg. 6row/ntile(2)= 3 buckets

select x.prod_name,x.price,
case when x.bucket=1 then "expensive"
	 else "notexpensic"
     end as range_
from (
	select *,
	ntile(3) over (order by price desc) as bucket
	from products 
	where prod_category= "phone") as x;
    
#cume_dist()
#  +row no <= current row / total no of row
# for duplicate records its going to cosider last row as current row 

#fetching prod which consitutes first 30% of data (in desc) 
select prod_name,price,cd from(
	select *,
	(cume_dist() over(order by price desc))*100 as cd
	from products 
	where prod_category="phone") as x
where x.cd<=50;

#precent_rank()
#same as cume_dist but it ranks in percent 
#formula =  +rows < currentrow-1 / totalrow-1

#which product is how much expensive when compared to all 
select *,
round((percent_rank() over(order by price))*100,2) as per_rank from products;

#Example: If there are 100 scores and the CUME_DIST is 90,
#it means that the score is at the 90th position in the list.

#Example: If there are 100 scores and the PERCENT_RANK is 90, 
#it means that the score is higher than 90% of the other scores.