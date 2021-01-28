SELECT
    TRIM(genre) AS genre,
    SUM(usa_gross) AS sum_usa_gross
FROM
    movies m
    INNER JOIN genres g ON m.film_id = g.film_id
WHERE usa_gross IS NOT NULL
GROUP BY
    ROLLUP(TRIM(genre))
ORDER BY genre;   

SELECT
    genre,
    film_year,
    SUM(usa_gross) AS sum_usa_gross
FROM
    movies m
    INNER JOIN genres g 
        ON m.film_id = g.film_id
WHERE usa_gross IS NOT NULL
GROUP BY
    ROLLUP(genre, film_year)
ORDER BY genre, film_year;   

