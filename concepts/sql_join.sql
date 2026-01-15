create database sql_join;
show databases;
use sql_join;
#creating table
create table cricket (cricket_id int auto_increment,name varchar(30),primary key (cricket_id));
insert into cricket (name) values
('stuart'),('michael'),('johnson'),('hayden'),('fleming');
select * from cricket;

#creating footballtable
create table football (football_id int auto_increment,name varchar(30),primary key (football_id));
insert into football (name) values
('stuart'),('michael'),('johnson'),('hayden'),('astle');	
select * from football;
#selecting using inner join
select c.name,f.name,c.cricket_id,f.football_id from cricket as c
inner join football as f on c.name=f.name;

select * from cricket as c inner join football as f on c.name=f.name;
