# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix logo](https://github.com/Mohit1952/Netflix_Sql_Project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset
The data for this project is sourced from the Kaggle dataset:
- **Dataset Link:** [Movie Dataset](https://github.com/Mohit1952/Netflix_Sql_Project/blob/main/netflix_titles.csv)

## Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions
## 1. Count the Number of Movies vs TV Shows
```sql
select 
	type, 
	count(*) 
from  Netflix 
group by 1
```
Objective: Determine the distribution of content types on Netflix.

## 2. Find the Most Common Rating for Movies and TV Shows
```sql
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
```
Objective: Identify the most frequently occurring rating for each type of content.

## 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
select
	*
from Netflix 
	where
	release_year = 2020
```
Objective: Retrieve all movies released in a specific year.

# 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
select 
	--country, 
	unnest(string_to_array(country, ',')) as new_country,
	count(*) as total_content
from Netflix 
group by 1
order by 2 desc
limit 5
```
Objective: Identify the top 5 countries with the highest number of content items.

# 5. Identify the Longest Movie
```sql
select 
	* 
from Netflix
where 	
	type = 'Movie'
	and
	duration = (select max(duration) from Netflix)
```
Objective: Find the movie with the longest duration.

# 6. Find Content Added in the Last 5 Years
```sql
select
	*
from Netflix
where 
	To_date(date_added, 'Month DD, YYYY') >= current_date - Interval '5 Years'
```
Objective: Retrieve content added to Netflix in the last 5 years.

# 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
select 
	* 
from Netflix
	where director ilike '%Rajiv Chilaka%'
```
Objective: List all content directed by 'Rajiv Chilaka'.

# 8. List All TV Shows with More Than 5 Seasons
```sql
select 
	* from(
select 
	*,
	cast(split_part(duration, ' ', 1) as int) as season
from Netflix
	where type = 'TV Show')x
	where season > 5
```
Objective: Identify TV shows with more than 5 seasons.

# 9. Count the Number of Content Items in Each Genre
```sql
select 
	unnest(string_to_array(listed_in,',')) as genre,
	count(*)
from Netflix
group by 1
```
Objective: Count the number of content items in each genre

# 10. Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!
```sql
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
select
	year,
	Total_content,
	round(Total_content/(select sum(Total_content) from cte2)*100,2) as Averge
from cte2 
```
Objective: Calculate and rank years by the average number of content releases by India.

# 11. List All Movies that are Documentaries
```sql
select 
	*
from Netflix
	where 
		listed_in like '%Documentaries%' 
		and 
		type = 'Movie'
```
Objective: Retrieve all movies classified as documentaries.

# 12.  Find All Content Without a Director
```sql
select
	*
from Netflix 
	where Director is null
```
Objective: List content that does not have a director.

# 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
select
	*
from Netflix
	where 
		casts ilike '%Salman Khan%'
		and
		release_year >= extract(year from Current_date) - 10
```
Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.

# 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India.
```sql
select
	unnest(string_to_array(casts, ',')) as Actors,
	count(*)
from Netflix
where country ilike '%India%'
group by 1
order by 2 desc
limit 10
```
Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

