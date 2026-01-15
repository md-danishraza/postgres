create database practice;
use practice;

 

-- Create a table
CREATE TABLE my_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

alter table my_table 
auto_increment = 10;

-- Display the data to see duplicates
SELECT * FROM my_table;

-- Query to remove duplicate rows

delete from my_table where id not in (
select min(id) from my_table group by id,name,age);

-- SQL doesn't allow you to modify the same table which you are selecting 
-- from in a subquery within the same statement
-- for this using CTE
set sql_safe_updates = 0;
with temp as (
select id ,name,age,
row_number() over (partition by name,age) as row_num
from my_table)	
delete from my_table where (id,name,age) in (
select id ,name,age from temp where row_num>1);

DELETE t1
FROM my_table t1
JOIN (
    SELECT MIN(id) AS min_id
    FROM my_table
    GROUP BY name, age
) t2 ON t1.id = t2.min_id;

set sql_safe_updates = 1;

-- Display the highest and lowest salary of employees for Each Department 
with temp as (select emp_id,
max(salary) over (partition by dept) as max,
min(salary) over (partition by dept) as min from employees)
select e.*,t.max,t.min from 
employees e join temp t on t.emp_id=e.emp_id where e.salary=t.max or e.salary=t.min;


-- Calculate each day distance covered by the car from consecutive distance 
CREATE TABLE car (
    car_id INT,
    car_name VARCHAR(50),
    date DATE,
    distance FLOAT
);
INSERT INTO car (car_id, car_name, date, distance) VALUES
(1, 'Toyota Camry', '2024-05-01', 50.2),
(1, 'Toyota Camry', '2024-05-02', 48.5),
(1, 'Toyota Camry', '2024-05-03', 55.3),
(2, 'Honda Civic', '2024-05-01', 45.8),
(2, 'Honda Civic', '2024-05-02', 47.2),
(2, 'Honda Civic', '2024-05-03', 51.1),
(3, 'Ford Mustang', '2024-05-01', 60.6),
(3, 'Ford Mustang', '2024-05-02', 62.3),
(3, 'Ford Mustang', '2024-05-03', 59.9);
-- lag by 1 and if There is no previous rule then default values 0 
-- will apply to each group 
with temp as (select *,
distance - lag(distance,1,0) over (partition by car_id) as distance_each_day
from car)
select car_name,date,distance,round(distance_each_day) from temp;



create table city_distance
(source varchar(30),destination varchar(30),distance int);

insert into city_distance values
("delhi","bihar",1000),
("bihar","delhi",1000),
("mumbai","chennai",500),
("chennai","mumbai",500);

-- remove indirect duplicate row 
set sql_safe_updates = 0;
delete from city_distance where distance = source;
select distinctrow * from city_distance;
set sql_safe_updates = 1;

with temp as (
select *, 
row_number() over () as rn from city_distance)
select t1.*from
temp t1 join temp t2 on t1.source=t2.destination and t2.source=t1.destination
						and t1.rn<t2.rn;
                        
                        
CREATE TABLE iplteams (
	id serial,
    team_name VARCHAR(50),
    full_form VARCHAR(100)
);

INSERT INTO iplteams (team_name, full_form) VALUES
('CSK', 'Chennai Super Kings'),
('MI', 'Mumbai Indians'),
('RCB', 'Royal Challengers Bangalore'),
('KKR', 'Kolkata Knight Riders'),
('RR', 'Rajasthan Royals'),
('SRH', 'Sunrisers Hyderabad'),
('DC', 'Delhi Capitals'),
('PBKS', 'Punjab Kings');

-- total matches if one each team
with temp as (
select * from iplteams)
select t.*,t1.* from temp t cross join temp t1 on t.id<t1.id where t.id != t1.id order by t.id;

SELECT 
    t1.team_name AS Team1, 
    t2.team_name AS Team2
FROM 
    iplteams t1
JOIN 
    iplteams t2 ON t1.team_name <> t2.team_name;
							-- not equals to 

-- sales difference month wise

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    amount DECIMAL(10, 2)
);

WITH temp AS (
    SELECT 
        EXTRACT(MONTH FROM sale_date) AS month,
        amount 
    FROM 
        sales
)
SELECT distinct
    t1.month AS month,
    t2.month AS next_month,
    ABS(t2.amount - t1.amount) AS diff 
FROM 
    temp t1 
JOIN 
    temp t2 ON t1.month = t2.month - 1;
