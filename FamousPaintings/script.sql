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



