WITH CarStats AS (
  SELECT 
    c.name AS car_name,
    c.class AS car_class,
    cl.country AS car_country,
    AVG(r.position) AS average_position,
    COUNT(*) AS race_count
  FROM Cars c
  JOIN Results r ON c.name = r.car
  JOIN Classes cl ON c.class = cl.class
  GROUP BY c.name, c.class, cl.country
),
LowPerformers AS (
  SELECT * FROM CarStats WHERE average_position > 3.0
),
ClassLowCounts AS (
  SELECT 
    car_class,
    COUNT(*) AS low_perf_count
  FROM LowPerformers
  GROUP BY car_class
),
MaxLowCount AS (
  SELECT MAX(low_perf_count) AS max_count FROM ClassLowCounts
),
TargetClasses AS (
  SELECT clc.car_class
  FROM ClassLowCounts clc
  JOIN MaxLowCount mlc ON clc.low_perf_count = mlc.max_count
),
ClassTotalRaces AS (
  SELECT 
    c.class AS car_class,
    COUNT(*) AS total_races
  FROM Cars c
  JOIN Results r ON c.name = r.car
  GROUP BY c.class
)
SELECT 
  lp.car_name,
  lp.car_class,
  ROUND(lp.average_position, 4) AS average_position,
  lp.race_count,
  lp.car_country,
  ctr.total_races
FROM LowPerformers lp
JOIN TargetClasses tc ON lp.car_class = tc.car_class
JOIN ClassTotalRaces ctr ON lp.car_class = ctr.car_class
ORDER BY tc.car_class;
