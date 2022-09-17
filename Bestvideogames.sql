--This project will be used to evaluate the top 400 best-selling video games that were created between 1977 and 2020.
--The dataset includes information on critic reviews, user reviews, and game sales.
--This data will be used to determine if video games have improved as the gaming market has grown.
--The selected data is pulled from Kaggle and has been limited to 400 rows (Per DataCamp)


--Begin by reviewing the top 10 selling games of all time. 

%%sql
postgresql:///games

-- Select all information for the top ten best-selling games
-- Order the results from best-selling game down to tenth best-selling
SELECT * FROM game_sales
ORDER BY games_sold DESC
LIMIT 10


--Missing review scores
--Exploring the missing reviews in the dataset

%%sql 

-- Join games_sales and reviews
-- Select a count of the number of games where both critic_score and user_score are null

SELECT COUNT(g.game)
FROM game_sales g
LEFT JOIN reviews r
ON g.game = r.game
WHERE critic_score IS NULL AND user_score IS NULL;



--Years that video game critics loved
--Less than 10% of the game_sales table don't have review data
--Measureing the best years for video games


%%sql

-- Select release year and average critic score for each year, rounded and aliased
-- Join the game_sales and reviews tables
-- Group by release year
-- Order the data from highest to lowest avg_critic_score and limit to 10 results

SELECT g.year, ROUND(AVG(r.critic_score),2) AS avg_critic_score
FROM game_sales g
INNER JOIN reviews r
ON g.game = r.game
GROUP BY g.year
ORDER BY avg_critic_score DESC
LIMIT 10;



--According to critics, 1982 to 2020 were the best years for video games
--Updating query to evaluate if 1982 was a great year for video games


%%sql 

-- Paste your query from the previous task; update it to add a count of games released in each year called num_games
-- Update the query so that it only returns years that have more than four reviewed games

SELECT g.year, COUNT(g.game) AS num_games, ROUND(AVG(r.critic_score),2) AS avg_critic_score
FROM game_sales g
INNER JOIN reviews r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_critic_score DESC
LIMIT 10;



--Years that dropped off the critic's favorites list


%%sql 

-- Select the year and avg_critic_score for those years that dropped off the list of critic favorites 
-- Order the results from highest to lowest avg_critic_score

SELECT year, avg_critic_score
FROM top_critic_years
EXCEPT
SELECT year, avg_critic_score
FROM top_critic_years_more_than_four_games
ORDER BY avg_critic_score DESC;


--Years video game players loved
--Looks like the 1990s might be considered the golden age of games based on the critic scores. 


%%sql 

-- Select year, an average of user_score, and a count of games released in a given year, aliased and rounded
-- Include only years with more than four reviewed games; group data by year
-- Order data by avg_user_score, and limit to ten results

SELECT g.year, COUNT(g.game) AS num_games, ROUND(AVG(r.user_score),2) AS avg_user_score
FROM game_sales g
INNER JOIN reviews r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_user_score DESC
LIMIT 10;



--Years the both players and critics loved


%%sql 

-- Select the year results that appear on both tables

SELECT year
FROM top_user_years_more_than_four_games
INTERSECT
SELECT year
FROM top_critic_years_more_than_four_games;


--Sales in the best video game years
--There are 3 years the both users and critics agreed were in the top ten best years of video games

%%sql 

-- Select year and sum of games_sold, aliased as total_games_sold; order results by total_games_sold descending
-- Filter game_sales based on whether each year is in the list returned in the previous task

SELECT g.year, SUM(g.games_sold) AS total_games_sold
FROM game_sales g
WHERE g.year IN (SELECT year
FROM top_user_years_more_than_four_games
INTERSECT
SELECT year
FROM top_critic_years_more_than_four_games)
GROUP BY g.year
ORDER BY total_games_sold DESC;
