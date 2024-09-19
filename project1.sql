 DROP TABLE IF EXISTS netflix;
create table netflix
(
    show_id VARCHAR(6),
    type VARCHAR(10),
	title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),	
    release_year INT,	
    rating	VARCHAR(10),
    duration VARCHAR(15),	
    listed_in VARCHAR(100),
    description VARCHAR(250)
    )
    
select * from netflix;


select count(*) as total_content
from netflix;

select distinct type from netflix

 --15 Business problems

--1.count the number of Movies vs TV shows

select type,count(*) as total_content
from netflix
group by type

--2.Find the most common rating for movies and TV shows


select  type,rating from(
select 
type,rating,count(*),
rank() over(partition by type order by count(*) desc ) as ranking
from netflix
group by 1,2)
where ranking=1


--3.list all movies realised in a specific year(e.g., 2020)

--filter movies
--filter 2020

select * from netflix
where 
   type='Movie' 
   and 
   release_year=2020

--4.Find the top 5 countries with the most content on Netflix 

select unnest(string_to_array(country,',')) as new_country,
count(show_id) as content from netflix
group by 1
order by 2 DESC
LIMIT 5


--5.Identify the longest movie?

select * from netflix
where
   type='Movie'
   and
   duration=(select max(duration) from netflix)

--6.Find content added in the last 5 years

 select * from netflix
 where
 to_date(date_added,'month dd,year')>=current_date-interval '5 years'

 --7.Find all the movies/TV shows by director 'Rajiv chilaka'!

 select * from netflix
 where director ilike '%Rajiv Chilaka%'

 --8.list all TV shows with more than 5 seasons

 select * ,split_part(duration,' ',1) as season from netflix
 where 
    type='TV Show'
	and
	split_part(duration,' ',1)::numeric > 5 
	
--9.count the number of content items in each gener

select unnest(string_to_array(listed_in,',')) as gener,count(show_id) as total_content from netflix
group by 1

--10.find each year and the average number of content release in india on netflix
--returntop 5 year with highest avg content


select extract(year from to_date(date_added,'month DD,YYYY')),count(*),
(count(*)::numeric/(select count(*)::numeric from netflix where country ilike '%India%'))*100 from netflix
    where country ilike '%India%'
    group by 1
    order by 3 desc
limit 5

--11.list all movies that are documentaries

select * from netflix
    where 
	type='Movie'
    and
    listed_in ilike '%doc%'

--12.Find all content without a director

select * from netflix
where 
   director is null
	
--13.Find how many movies actor 'salman khan'appeared in last 10 years

select * from netflix
where
    casts ilike '%salman khan%'
	and
	release_year>extract(year from current_date)- 10 

--14.Find the top actors who have appeared in the highest number of movies produced in india

select unnest(string_to_array(casts,',')) as actors,count(*) from netflix
    where country ilike '%india%'
    group by 1
    order by 2 desc
limit 10

--15.categorize the content based on the presence of the keywords 'kill' and 'violence'in the 
--discription field.lable content containing these keywords as 'bad' and all other content as 'good'.
--count how many items fall into each category.

with new_table as
(
select *,
    case 
	when description ilike '% kill%'
	or
	description ilike '%violence'
	then 'bad'
	else 'good'
	end category
	from netflix)
select category,count(*) from new_table
group by 1



	
 
 

 


 












	

	