--Netflix Project 
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150), 
	director VARCHAR(208),
	casts VARCHAR(1000),	
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,	
	rating VARCHAR(10),	
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT 
	COUNT(*) AS total_content
FROM netflix;	

SELECT
	DISTINCT type
FROM netflix;	

SELECT * FROM netflix;



-- 15 Business Problems and solutions

--1. Count the number of Movies vs TV Shows

SELECT 
	type,
	count(*) as total_content
from netflix
group by type	


--2. Find the most common rating for movies and TV shows

SELECT 
	type,
    rating
FROM
(
SELECT 
	type,
	rating,
	count(*),
	RANK() OVER(PARTITION by type order by count(*)DESC) as ranking
FROM netflix
Group by 1,2
) AS t1
WHERE 
ranking = 1

--3. List all movies released in a specific year (e.g., 2020)

select	*
from netflix
WHERE 
	type = 'Movie' 
	AND
	release_year = 2020

--4. Find the top 5 countries with the most content on Netflix

SELECT
	unnest(string_to_array(country , ',')) as new_country,
	count(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


--5. Identify the longest movie

SELECT title, duration, type
FROM netflix
WHERE type = 'Movie'
  AND duration ~ '^[0-9]+ min$'
ORDER BY CAST(split_part(duration, ' ', 1) AS INTEGER) DESC
LIMIT 5;
	
--6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE
	TO_DATE(date_added,'month DD,YYYY')>= current_date - interval '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT
*
FROM netflix
WHERE 
	director ilike '%Rajiv Chilaka%'


--8. List all TV shows with more than 5 seasons

SELECT * FROM netflix
WHERE 
	type = 'TV Show'
	and
	SPLIT_PART(duration, ' ' ,1)::numeric > 5

--9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
FROM netflix
group by 1


--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY'))AS Year,
	COUNT(*) as yearly_content ,
	ROUND(
	count(*)::numeric/(select count (*) from netflix where country = 'India')::numeric * 100
	,2)AS avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY Year

--11. List all movies that are documentaries

SELECT 
	*	 
FROM netflix
where 
	type = 'Movie'
	and
	listed_in ilike '%Documentaries%'

--12. Find all content without a director

SELECT *
FROM netflix
WHERE
	director is NULL

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT *
FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	and
	release_year > EXTRACT(YEAR FROM current_date) -10

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
unnest(STRING_TO_ARRAY(casts,',')) as actors,
count(*) as total_contents
FROM netflix
WHERE 
	COUNTRY ILIKE '%india%'
group by 1
ORDER BY 2 DESC
LIMIT 10

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

with new_table
AS
(
SELECT 
*,
	CASE
	WHEN 
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_Content'
		ELSE 'Good_content'
	END category
from netflix	
)
select 
	category,
	count(*) as total_content
from new_table
group by 1
 























 
























 