

with
  get_trips as (
  select
    date(start_date) as dt,
    start_station_id,
    count(*) as num_trips
  from `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips`
  group by
    start_station_id,
    dt),

  get_rolling_7 as (
  select
    start_station_id,
    dt,
    num_trips,
    avg(num_trips) over (partition by start_station_id order by dt rows between 7 preceding and 1 preceding) as trips_07
  from
    get_trips
  where
    start_station_id in (70,50,67,60)),
  
  get_rolling_14 as (
  select
    start_station_id,
    dt,
    num_trips,
    avg(num_trips) over (partition by start_station_id order by dt rows between 14 preceding and 1 preceding) as trips_14
  FROM
    get_trips
  WHERE
    start_station_id in (70,50,67,60)),
  
  get_rolling_28 as (
  select
    start_station_id,
    dt,
    num_trips,
    avg(num_trips) over (partition by start_station_id order by dt rows between 28 preceding and 1 preceding) as trips_28
  FROM
    get_trips
  WHERE
    start_station_id in (70,50,67,60))

select
  r7.start_station_id,
  r7.dt,
  r7.num_trips,
  r7.trips_07,
  r14.trips_14,
  r28.trips_28
FROM
  get_rolling_7 r7
JOIN
  get_rolling_14 r14
ON
  r7.start_station_id = r14.start_station_id
  AND r7.dt = r14.dt
JOIN
  get_rolling_28 r28
ON
  r7.start_station_id = r28.start_station_id
  AND r7.dt = r28.dt
ORDER BY
  r7.start_station_id,
  r7.dt;


--QUERY

 with ranks as (
  select
    *,
    rank () over (partition by bike_number, date(start_date) order by date(start_date)) as start_rank
  from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
  order by trip_id, start_date

)

select * from ranks
where start_rank = 1 and date(start_date) >= '2018-03-01' and date(start_date) <= '2018-03-31'



--QUERY



with ranks as (
  select
    *,
    rank () over (partition by bike_number, date(start_date) order by date(start_date) desc) as start_rank
  from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
  order by bike_number, start_date

)

select * from ranks
where start_rank = 1 and date(start_date) >= '2018-03-01' and date(start_date) <= '2018-03-31'



--QUERY



with t1 as (
  select
    date(start_date) as dt,
    count(*) as num_trips,
  from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
  group by 1
),

t2 as (
  select
    *,
    lag(num_trips, 30) over (order by dt) as last30
  from t1
)

select
  *,
  (last30 - num_trips) / num_trips as pct_change_30
from t2



--QUERY


with t1 as (
  select 
    start_station_id,
    count(*) as num_trips,
    sum(count(*)) over (partition by 1) as total_trips
  from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
  group by start_station_id
)

select 
  *,
 (num_trips/total_trips) as pct_of_total
from t1



--QUERY


with t1 as (
  select
    bike_number,
    date(start_date) as start_dt,
    date(date_trunc(start_date, week)) as start_week,
    count(*) over (partition by bike_number, date(date_trunc(start_date, week)) order by date(date_trunc(start_date, week))) as num_trips,
    duration_sec / 60 as duration_min
  from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
  order by bike_number, date(date_trunc(start_date, week))
),

t2 as (
  select
    *,
    sum(duration_min) over (partition by bike_number, start_dt) as total_minutes
  from t1
)

select 
  bike_number,
  start_dt,
  start_week,
  num_trips,
  total_minutes,
  sum(total_minutes) over (partition by bike_number, start_week order by start_dt rows unbounded preceding) as cumulative_total_minutes
from t2
where start_dt >= '2018-03-01' and start_dt <= '2018-03-31'
order by bike_number, start_dt, start_week


