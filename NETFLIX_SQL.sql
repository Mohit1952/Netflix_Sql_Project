-- Netflix Project
Create table Netflix
(
	show_id			Varchar(5),
	type			Varchar(10),
	title			Varchar(250),
	director		Varchar(550),
	casts			Varchar(1050),
	country			Varchar(550),
	date_added		Varchar(55),
	release_year	int,
	rating			Varchar(15),
	duration		Varchar(15),
	listed_in		Varchar(250),
	description		Varchar(550)
)

-- 1. Count the number of Movies vs TV Shows
select type, count(*) 
from  Netflix 
group by 1

-- 2. Find the most common rating for movies and TV shows
with cte as(
select type, rating, count(*) as rating_count 
from Netflix 
group by 1,2),
cte1 as(
select *,
dense_rank() over (partition by type order by rating_count desc) as rnk 
from cte)
select type, rating as most_frequent_rating 
from cte1 
where rnk = 1


-- 3. List all movies released in a specific year (e.g., 2020)
select * from Netflix 
where release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix
select 
	--country, 
	unnest(string_to_array(country, ',')) as new_country,
	count(*) as total_content
from Netflix 
group by 1
order by 2 desc
limit 5


-- 5. Identify the longest movie
select 
	* 
from Netflix
where 	
	type = 'Movie'
	and
	duration = (select max(duration) from Netflix)


-- 6. Find content added in the last 5 years
select
	*
from Netflix
where 
	To_date(date_added, 'Month DD, YYYY') >= current_date - Interval '5 Years'


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select 
	* 
from Netflix
	where director ilike '%Rajiv Chilaka%'


-- 8. List all TV shows with more than 5 seasons
select 
	* from(
select 
	*,
	cast(split_part(duration, ' ', 1) as int) as season
from Netflix
	where type = 'TV Show')x
	where season > 5


-- 9. Count the number of content items in each genre
select 
	unnest(string_to_array(listed_in,',')) as genre,
	count(*)
from Netflix
group by 1


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
with cte as(
select 
	*,
	unnest(string_to_array(country, ',')) as contry
from Netflix),
cte2 as(
select 
	extract(year from To_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as Total_content
from cte
	where contry = 'India'
	group by 1)
select year, Total_content, round(Total_content/(select sum(Total_content) from cte2)*100,2) as Averge from cte2 


-- 11. List all movies that are documentaries
select 
	*
from Netflix
	where listed_in like '%Documentaries%' and type = 'Movie'


-- 12. Find all content without a director
select
	*
from Netflix 
	where Director is null


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select
	*
from Netflix
	where 
		casts ilike '%Salman Khan%'
		and
		release_year >= extract(year from Current_date) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select
	unnest(string_to_array(casts, ',')) as Actors,
	count(*)
from Netflix
where country ilike '%India%'
group by 1
order by 2 desc
limit 10













