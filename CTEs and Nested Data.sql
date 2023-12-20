

SELECT customer_id, user_id, ARRAY_LENGTH(logins) AS n_logins 
FROM adv-sql-class-resources.saas_user_db.users



--QUERY


WITH bike_int AS (
  SELECT bikeid, COUNT(trip_id) AS trip_count, COUNT(DISTINCT DATE(start_time)) AS day_count 
  FROM bigquery-public-data.austin_bikeshare.bikeshare_trips
  GROUP BY bikeid
),
bike_agg AS (
  SELECT bikeid, trip_count/day_count AS avg_trips 
  FROM bike_int
)
SELECT * FROM bike_agg



--QUERY

WITH github_commits AS (
  SELECT DATE(timestamp_seconds(committer.date.seconds)) AS dt, 'github_commits' AS platform_name, COUNT(1) AS n
  FROM bigquery-public-data.github_repos.commits
  WHERE DATE(timestamp_seconds(committer.date.seconds)) >= '2017-01-01' AND DATE(timestamp_seconds(committer.date.seconds)) <= '2017-04-01'
  GROUP BY DATE(timestamp_seconds(committer.date.seconds))
),
  saas_db AS (
    SELECT ll.dt AS dt, 'saas_db' AS platform_name, COUNT(1) AS n, 
    FROM adv-sql-class-resources.saas_user_db.users, unnest(logins) as ll
    WHERE ll.dt >= '2021-01-01' AND ll.dt <= '2021-04-01'
    GROUP BY ll.dt
  )

SELECT * FROM github_commits
UNION ALL
SELECT * FROM saas_db


