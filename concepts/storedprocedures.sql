#A stored procedure is a named collection of SQL statements that can be executed as a single unit. 
#It allows you to encapsulate business logic or repetitive tasks into a reusable database object.
# SP can do things which queries can't
# inside SP we can have multiple statements like select,loop,case(when then), 
#e.g. of shortand if statement
SELECT
    IIF(salary > 50000, 'High', 'Low') AS salary_category,
    employee_id,
    salary
FROM employees;

create database procedures;
use procedures;
#simple sp
DELIMITER //
CREATE PROCEDURE greet_user()
BEGIN
    SELECT 'Hello, User!' AS message;
END //
DELIMITER ;

call greet_user();

CREATE TABLE CUSTOMERS (
   ID INT NOT NULL,
   NAME VARCHAR (20) NOT NULL,
   AGE INT NOT NULL,
   ADDRESS CHAR (25),
   SALARY DECIMAL (18, 2),
   PRIMARY KEY (ID)
);
INSERT INTO CUSTOMERS VALUES 
(1, 'Ramesh', 32, 'Ahmedabad', 2000.00 ),
(2, 'Khilan', 25, 'Delhi', 1500.00 ),
(3, 'Kaushik', 23, 'Kota', 2000.00 ),
(4, 'Chaitali', 25, 'Mumbai', 6500.00 ),
(5, 'Hardik', 27, 'Bhopal', 8500.00 ),
(6, 'Komal', 22, 'Hyderabad', 4500.00 ),
(7, 'Muffy', 24, 'Indore', 10000.00 );
select * from customers;

#IN parameter takes input like functions
drop procedure slry ;
delimiter //
create procedure slry(in salary int) 
begin
	select * from customers c where c.salary<salary;
end//
delimiter ;
call slry(5000);

#OUT parameter used to send output values to calling program
#when calling output prefixed by @ to select
drop procedure if exists get_salary;
delimiter //
create procedure get_salary(in id int,out salary decimal(18,2))
	begin 
		select c.salary into salary 
		from customers c where c.id=id;
    end//
delimiter ;

call get_salary(4,@s);
select @s as salary;

create table products
(
	product_code			varchar(20) primary key,
	product_name			varchar(100),
	price					float,
	quantity_remaining		int,
	quantity_sold			int
);

create table sales
(
	order_id			int auto_increment primary key,
	order_date			date,
	product_code		varchar(20) references products(product_code),
	quantity_ordered	int,
	sale_price			float
);

insert into products (product_code,product_name,price,quantity_remaining,quantity_sold)
	values ('P1', 'iPhone 13 Pro Max', 1000, 5, 195);

insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('10-01-2022','%d-%m-%Y'), 'P1', 100, 120000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('20-01-2022','%d-%m-%Y'), 'P1', 50, 60000);
insert into sales (order_date,product_code,quantity_ordered,sale_price)
	values (str_to_date('05-02-2022','%d-%m-%Y'), 'P1', 45, 540000);
 
 #will select a specific product code and price 
#add data to sales with date
#update the product table for remaning quenity
drop procedure if exists pr_product;
delimiter //
create procedure pr_product()
	begin 
    declare v_pcode varchar(10);
    declare v_price int;
    
    select product_code,price
    into v_pcode,v_price from products
    where product_name = "iPhone 13 Pro Max";
    
    insert into sales(order_date,product_code,quantity_ordered,sale_price)
    values (cast(now() as date),v_pcode,1,v_price*1);
    
    update products
    set quantity_remaining = (quantity_remaining - 1),
		quantity_sold = quantity_sold + 1
        where product_code = v_pcode;
	
    select "product sold";
        
    end//
delimiter ;
    
call pr_product();
select * from products;


#with in and out parameter for more real example
DELIMITER $$

create procedure pr2_buy_products(in p_product_name varchar(40),in p_quantity int)
begin
	declare v_cnt           int;
	declare v_product_code  varchar(20);
	declare v_price         int;

    select count(*)
    into v_cnt
    from products
    where product_name = p_product_name
    and quantity_remaining >= p_quantity;

    if v_cnt > 0
    then
        select product_code, price
        into v_product_code, v_price
        from products
        where product_name = p_product_name
        and quantity_remaining >= p_quantity;

        insert into sales (order_date,product_code,quantity_ordered,sale_price)
			values (cast(now() as date), v_product_code, p_quantity, (v_price * p_quantity));

        update products
        set quantity_remaining = (quantity_remaining - p_quantity)
        , quantity_sold = (quantity_sold + p_quantity)
        where product_code = v_product_code;

        select 'Product sold!';
    else
        select 'Insufficient Quantity!';
    end if;
end$$

call pr2_buy_products("p1",2);
select * from products;




    

    


