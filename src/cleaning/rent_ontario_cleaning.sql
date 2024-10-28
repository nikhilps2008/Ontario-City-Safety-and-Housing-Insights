Select *
from rent_ontario;

-- Removing Unwanted Columns
-- Remove Duplicates
-- Remove Null Values or Blank Values
-- Add Columns based on the needs

-- Creating a new table for staging process

create table rent_ont
like rent_ontario;

insert rent_ont
select *
from rent_ontario;

select *
from rent_ont;

-- Checking Duplicates

select *,row_number() over(partition by City) as row_num
from rent_ont; 

with duplicate_cte as(select *,row_number() over(partition by city) as row_num
from rent_ont)
select *
from duplicate_cte
where row_num > 1;

-- No duplicates

-- Removing Null values

Select *
from rent_ont
where City is null;

-- No null values

SELECT *
FROM rent_ont;