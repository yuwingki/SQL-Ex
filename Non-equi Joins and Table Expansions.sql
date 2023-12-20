with months as ( 
  select distinct date_trunc(report_date, month) as report_month
  from `bigquery-public-data.austin_waste.waste_and_diversion`
),

load_t as (
  SELECT 'LITTER' AS load_type
  UNION ALL
  SELECT 'MULCH' AS load_type
  UNION ALL
  SELECT 'BRUSH' AS load_type
  UNION ALL
  SELECT 'SWEEPING' AS load_type
  UNION ALL
  SELECT 'GARBAGE COLLECTIONS' AS load_type
)

select 
  months.report_month,
  load_t.load_type,
  coalesce(count(`bigquery-public-data.austin_waste.waste_and_diversion`.load_type), 0) as n
from load_t
cross join months
left join `bigquery-public-data.austin_waste.waste_and_diversion`
on date_trunc(`bigquery-public-data.austin_waste.waste_and_diversion`.report_date, month) = months.report_month
and `bigquery-public-data.austin_waste.waste_and_diversion`.load_type = load_t.load_type
group by load_t.load_type, months.report_month


--QUERY


with months as ( 
  select distinct date_trunc(report_date, month) as report_month
  from `bigquery-public-data.austin_waste.waste_and_diversion`
),

load_t as (
  SELECT 'LITTER' AS load_type
  UNION ALL
  SELECT 'MULCH' AS load_type
  UNION ALL
  SELECT 'BRUSH' AS load_type
  UNION ALL
  SELECT 'SWEEPING' AS load_type
  UNION ALL
  SELECT 'GARBAGE COLLECTIONS' AS load_type
),

frame_w as (
  select 
    months.report_month,
    load_t.load_type,
  from load_t
  cross join months
  left join `bigquery-public-data.austin_waste.waste_and_diversion`
  on date_trunc(`bigquery-public-data.austin_waste.waste_and_diversion`.report_date, month) = months.report_month
  and `bigquery-public-data.austin_waste.waste_and_diversion`.load_type = load_t.load_type

)

select * from frame_w
pivot(
  count(*)
  for load_type in ('LITTER','MULCH','BRUSH','SWEEPING','GARBAGE COLLECTIONS')
)


--QUERY


with months as ( 
  select distinct date_trunc(report_date, month) as report_month
  from `bigquery-public-data.austin_waste.waste_and_diversion`
),

load_t as (
  SELECT 'LITTER' AS load_type
  UNION ALL
  SELECT 'MULCH' AS load_type
  UNION ALL
  SELECT 'BRUSH' AS load_type
  UNION ALL
  SELECT 'SWEEPING' AS load_type
  UNION ALL
  SELECT 'GARBAGE COLLECTIONS' AS load_type
),

frame_w as (
  select 
    months.report_month,
    load_t.load_type,
  from load_t
  cross join months
  left join `bigquery-public-data.austin_waste.waste_and_diversion`
  on date_trunc(`bigquery-public-data.austin_waste.waste_and_diversion`.report_date, month) = months.report_month
  and `bigquery-public-data.austin_waste.waste_and_diversion`.load_type = load_t.load_type

),

my_pivot as (
select * from frame_w
pivot(
  count(*)
  for load_type in ('LITTER','MULCH','BRUSH','SWEEPING','GARBAGE COLLECTIONS')
))

select * from my_pivot
unpivot(
  n for load_type in (`LITTER`,`MULCH`,`BRUSH`,`SWEEPING`,`GARBAGE COLLECTIONS`)
)


--QUERY


with all_possible_dates as (
  select * from unnest(generate_date_array('2020-01-01','2022-01-01', interval 1 day)) as dt
), 

get_start_ends as (
  select 
    customer_id, 
    user_id, 
    min(created_date) as start_date, 
    coalesce(min(deleted_date), date('2022-01-01')) as end_date
  from `adv-sql-class-resources.saas_user_db.users`
  group by customer_id, user_id
), 

user_expand as (
  select
    t2.dt,
    t1.customer_id,
    t1.user_id
  from get_start_ends t1
  inner join all_possible_dates t2
    on t2.dt >= t1. start_date and t2.dt <= t1.end_date
  order by t1.customer_id, t1.user_id
)

select 
dt,
count(*) as n
from user_expand
group by dt


--QUERY

with ll_dates as (
  select
    min(ll.dt) as min_dt,
    max(ll.dt) as max_dt
  from `adv-sql-class-resources.saas_user_db.users`, unnest(logins) as ll
),

all_possible_dates as (
  select
    dt
  from
    ll_dates
  cross join
    unnest(generate_date_array(date_trunc(min_dt, year), max_dt, interval 1 day)) as dt
),

get_logins as (
  select
    ll.dt,
    customer_id,
    user_id,
    ll.minutes
  from `adv-sql-class-resources.saas_user_db.users`, unnest(logins) as ll
),

get_start_ends as (
  select
    t1.dt,
    t2.customer_id,
    t2.user_id,
    t2.user_role,
  from all_possible_dates t1
  inner join `adv-sql-class-resources.saas_user_db.users` t2
    on t1.dt >= t2.created_date and t1.dt <= coalesce(t2.deleted_date,date('2022-01-01'))
),

user_expand as (
   select
    t1.dt,
    t1.customer_id,
    t1.user_id,
    t1.user_role,
    IFNULL(SIGN(t2.minutes), 0) as login_t
  from get_start_ends t1
  left join get_logins t2
    on t1.dt = t2.dt and t1.customer_id = t2.customer_id and t1.user_id = t2.user_id

),

get_agg as (
   SELECT
    customer_id,
    user_id,
    user_role,
    dt,
    login_t,
    MAX(login_t) OVER (PARTITION BY customer_id, user_id ORDER BY dt ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) AS login_t_07
  FROM user_expand
)

select 
  dt,
  customer_id,
  user_role,
  count(*) as num_users,
  sum(login_t) as num_logins,
  ifnull(sum(login_t_07), 0) as num_logins_07
from get_agg
group by dt, customer_id, user_role
order by dt, customer_id, user_role