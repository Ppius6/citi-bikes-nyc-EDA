-- Exploring cities
SELECT *
FROM cities;

-- Exploring countries
SELECT *
FROM countries;

-- Joining cities on the left and countries on the right
SELECT *
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

-- Using ALIASES
SELECT 
    cities.name AS city, 
    countries.name AS country, 
    region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;  

-- Joining countries on the left and economies on the right
SELECT
    c.code AS country_code,
    name,
    year,
    inflation_rate
FROM countries as c
INNER JOIN economies as e
ON c.code = e.code;

-- Joining with USING
SELECT
    c.name AS country,
    l.name AS language,
    official
FROM countries AS c
INNER JOIN languages AS l
USING (code);

-- Joining multiple tables
SELECT
    c.name AS country,
    e.year,
    fertility_rate,
    unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
    AND p.year = e.year;

-- LEFT JOIN vs. INNER JOIN
SELECT
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM cities AS c1
INNER JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;

SELECT
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM cities AS c1
LEFT JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;

-- Adding WHERE clause
SELECT
    name,
    region,
    gdp_percapita
FROM countries AS c
LEFT JOIN economies AS e
ON c.code = e.code
WHERE year = 2010;

-- RIGHT JOIN
SELECT 
    countries.name AS country,
    languages.name AS language,
    percent
FROM languages
RIGHT JOIN countries
USING (code);

-- LEFT JOIN alternative
SELECT 
    countries.name AS country,
    languages.name AS language,
    percent
FROM countries
LEFT JOIN languages
USING (code);

-- FULL JOIN
-- FULL JOINS combine the results of a LEFT JOIN and a RIGHT JOIN.
SELECT
    p1.country AS country,
    prime_minister,
    president
FROM prime_ministers AS p1
FULL JOIN presidents AS p2
ON p1.country = p2.country
LIMIT 10;

-- FULL JOIN (2)
SELECT 
    name AS country,
    code,
    region,
    basic_unit
FROM countries
FULL JOIN currencies
USING (code)
WHERE region = 'North America' OR name IS NULL
ORDER BY region;

SELECT 
    name AS country,
    code,
    region,
    basic_unit
FROM countries
LEFT JOIN currencies
USING (code)
WHERE region = 'North America' 
    OR name IS NULL
ORDER BY region;

SELECT 
    name AS country,
    code,
    region,
    basic_unit
FROM countries
INNER JOIN currencies
USING (code)
WHERE region = 'North America' OR name IS NULL
ORDER BY region;

-- Finding languages and currencies
SELECT
    c1.name AS country,
    region,
    l.name AS language,
    basic_unit,
    frac_unit
FROM countries AS c1
FULL JOIN languages AS l
USING (code)
FULL JOIN currencies AS c2
USING (code)
WHERE region LIKE 'M%esia';

-- CROSS JOINS
-- What are the languages spoken in Pakistan and India?
-- What languages could have been spoken in the two countries in history?
SELECT 
    c.name AS country,
    l.name AS language
FROM countries AS c
INNER JOIN languages AS l
ON c.code = l.code
WHERE c.code IN ('IND', 'PAK')
    AND l.code IN ('IND', 'PAK');

-- Finding names of five countries and their respective regions with the lowest life expectancy in 2010.
SELECT
    c.name AS country,
    region,
    life_expectancy AS life_exp
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
WHERE year = 2010
ORDER BY life_exp
LIMIT 5;

-- SELF JOIN
SELECT
    p1.country_code,
    p1.size AS size2010,
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
WHERE p1.year = 2010
    AND p2.year = 2015;

-- UNION - Returns all records from both tables
-- UNION ALL - Returns all records from both tables, and it duplicates records if they exist in both tables.

-- UNION
SELECT 
    monarch AS leader, 
    country
FROM monarchs
UNION
SELECT
    prime_minister, country
FROM prime_ministers
ORDER BY country, leader
LIMIT 10;

-- UNION ALL
SELECT 
    monarch AS leader, 
    country
FROM monarchs
UNION ALL
SELECT
    prime_minister, country
FROM prime_ministers
ORDER BY country, leader
LIMIT 10;

-- Comparing global economies
SELECT *
FROM economies2015
UNION
SELECT *
FROM economies2019
ORDER BY code, year;

SELECT 
    code,
    year 
FROM economies
UNION ALL
SELECT 
    country_code,
    year
FROM populations

-- INTERSECT
SELECT
    name
FROM cities
INTERSECT
SELECT
    name
FROM countries;

-- EXCEPT
SELECT
    name
FROM cities
EXCEPT
SELECT
    name
FROM countries;

-- Subqueries
-- Subqueries are queries nested within another query.
-- Subqueries can be used in SELECT, FROM, WHERE, and JOIN clauses.
-- Subqueries can return individual values or a list of records.

-- Subquery in SELECT
SELECT
    name,
    (SELECT COUNT(*)
     FROM cities
     WHERE countries.code = cities.country_code) AS cities_num
FROM countries;

-- Subquery in WHERE
SELECT president, country, continent
FROM presidents
WHERE continent IN (
    SELECT continent
    FROM countries
    WHERE indep_year < 1800
);

-- Antijoin
-- Antijoin returns rows from the first table that do not have a match in the second table.
SELECT
    country,
    president 
FROM presidents
WHERE continent LIKE '%America'
    AND country NOT IN (
        SELECT country
        FROM states
    WHERE indep_year < 1800
    );

SELECT 
    DISTINCT name, 
    COUNT(name) AS count
FROM languages
WHERE code IN (
    SELECT code
    FROM countries
    WHERE region = 'Middle East')
GROUP BY name
ORDER BY name;