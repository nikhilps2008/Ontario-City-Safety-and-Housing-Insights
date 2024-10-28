-- Final Datasets for EDA are acc_ont, crime_ont, rent_ont
-- we can combine acc_ont, crime_ont, rent_ont as they have common column City

Select *
from acc_ont;

Select *
from crime_ont;

Select *
from rent_ont;

-- What are the overall crime trends across cities from 2019 to 2023?

Select Year,sum(Total) as Total_Crimes
from crime_ont
group by 1;

-- Which cities have the highest and lowest crime for each year (2019-2023)?

SELECT City, Year, SUM(Total) AS Total_Crime
FROM crime_ont
GROUP BY City, Year
ORDER BY Year, Total_Crime desc;

WITH Ranked_Cities AS (SELECT City, Year, SUM(Total) AS Total_Crime, 
    RANK() OVER (PARTITION BY Year ORDER BY SUM(Total) DESC) AS Crime_Rank
    FROM crime_ont
    GROUP BY City, Year)
SELECT * 
FROM Ranked_Cities
WHERE Crime_Rank = 1 OR 
Crime_Rank = (SELECT MAX(Crime_Rank) 
FROM Ranked_Cities WHERE Year = Ranked_Cities.Year);

-- What is the distribution of accidents caused by alcohol, drugs, or both across all cities?

select City, sum(Alcohol) as accident_alcohol, sum(Drugs) as accident_drugs,
sum(Alcohol_Drugs) as accident_both
from acc_ont
group by 1
order by 2 desc;

-- Are there significant year-over-year changes in dangerous driving incidents across cities?

select city, Year, sum(dangerous_operation) as dangerous_driving
from acc_ont
group by 1,2
order by 3 desc;

WITH Dangerous_Driving_Trend AS (SELECT City, Year, SUM(dangerous_operation) AS Dangerous_Driving
    FROM acc_ont
    GROUP BY City, Year), Yearly_Changes AS (SELECT City, Year, Dangerous_Driving,
	LAG(Dangerous_Driving) OVER (PARTITION BY City ORDER BY Year) AS Previous_Year_Driving
    FROM Dangerous_Driving_Trend)
SELECT City, Year, Dangerous_Driving, Previous_Year_Driving, Dangerous_Driving - Previous_Year_Driving AS "Change Over Years"
FROM Yearly_Changes
ORDER BY City, Year;

-- How do rent prices in 2023 correlate with crime rates in each city?

SELECT c.City, 
       SUM(c.Total) AS Total_Crimes_2023, 
       r.avg_rent AS Avg_Rent_2023
FROM crime_ont c
JOIN rent_ont r ON c.City = r.City
where c.Year= 2023
GROUP BY c.City
order by 2 desc;

-- Which cities show the highest correlation between impaired driving and rent prices?

SELECT a.City, 
       SUM(a.Alcohol_Drugs)+sum(a.Alcohol)+Sum(a.Drugs) AS Impaired_Incidents, 
       r.avg_rent as Avg_rent_2023
FROM acc_ont a
JOIN rent_ont r ON a.City = r.City
WHERE a.Year = 2023
GROUP BY 1
ORDER BY 2 DESC;

-- Are certain types of accidents more prevalent in specific cities?

SELECT City, 
       SUM(Alcohol) AS Alcohol_Accidents, 
       SUM(Drugs) AS Drug_Accidents, 
       SUM(Alcohol_Drugs) AS Both_Accidents,
       sum(dangerous_operation) As 'Others'
FROM acc_ont
GROUP BY City
ORDER BY 2 DESC;




