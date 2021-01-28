-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Part 1:

/*Provide SQL statements that completely fulfill the queries listed below. 
All SQL statements must use explicit join syntax.  All SQL statements must be 
well formatted (see below) and consistently formatted throughout the assignment.  
Make sure to include which query you are answering.
    a. Answer eight queries from Group 1.
    b. Answer eight queries from Group 2.
    c. Answer three queries from Group 3.*/
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Group 1: SQL Query --
-------------------------------------------------------------------------------

/*1.	Display each beer’s name and style name. A beer should be 
displayed regardless of whether a style name exists or not.*/
  SELECT
    beer_name,style_name
FROM
    beerdb.beers be
    RIGHT OUTER JOIN beerdb.styles st 
        ON be.style_id = st.style_id;

/* 2.	Display each beer’s name, category name, color example, 
and style name, for all beers that have values for category name, 
color example, and style name.*/
SELECT 
    beer_name,category_name,examples,style_name
FROM
    beerdb.beers be
    INNER JOIN beerdb.categories ca ON be.cat_id=ca.category_id
    INNER JOIN beerdb.colors co ON  be.srm_raw = co.LOVIBOND_SRM
    INNER JOIN beerdb.styles st ON  be.style_id=st.style_id
WHERE (category_name IS NOT NULL) AND 
      (examples IS NOT NULL) AND
      (style_name IS NOT NULL);

/*3.	Display each brewer’s name along with the minimum, maximum, 
and average alcohol by volume(ABV) of its beers. Exclude any beers 
with an ABV of zero. Show the brewers with the highest average ABV 
first.*/
SELECT
    name,
    COUNT(name) AS brewer_qty,
    round(AVG(abv), 1) AS avg_abv,
    MIN(abv) AS min_abv,
    MAX(abv) AS max_abv
FROM
    beerdb.beers be
    INNER JOIN beerdb.breweries br 
ON be.brewery_id = br.brewery_id
WHERE  abv > 0
GROUP BY name
ORDER BY AVG(abv) DESC;

/*4.	Find which cities would be good for hosting microbrewery tours. 
A city must have at least 10 breweries to be considered. Display the city's 
name as well as how many breweries are in the city. Show cities with the 
most breweries first.*/
SELECT 
    city, COUNT(name) AS nb_breweries
FROM 
    beerdb.breweries br 
    INNER JOIN beerdb.beers be ON br.brewery_id = be.brewery_id
GROUP BY city
HAVING COUNT(name) >= 10
ORDER BY COUNT(name) DESC;

/*5.	Display all beer names that (1) belong to a category with a name 
containing “Lager” somewhere in the name and (2) have an alcohol by volume 
(ABV) of eight or greater. Show the beer names in alphabetical order.*/
SELECT 
    beer_name,category_name,round(AVG(abv), 1) AS avg_abv
FROM 
    beerdb.beers be
    INNER JOIN beerdb.categories br  ON be.cat_id = br.category_id
WHERE br.category_name LIKE '%Lager%' AND abv >=8
GROUP BY beer_name,category_name
ORDER BY beer_name  ASC;

/*6.	Display the name of all movies that have an IMDB rating of at least 
8.0, with more than 100,000IMDB votes, and were released from 2007 to 2013. 
Show the movies with the highest IMDB ratings first.*/
SELECT 
    film_title, imdb_votes, relmdb.movies.film_year
FROM 
    relmdb.movies
WHERE
    imdb_rating>=8.0 AND
    imdb_votes > 10000 AND
    EXTRACT(YEAR FROM RELEASE_DATE) between 2007 AND 2013
ORDER BY imdb_rating DESC;

/*7.	Display each movie’s title and total gross, where total gross is 
USA gross and worldwide gross combined. Exclude any movies that do not have 
values for either USA gross or worldwide gross. Show the highest grossing 
movies first.*/
SELECT 
    film_title,(usa_gross + worldwide_gross) AS total_gross
FROM 
    relmdb.movies
WHERE
    usa_gross> 0 AND
    worldwide_gross >0
ORDER BY total_gross DESC;

/*8.	Display the titles of any movies where Tom Hanks or Tim Allen were
cast members. Each movie title should be shown only once.*/
SELECT DISTINCT 
    film_title
FROM 
    relmdb.movies mo
    INNER JOIN casts ca ON mo.film_id = ca.film_id
WHERE 
    ca.cast_member IN('Tom Hanks','Tim Allen');
-------------------------------------------------------------------------------
-- Group 2: SQL Query --
-------------------------------------------------------------------------------
/*10.	Label the strength of a beer based on its ABV. For each beer display 
the beer's name, ABV, and a textual label describing the strength of the beer. 
The label should be " Very High " for an ABV more than 10, "High" for an ABV 
of 6 to 10, "Average" for an ABV of 3 to 6, and "Low" for an ABV less than 3. 
Show the records by beer name.*/
SELECT 
    beer_name,
    CASE
        WHEN abv < 3 THEN 'Low'
        WHEN abv BETWEEN 3 AND 6 THEN 'Average'
        WHEN abv BETWEEN 6 AND 10 THEN 'High'
        WHEN abv > 10 THEN 'Very High'
        ELSE 'Error'
    END AS abv
FROM 
    beers
WHERE abv IS NOT NULL
ORDER BY beer_name;

/*11.	Find all breweries that specialize in a particular beer style. A 
brewer is considered specialized if they produce at least 10 beers from the 
same style. Show the brewer's name, style name, and how many beers the brewer 
makes of that style. Display the records by style name first and then by 
breweries with the most beers within that style.*/
SELECT 
    br.Name, st.style_name, COUNT(be.brewery_id)
FROM 
    beerdb.beers be 
    JOIN beerdb.breweries br ON be.brewery_id = br.brewery_id
    INNER JOIN beerdb.styles st ON st.style_id = be.style_id 
WHERE be.brewery_id is not null
GROUP BY br.Name, st.style_name
HAVING COUNT(be.brewery_id)>=10
ORDER BY st.style_name DESC;

/*12.	Display each brewer’s name and how many beers they have associated 
with their brewery. Only include brewers that are located outside the United 
States and have more than the average number of beers from all breweries 
(excluding itself when calculating the average). Show the brewers with the 
most beers first. If there is a tie in number of beers, then sort by the 
brewers’ names.*/
SELECT 
    name, COUNT(beer_name) as beer_nb
FROM
    beerdb.breweries
    INNER JOIN beerdb.beers USING(brewery_id)
WHERE country <> 'United States'
GROUP BY name
HAVING COUNT(beer_name) > (
    SELECT AVG(COUNT(*))
    FROM beerdb.beers
    GROUP BY brewery_id)
ORDER BY 
    COUNT(beer_name) DESC,
    name ASC;

/*13.	For each movie display its movie title, year, and how many cast 
members were a part of the movie. Exclude movies with five or fewer cast 
members. Display movies with the most cast members first, followed by movie 
year and title.*/
SELECT 
    film_title,film_year,COUNT(cast_member)AS nb_members
FROM relmdb.movies mo 
    INNER JOIN relmdb.casts ca ON mo.film_id = ca.film_id
HAVING COUNT(cast_member)>5
GROUP BY film_title,film_year
ORDER BY 
    nb_members DESC,
    mo.film_year ASC,
    mo.film_title ASC;

/*14.	For each genre display the total number of films, average fan rating, 
and average USA gross. A genre should only be shown if it has at least five 
films. Any film without a USA gross should be excluded. A film should be 
included regardless of whether any fans have rated the film. Show the results 
by genre. (Hint: use the TRIM function to only show a single record from the 
same genre.)*/

/*15.	Find the average budget for all films from a director with at least
one movie in the top 25 IMDB ranked films. Show the director with the highest 
average budget first.*/
SELECT 
    director,
    ROUND(AVG(budget)) AS AVG_Budget
FROM 
    relmdb.movies
    INNER JOIN relmdb.directors USING(film_id)
WHERE director IN(
    SELECT DISTINCT director
    FROM relmdb.movies
        INNER JOIN relmdb.directors USING(film_id)
    WHERE imdb_rank <= 25)
GROUP BY director 
ORDER BY AVG(budget) DESC;

/*16.	Find all duplicate fans. A fan is considered duplicate if they have 
the same first name, last name, city, state, zip, and birth date.*/
SELECT 
    fname,lname,city,state,birth_year, birth_month, birth_day,count(*)
FROM 
    Fans fa 
    INNER JOIN fan_ratings fr ON fa.fan_id = fr.fan_id
    INNER JOIN movies mo ON fr.film_id = mo.film_id
GROUP BY fname,lname,city,state,birth_year, birth_month, birth_day;

/*17.   We believe there may be erroneous data in the movie database.  
To help uncover unusual records for manual review, write a query that finds 
all actors/actresses with a career spanning 60 years or more.  Display each 
actor's name, how many films they worked on, the year of the earliest and 
latest film they worked on, and the number of years the actor was active in 
the film industry (assume all years between the first and last film were 
active years).  Display actors with the longest career first.*/


/*18.   The movies database has two tables that contain data on fans 
(FANS_OLD and FANS). Due to a bug in our application, fans may have been 
entered into the old fans table rather then the new table. Find all fans 
that exist in the old fans table but not the new table.  Use only the first 
and last name when comparing fans between the two tables.*/


-------------------------------------------------------------------------------
-- Group 3: SQL Query 
-------------------------------------------------------------------------------

/*19.	Assign breweries to groups based on the number of beers they brew.  
Display the brewery ID, name, number of beers they brew, and group number for 
each brewery.  The group number should range from 1 to 4, with group 1 
representing the top 25% of breweries (in terms of number of beers), 
group 2 representing the next 25% of breweries, group 3 the next 25%, and 
group 4 for the last 25%.  Breweries with the most beers should be shown first.  
In the case of a tie, show breweries by brewery ID (lowest to highest).*/
  
SELECT   
    br.brewery_id, 
    br.name,  
    COUNT(DISTINCT(be.beer_id)) as "beer_count",  
    NTILE(4) OVER( 
        ORDER BY COUNT(DISTINCT(be.beer_id)) DESC) group_number  
FROM 
    breweries br  
        JOIN beers be ON br.brewery_id = be.brewery_id  
GROUP BY
    br.brewery_id, 
    br.name 
ORDER BY 
    COUNT(DISTINCT(be.beer_id)) DESC, 
    brewery_id ASC;
    
-- Wadnerson script
SELECT 
    br.brewery_id,name,COUNT(beer_name), 
    NTILE(4) OVER (ORDER BY name DESC) AS group_number 
FROM beerdb.beers  be  
    INNER JOIN beerdb.breweries br ON be.brewery_id = br.brewery_id 
WHERE br.brewery_id IS NOT NULL 
GROUP BY  br.brewery_id,name 
ORDER BY br.brewery_id;


/*20.    Rank beers in descending order by their alcohol by volume (ABV) 
content.  Only consider beers with an ABV greater than zero. Display the rank 
number, beer name, and ABV for all beers ranked 1-10. Do not leave any gaps 
in the ranking sequence when there are ties (e.g., 1, 2, 2, 2, 3, 4, 4, 5). 
(Hint: derived tables may help with this query.)*/
SELECT *
FROM(SELECT
        beer_name, 
        abv,
        DENSE_RANK() OVER(ORDER BY abv DESC) AS rank -- RANK() OVER(ORDER BY abv DESC) would create a skip in rank
    FROM
        beers)
WHERE 
    abv > 0 AND
    rank <= 10;
    
/*21.   Display the film title, film year and worldwide gross for all movies 
directed by Christopher Nolan that have a worldwide gross greater than zero.  
In addition, each row should contain the cumulative worldwide gross (current 
row's worldwide gross plus the sum of all previous rows' worldwide gross).  
Records should be sorted in ascending order by film year.*/
SELECT 
    film_title,
    film_year, 
    worldwide_gross,
    sum(worldwide_gross) over (order by film_year asc) AS cumulative_worldwide_gross
FROM relmdb.movies 
    INNER JOIN directors using(film_id)
WHERE 
    director = 'Christopher Nolan' AND
    worldwide_gross >0 
ORDER BY film_year ASC;

/*22.   Display the following information using a single SQL statement: 
(a) total budget and USA gross for each combination of genre and MPAA rating; 
(b) total budget and USA gross for each genre from (a); and (c) Total budget 
and USA gross for all genres and MPAA ratings shown in (a). Only movies with 
non null values of budget and USA gross should be included.  Sort the records 
by genre and then MPAA rating.  (Hint: use the TRIM function to only show a 
single record from the same genre.)*/

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Part 2: 

/*Create three new interesting queries.  Provide both a written statement 
describing what information should be selected and a SQL statement that 
implements the written statement.  Your queries can use both databases or 
only a single database.  Use this as an opportunity to explore more advanced 
SQL.

Note: The deliverable items for this project should be combined into a 
single PDF document.*/
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

/*1.  Write a SQL query to find the name of the director who directed a movie 
that casted a role for Saving Private Ryan*/

SELECT 
    director
FROM 
    relmdb.directors d  
    INNER JOIN relmdb.movies m ON d.film_id = m.film_id 
WHERE m.film_id IN ( 
    SELECT
        film_id 
    FROM relmdb.movies 
    WHERE film_title = 'Saving Private Ryan' 
    ); 
 

/*2.  Write a query in SQL to find the highest-rated movie, and report its 
title, year, rating, and shooting country*/

SELECT 
    m.film_title , 
    m.film_year , 
    l.country , 
    max(m.IMDB_rating) AS highest_rated 
FROM 
    relmdb.movies m    
    INNER JOIN locales l ON m.film_id =l.film_id 
GROUP BY m.film_title , m.film_year , l.country 
ORDER BY max(m.IMDB_rating) DESC
FETCH FIRST 1 row only;

/*3.  Write a query in SQL to list all the movies with title, year, date of 
release, movie duration, name of the director which released before 1st 
january 1989, with budget over 10 million dollars, and sort the result set 
according to release date from highest date to lowest*/

SELECT 
    m.film_title ,  
    m.film_year ,  
    m.budget ,  
    m.release_date ,  
    d.director 
FROM 
    relmdb.movies m  
    INNER JOIN directors d ON m.film_id = d.film_id 
WHERE 
    Budget > 10000000 AND 
    release_date <'01-JAN-89'  
ORDER BY 
    release_date DESC, 
    film_title; 