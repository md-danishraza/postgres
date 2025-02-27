-- ALTER TABLE work
-- ADD CONSTRAINT pk PRIMARY KEY (work_id),
-- ADD CONSTRAINT artist_fk FOREIGN KEY (artist_id) REFERENCES artist (artist_id),
-- ADD CONSTRAINT museum_fk FOREIGN KEY (museum_id) REFERENCES museum (museum_id);

-- select work_id from work group by work_id having count(*)>=2;
-- select work_id from image_link group by work_id having count(*)=2;

-- delete from work where work_id in (select work_id from work group by work_id having count(*)>=2);


-- q1. fetch all paintings which are not displayed in any museum.
-- SELECT * FROM work
-- WHERE museum_id IS NULL;
-- select * from work where museum_id not in (select museum_id from museum); 
-- select w.* from work as w join museum as m on w.museum_id=m.museum_id where m.* is null;


-- q2. Are there any museum without any paintings?
-- select * from museum where museum_id not in (select museum_id from museum);

-- q3. How many paintings have an asking price of more than their regular price?
-- select * from product_size;
-- select * from product_size where sale_price>regular_price; 


-- q4. Identify the paintings whose asking price is less than 50% of its regular price
-- select * from product_size where sale_price<(.5 * regular_price);


-- q5. Which canva size costs the most?
-- select cs.*,ps.sale_price from canvas_size cs join product_size ps on cs.size_id::text=ps.size_id 
-- order by ps.sale_price desc limit 1;

-- q.6 Delete duplicate records from work, product_size, subject and image_link tables
-- WITH cte AS (
--     SELECT work_id, RANK() OVER (PARTITION BY work_id ORDER BY ctid) AS ranks
--     FROM work
-- )
-- delete from work where ctid in (
-- SELECT ctid FROM cte WHERE ranks > 1
-- );

-- delete from work 
-- 	where ctid not in (select min(ctid)
-- 						from work
-- 						group by work_id );

-- delete from product_size 
-- where ctid not in (select min(ctid)
-- 					from product_size
-- 					group by work_id, size_id );

-- delete from subject 
-- where ctid not in (select min(ctid)
-- 					from subject
-- 					group by work_id, subject );

-- delete from image_link 
-- where ctid not in (select min(ctid)
-- 					from image_link
-- 					group by work_id );


-- q.7 Identify the museums with invalid city information in the given dataset
-- select * from museum;
-- select * from museum where city !~ '[0-9]';


-- q8.Museum_Hours table has 1 invalid entry. Identify it and remove it.
-- SELECT *, ctid
-- from museum_hours
-- select min(ctid) from museum_hours group by museum_id, day 


-- q9.Fetch the top 10 most famous painting subject
-- select * from subject;

-- with temp as (
-- select subject,count(*) as counts from subject group by subject
-- )
-- select * from temp order by counts desc limit 10;

-- select * 
-- 	from (
-- 		select s.subject,count(1) as no_of_paintings
-- 		,rank() over(order by count(1) desc) as ranking
-- 		from work w
-- 		join subject s on s.work_id=w.work_id
-- 		group by s.subject ) x
-- 	where ranking <= 10;


-- q10.Identify the museums which are open on both Sunday and Monday. Display 
-- museum name, city.

-- if count of day is 1 than it only opens either on sunday or monday
-- so count of day is 2 then it opens on both days
-- with temp as (
-- select museum_id,count(day) as counts from (
-- select * from museum_hours where day in ('Sunday','Monday')
-- )
-- group by museum_id)
-- select m.name,m.city from museum m join temp t using (museum_id)
-- where t.counts=2;

-- select distinct m.name as museum_name, m.city, m.state,m.country
-- from museum_hours mh 
-- join museum m on m.museum_id=mh.museum_id
-- where day='Sunday'
-- and exists (select 1 from museum_hours mh2 
-- 			where mh2.museum_id=mh.museum_id 
-- 			and mh2.day='Monday');


-- Q11.  How many museums are open every single day?
-- select * from museum_hours where day in ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');

-- select count(x.*) as total_museums_open_sevendays from
-- (select museum_id,count(day) as counts from museum_hours 
-- group by museum_id) as x 
-- where x.counts=7;

-- select count(1)
-- 	from (select museum_id, count(1)
-- 		  from museum_hours
-- 		  group by museum_id
-- 		  having count(1) = 7) x;


-- q12. Which are the top 5 most popular museum? (Popularity is defined based on most
-- no of paintings in a museum)
-- with temp as (
-- select m.museum_id,m.name,count(w.work_id)as counts from 
-- museum m join work w using (museum_id)
-- group by m.museum_id,m.name
-- )
-- select * from temp order by counts desc limit 5;


-- q13. Who are the top 5 most popular artist? (Popularity is defined based on most no of
-- paintings done by an artist)
--  with temp as(
-- select a.full_name,w.artist_id,count(w.*) as total_works
-- from work w join artist a using (artist_id)
-- group by w.artist_id,a.full_name
--  )
--  select * from temp order by total_works desc limit 5;



-- q14. Display the 3 least popular canva sizes
-- select * from canvas_size;
-- select * from product_size;
with temp as (
select size_id,count(*) as counts from product_size  group by size_id
)
select t.size_id,c.label,c.width,c.height,t.counts
from canvas_size c join temp t on c.size_id::text=t.size_id;



-- select label,ranking,no_of_paintings
-- 	from (
-- 		select cs.size_id,cs.label,count(1) as no_of_paintings
-- 		, dense_rank() over(order by count(1) ) as ranking
-- 		from work w
-- 		join product_size ps on ps.work_id=w.work_id
-- 		join canvas_size cs on cs.size_id::text = ps.size_id
-- 		group by cs.size_id,cs.label) x
-- 	where x.ranking<=3;


