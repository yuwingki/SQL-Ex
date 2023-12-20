SELECT term, week, rank FROM bigquery-public-data.google_trends.top_terms
ORDER BY rank, term
LIMIT 1000

--QUERY

SELECT term, COUNT (*) AS n
FROM bigquery-public-data.google_trends.top_terms
WHERE (rank <= 10) AND (week >= '2022-11-01')
GROUP BY term

--QUERY

SELECT bikeid, COUNT(trip_id) AS n, AVG(duration_minutes) AS minutes
FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
GROUP BY bikeid
