Techniques Used: Selecting multiple columns, apllying filters, counting unique values, aggregating numeric data, sorting & grouping query

--This project explores New York Student's SAT scores.
--The data pulls students reading, math, and writing scores.


--Reviewing schools in the dataset

%%sql
postgresql:///schools
    
-- Select all columns from the database
-- Display only the first ten rows
SELECT * FROM schools
LIMIT 10



--Finding missing values
--Identifying how many schools that have missing percent_tested column
--This indicates the schools that did not report the percentage of students tested
--Result: number_tested_missing = 20 and num_school = 375


%%sql

-- Count rows with percent_tested missing and total number of schools

SELECT COUNT(*) - COUNT(percent_tested) as num_tested_missing, COUNT(*) as num_schools
FROM schools;




--Schools by building code
--There are 20 schools with missing percent_tested data (only makes up 5% of all rows in database)
--Reviewing how many unique school locations exist in our database
--Result: 233 out of 375 (62%) of schools have a unique building code

%%sql

-- Count the number of unique building_code values

SELECT COUNT(DISTINCT building_code) as num_school_buildings
FROM schools;





--Best schools for math
--Locating the schools that have an average math score of at least 80% (out of 800)
--Result: 10 schools in NYC with an average math score of at least 640


%%sql

-- Select school and average_math
-- Filter for average_math 640 or higher
-- Display from largest to smallest average_math

SELECT school_name, average_math
FROM schools
WHERE average_math >= 640
ORDER BY average_math DESC;




--Lowest reading score
--Result: lowest average score for reading acoss NYC is less than 40% of total available points
%%sql

-- Find lowest average_reading
SELECT MIN(average_reading) as lowest_reading
FROM schools





--Best writing school
--Find the highest average writing score
--Result: The average writing score is 693


%%sql

-- Find the top score for average_writing
-- Group the results by school
-- Sort by max_writing in descending order
-- Reduce output to one school

SELECT school_name, MAX(average_writing) as max_writing
FROM schools
GROUP BY school_name
ORDER BY max_writing DESC
LIMIT 1




--Top 10 schools
--Reviewing writing, reading, and math scores for the top 10 schools in NYC
--Result: There are 4 schools with average SAT scores over 2000


%%sql

-- Calculate average_sat
-- Group by school_name
-- Sort by average_sat in descending order
-- Display the top ten results

SELECT school_name, SUM(average_math + average_reading + average_writing) as average_sat
FROM schools
GROUP BY school_name
ORDER BY average_sat DESC
LIMIT 10;




--Ranking Boroughs
--Calculating the number of schools and the average SAT score per borough
--Results: Schools in Staten Island produce higher scores across all three categories

%%sql

-- Select borough and a count of all schools, aliased as num_schools
-- Calculate the sum of average_math, average_reading, and average_writing, divided by a count of all schools, aliased as average_borough_sat
-- Organize results by borough
-- Display by average_borough_sat in descending order

SELECT borough, COUNT(*) as num_schools, SUM(average_math + average_reading + average_writing)/COUNT(*) as average_borough_sat
FROM schools
GROUP BY borough
ORDER BY average_borough_sat DESC





--Brooklyn numbers
--There are 109 schools in Brooklyn
--Reviewing the top five schools for match performance

%%sql

-- Select school and average_math
-- Filter for schools in Brooklyn
-- Aggregate on school_name
-- Display results from highest average_math and restrict output to five rows

SELECT school_name, average_math
FROM schools
WHERE borough LIKE 'Brooklyn'
GROUP BY school_name
ORDER BY average_math DESC
LIMIT 5.


