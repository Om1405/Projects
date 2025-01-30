USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Number of Rows in "movies" table
SELECT 
    COUNT(*) AS movies_count
FROM
    movie;

-- Number of Rows in "genre" table
SELECT 
    COUNT(*) AS genre_count
FROM
    genre;

-- Number of Rows in "ratings" table
SELECT 
    COUNT(*) AS ratings_count
FROM
    ratings;

-- Number of Rows in "names" table
SELECT 
    COUNT(*) AS names_count
FROM
    names;

-- Number of Rows in "director_mapping" table
SELECT 
    COUNT(*) AS director_mapping_count
FROM
    director_mapping;

-- Number of Rows in "role_mapping" table
SELECT 
    COUNT(*) AS role_mapping_count
FROM
    role_mapping;








-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    'country' AS column_name, COUNT(*) AS null_count
FROM movie
WHERE country IS NULL

UNION ALL

SELECT 
    'worlwide_gross_income' AS column_name, COUNT(*) AS null_count
FROM movie
WHERE worlwide_gross_income IS NULL

UNION ALL

SELECT 
    'languages' AS column_name, COUNT(*) AS null_count
FROM movie
WHERE languages IS NULL

UNION ALL

SELECT 
    'production_company' AS column_name, COUNT(*) AS null_count
FROM movie
WHERE production_company IS NULL;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total Number of movies released each year
SELECT 
    year AS Year, 
    COUNT(*) AS number_of_movies   	-- Using "COUNT" to get the total number of movies
FROM
    movie
GROUP BY year;

-- Total Number of movies released each month
SELECT 
    MONTH(date_published) AS month_num, -- Using "MONTH" To get the month from the "date_published" column
    COUNT(*) AS number_of_movies		-- Using "COUNT" to get the total number of movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    country, COUNT(*) AS number_of_movies
FROM
    movie
WHERE
    country IN ('USA' , 'India') -- Using "IN" Operator to find out movies produced in "USA" or "INDIA"
        AND year = 2019
GROUP BY country;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT		-- Using "DISTINCT" keyword to get unique values
    (genre)
FROM
    genre;





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
    genre, 
    COUNT(*) AS number_of_movies 	-- Using "COUNT" to count the number of movies
FROM
    genre
GROUP BY genre						-- Grouping by genre
ORDER BY number_of_movies DESC		-- Ordering by number of movies in descending order
LIMIT 1;							-- Limiting result to only 1




/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT 
    m.id AS movie_id, 			
    COUNT(g.genre) AS genre_count		-- Using "COUNT" to count the genre per movie
FROM
    movie AS m
        INNER JOIN						-- Joining "movie" and "genre" table using "movie_id"
    genre AS g ON g.movie_id = m.id
GROUP BY m.id							-- Grouping by "movie_id"
HAVING COUNT(g.genre) = 1;				-- Filtering out movies with only one genre




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
	g.genre as genre,
    round(avg(duration),2) as avg_duration 		-- Using "avg" function to find the average and "round" function to round of the value of the duration
FROM
	movie as m
    INNER JOIN 									-- Making an inner join of the table "movie" and "genre"
		genre as g
	ON g.movie_id = m.id					
WHERE m.id in 
(SELECT 
    m.id AS movie_id
FROM
    movie AS m
        INNER JOIN						
    genre AS g ON g.movie_id = m.id
GROUP BY m.id							
HAVING COUNT(g.genre) = 1)
GROUP BY g.genre;







/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
	genre,
    count(*) as movie_count,							-- Counting total number of movies
    RANK() OVER(ORDER BY count(*) DESC)	AS genre_rank	-- Using rank function to rank the genre based on count of the movies
FROM 
	genre
GROUP BY genre;											-- Grouping by genre




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
	min(avg_rating) as min_avg_rating, 				-- Finding mininmum "avg_rating"
    max(avg_rating) as max_avg_rating,				-- Finding maximum "avg_rating"
    min(total_votes) as min_total_votes,			-- Finding minimum "total_votes"
    max(total_votes) as max_total_votes,			-- Finding maximum "total_votes"
    min(median_rating) as min_median_rating,		-- Finding minimum "median_rating"
    max(median_rating) as max_median_rating			-- Finding maximum "median_rating"
FROM
	ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

WITH ranked_movies AS											-- Creating a Common Table Expression (CTE) named "ranked_movies"
(		
SELECT 
	m.title AS title,
    r.avg_rating AS avg_rating,
    DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank		-- Creating rank based on avg_rating column in descending order
FROM
	movie AS m
INNER JOIN 														-- Joining rating table with movie table
	ratings AS r
    ON r.movie_id = m.id
) 	
SELECT * FROM ranked_movies
WHERE movie_rank <= 10											-- Filter movies that are ranked between 1 to 10
ORDER BY movie_rank;											-- Ordering movie by their rank in ascending order





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, 
    COUNT(*) AS movie_count			-- Counting Total number of movies
FROM
    ratings
GROUP BY median_rating				-- Grouping the median_rating
ORDER BY median_rating;				-- Ordering by the median_rating in ascending order



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH hit_movies AS					-- Creating "hit_movies" named CTE
(
SELECT 
	m.production_company,
    COUNT(*) AS movie_count
FROM
	movie AS m
INNER JOIN							-- Joining movie and ratings table using movie_id
	ratings AS r
    ON r.movie_id = m.id
WHERE r.avg_rating > 8
GROUP BY m.production_company
)
SELECT 
	production_company,
    movie_count,
    RANK() OVER(ORDER BY movie_count DESC) as prod_company_rank		-- Using Rank function to rank based on count of hit movies
FROM 
	hit_movies
ORDER BY prod_company_rank;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	g.genre AS genre,
    COUNT(m.id) AS movie_count
FROM
	movie AS m
INNER JOIN
	ratings AS r
    ON r.movie_id = m.id
    INNER JOIN
		genre AS g
        ON g.movie_id = m.id
WHERE 
	m.date_published BETWEEN "2017-03-01" AND "2017-03-31"
    AND m.country = "USA"
    AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
	m.title AS title,
    r.avg_rating AS avg_rating,
    g.genre AS genre
FROM
	movie AS m
INNER JOIN
	ratings AS r
	ON r.movie_id = m.id
    INNER JOIN 
    genre AS g
    ON g.movie_id = m.id
WHERE 
	m.title REGEXP "^The" 
    AND r.avg_rating > 8;



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
    COUNT(*)
FROM
    (SELECT 
        m.id
    FROM
        movie AS m
    INNER JOIN ratings AS r ON r.movie_id = m.id
    WHERE
        m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
            AND r.median_rating > 8) AS T;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
	m.country AS country,
    SUM(r.total_votes) AS total_votes
FROM
	movie AS m
INNER JOIN 
	ratings AS r
    ON r.movie_id = m.id
WHERE m.country IN ("Germany", "Italy")
GROUP BY m.country
ORDER BY total_votes DESC;




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM
	names;
    



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH hit_movie AS
(
SELECT 
	n.name AS director_name,
    COUNT(m.id) AS movie_count,
    DENSE_RANK() OVER (ORDER BY COUNT(m.id)DESC) as movie_rank
FROM
	movie AS m
INNER JOIN
	genre AS g
    ON g.movie_id = m.id
    INNER JOIN 
		ratings AS r
		ON r.movie_id = m.id
        INNER JOIN 
			director_mapping AS d
            ON d.movie_id = m.id
            INNER JOIN 
				names AS n
                ON n.id = d.name_id
WHERE 
	r.avg_rating > 8
GROUP BY n.name
)
SELECT 
	director_name,
    movie_count
FROM hit_movie
WHERE movie_rank <= 3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    n.name AS actor_name, COUNT(m.id) AS movie_count
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON r.movie_id = m.id
        INNER JOIN
    role_mapping AS rm ON rm.movie_id = m.id
        INNER JOIN
    names AS n ON n.id = rm.name_id
WHERE
    rm.category = 'actor'
        AND r.median_rating > 8
GROUP BY n.name
ORDER BY movie_count DESC;





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_house_votes AS
(
SELECT
	m.production_company AS production_company,
    SUM(r.total_votes) AS vote_count,
    RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM
	movie AS m
INNER JOIN 
	ratings AS r
	ON r.movie_id = m.id
GROUP BY m.production_company
ORDER BY prod_comp_rank
)
SELECT * FROM prod_house_votes 
WHERE prod_comp_rank <= 3;







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_movies AS
(
SELECT
	n.name AS actor_name,
    m.id AS movie_id,
    r.total_votes AS total_votes,
    r.avg_rating AS avg_rating
FROM
	movie AS m
INNER JOIN 
	role_mapping AS rm
    ON rm.movie_id = m.id
	INNER JOIN
		names AS n
        ON n.id = rm.name_id
INNER JOIN 
	ratings AS r
    ON r.movie_id = m.id
WHERE 
	m.country = "India" 
	AND rm.category = "actor"
),
actor_stats AS
(
SELECT 
	actor_name,
    COUNT(movie_id) AS movie_count,
    SUM(total_votes) AS total_votes,
    SUM(avg_rating * total_votes) / SUM(total_votes) AS actor_avg_rating
FROM
	actor_movies
GROUP BY
	actor_name
HAVING 
	COUNT(movie_id) >= 5
),
ranked_actor AS
(
SELECT 
	actor_name,
    total_votes,
    movie_count,
	ROUND(actor_avg_rating, 2) AS actor_avg_rating,
    RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM 
	actor_stats
)SELECT * FROM ranked_actor;
    


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_movie AS
(
SELECT
	n.name AS actress_name,
    m.id AS movie_id,
    r.avg_rating AS avg_rating,
    r.total_votes AS total_votes
FROM
	movie AS m
INNER JOIN 
	role_mapping AS rm
    ON rm.movie_id = m.id
    INNER JOIN
		names AS n
        ON n.id = rm.name_id
INNER JOIN 
	ratings AS r
    ON r.movie_id = m.id
WHERE 
	m.country = "India"
    AND m.languages LIKE "%Hindi%"
    AND rm.category = "actress"
),
actress_stat AS
(
SELECT 
	actress_name,
    COUNT(movie_id) AS movie_count,
    SUM(total_votes) AS total_votes,
    SUM(avg_rating * total_votes) / SUM(total_votes) AS actress_avg_rating
FROM
	actress_movie
GROUP BY
	actress_name
HAVING 
	COUNT(movie_id) >= 3
),
ranked_actress AS
(
SELECT 
	actress_name,
    total_votes,
    movie_count,
    ROUND(actress_avg_rating,2) AS actress_avg_rating,
    RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM 
	actress_stat
)
SELECT * FROM ranked_actress;





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
WITH thriller_movie AS
(
SELECT
	m.title AS movie_name,
    g.genre AS genre,
    r.total_votes AS total_votes,
    r.avg_rating AS avg_rating
FROM
	movie AS m
    INNER JOIN 
		genre AS g
		ON g.movie_id = m.id
	INNER JOIN 
		ratings AS r
        ON r.movie_id = m.id
WHERE g.genre = "Thriller"
),
movie_votes AS
(
SELECT
	movie_name,
    SUM(total_votes) AS total_votes,
    avg_rating 
FROM
	thriller_movie
GROUP BY
	movie_name, avg_rating
HAVING 
	total_votes >= 25000
),
rating_bucket AS
(
SELECT 
	movie_name,
    avg_rating,
    CASE
		WHEN avg_rating > 8 THEN "Superhit"
        WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit"
        WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch"
        WHEN avg_rating < 5 THEN "Flop"
	END
    AS movie_category
FROM 
	movie_votes
)
SELECT 
	movie_name,
    movie_category
FROM
	rating_bucket
ORDER BY 
	avg_rating DESC;





/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_avg_duration AS
(
SELECT 
	g.genre AS genre,
    ROUND(AVG(m.duration),2) AS avg_duration
FROM
	movie AS m
    INNER JOIN 
		genre AS g
        ON g.movie_id = m.id
GROUP BY g.genre
),
running_total AS
(
SELECT
	genre,
    avg_duration,
    SUM(avg_duration) OVER(ORDER BY genre) AS running_total_duration,
    AVG(avg_duration) OVER(ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_duration
FROM 
	genre_avg_duration
)
SELECT 
	genre,
    avg_duration,
    running_total_duration,
    ROUND(moving_avg_duration, 2) AS moving_avg_duration
FROM
	running_total;



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH genre_movie_count AS
(
SELECT
	g.genre,
    COUNT(m.id) AS movie_count
FROM
	movie AS m
    INNER JOIN 
		genre AS g
        ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC
LIMIT 3
),
top_movies AS
(
SELECT
	g.genre AS genre,
    m.year AS year,
    m.title AS movie_name,
    m.worlwide_gross_income AS worldwide_gross_income,
    RANK() OVER(PARTITION BY g.genre, m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
FROM
	movie AS m
    INNER JOIN 
		genre AS g
        ON g.movie_id = m.id
        INNER JOIN 
			genre_movie_count AS top_genre
            ON top_genre.genre = g.genre
WHERE m.worlwide_gross_income IS NOT NULL
)
SELECT 
	genre,
    year,
    movie_name,
    worldwide_gross_income,
    movie_rank
FROM
	top_movies
WHERE movie_rank <= 5
ORDER BY genre, year, movie_rank;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH multilingual_movie AS
(
SELECT
	m.id as movie_id,
    m.production_company AS production_company
FROM
	movie AS m
    INNER JOIN
		ratings AS r
        ON r.movie_id = m.id
WHERE 	
	m.languages LIKE "%,%"
	AND r.median_rating >= 8
),
top_prod_company AS
(
SELECT
	production_company,
    COUNT(movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) prod_comp_rank
FROM
	multilingual_movie
WHERE 
	production_company IS NOT NULL
GROUP BY 
	production_company
)
SELECT
	production_company,
    movie_count,
    prod_comp_rank
FROM
	top_prod_company
WHERE
	prod_comp_rank <= 2;




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH superhit_drama_movie AS
(
SELECT	
	m.id AS movie_id,
    n.name AS actress_name,
    r.total_votes AS total_votes,
    r.avg_rating AS avg_rating
FROM
	movie AS m
    INNER JOIN
		role_mapping AS rm
        ON rm.movie_id = m.id
        INNER JOIN 	
			names AS n
            ON n.id = rm.name_id
	INNER JOIN 
		ratings AS r
        ON r.movie_id = m.id
	INNER JOIN 
		genre AS g
        ON g.movie_id = m.id
WHERE 
	rm.category = "actress"
    AND g.genre = "Drama"
    AND r.avg_rating > 8
),
actress_stats AS
(
SELECT
	actress_name,
    COUNT(movie_id) AS movie_count,
    SUM(total_votes) AS total_votes,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating
FROM
	superhit_drama_movie
GROUP BY
	actress_name
),
ranked_actress AS
(
	SELECT
		actress_name,
        total_votes,
        movie_count,
        actress_avg_rating,
        RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC, actress_name) AS actress_rank
	FROM
		actress_stats
)
SELECT 
	actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM 
	ranked_actress
WHERE 
	actress_rank <= 3;
        
    

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_movies AS (
    SELECT
        n.id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.date_published AS release_date,
        r.avg_rating AS avg_rating,
        r.total_votes AS total_votes,
        m.duration AS movie_duration
    FROM
		movie AS m
	INNER JOIN
		director_mapping AS dm
        ON dm.movie_id = m.id
        INNER JOIN 
			names AS n
            ON n.id = dm.name_id
	INNER JOIN 
		ratings AS r
        ON r.movie_id = m.id
),
movie_interval AS
(
SELECT
	director_id,
    director_name,
    movie_id,
    DATEDIFF(LEAD(release_date) OVER(PARTITION BY director_id ORDER BY release_date), release_date) AS inter_movie_days,
    avg_rating,
    total_votes,
    movie_duration
FROM
	director_movies
),
director_stats AS
(
SELECT
	director_id,
    director_name,
    COUNT(movie_id) AS number_of_movies,
    AVG(inter_movie_days) AS avg_inter_movie_days,
    AVG(avg_rating) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(movie_duration) AS total_duration
FROM
	movie_interval
GROUP BY
    director_id, director_name
)
SELECT 	
    director_id,
    director_name,
    number_of_movies,
    ROUND(avg_inter_movie_days, 0) AS avg_inter_movie_days,
    ROUND(avg_rating, 2) AS avg_rating,
    total_votes,
    ROUND(min_rating, 2) AS min_rating,
    ROUND(max_rating, 2) AS max_rating,
    total_duration
FROM
    director_stats
ORDER BY
    number_of_movies DESC
LIMIT 9;






