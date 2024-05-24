/** Analyzing Students' Mental Health **/

/** Return a table with nine rows and five columns. **/
SELECT *
FROM students
LIMIT 9;

/** The five columns should be aliased as: stay, count_int, average_phq, average_scs, and average_as, in that order. **/
SELECT stay,
    COUNT(*) AS count_int,
    ROUND(AVG(todep), 2) AS average_phq,
    ROUND(AVG(toscs), 2) AS average_scs,
    ROUND(AVG(toas), 2) AS average_as
FROM students
WHERE inter_dom = 'Inter'
GROUP BY stay
ORDER BY stay DESC;
