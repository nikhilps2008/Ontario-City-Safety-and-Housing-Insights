Select *
from accident_ontario;

-- Removing Unwanted Columns
-- Remove Duplicates
-- Remove Null Values or Blank Values
-- Add Columns based on the needs

-- Creating a new table for staging process

create table acc_ont
like accident_ontario;

insert acc_ont
select *
from accident_ontario;

select *
from acc_ont;

-- Checking Duplicates

select *,row_number() over(partition by city, Year) as row_num
from acc_ont; 

with duplicate_cte as(select *,row_number() over(partition by city, Year) as row_num
from acc_ont)
select *
from duplicate_cte
where row_num > 1;

-- No duplicates

-- Removing Null values

Select *
from acc_ont
where City is null;

-- No null values

Select *
from acc_ont;