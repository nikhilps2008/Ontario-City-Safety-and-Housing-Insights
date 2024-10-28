Select *
from crime_ontario;

-- Removing Unwanted Columns
-- Remove Duplicates
-- Remove Null Values or Blank Values
-- Add Columns based on the needs

-- Creating a new table for staging process

create table crime_ont
like crime_ontario;

insert crime_ont
select *
from crime_ontario;

select *
from crime_ont;

-- Checking Duplicates

select *,row_number() over(partition by City, Year) as row_num
from crime_ont; 

with duplicate_cte as(select *,row_number() over(partition by city, Year) as row_num
from crime_ont)
select *
from duplicate_cte
where row_num > 1;

-- No duplicates

-- Removing Null values

Select *
from crime_ont
where City is null;

-- No null values

Select *
from crime_ont;