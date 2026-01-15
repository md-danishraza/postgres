create database materialized;
use materialized;

#Views are useful for infrequent access, while materialized views are efficient for frequent access.
# store query expressions, whereas materialized views store actual data.
#Materialized views have storage costs and require maintenance, but they improve query performance.
#doesn't auto refresh 
create table randm(id int,val decimal);


INSERT INTO randm (id, val)
SELECT 1, RANDOM() * (1000000 - 1) + 1
FROM generate_series(1, 1000000);

-- Insert random values for ID 2
INSERT INTO randm (id, val)
SELECT 2, RANDOM() * (1000000 - 1) + 1
FROM generate_series(1, 1000000);

