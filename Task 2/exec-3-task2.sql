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
ClassAvg AS (
  SELECT 
    car_class,
    AVG(average_position) AS class_avg_position
  FROM CarStats
  GROUP BY car_class
),
MinClassAvg AS (
  SELECT MIN(class_avg_position) AS min_avg_position
  FROM ClassAvg
),
TargetClasses AS (
  SELECT c.car_class
  FROM ClassAvg c
  JOIN MinClassAvg m ON c.class_avg_position = m.min_avg_position
),
ClassRaceCounts AS (
  SELECT 
    c.class AS car_class,
    COUNT(*) AS total_races
  FROM Cars c
  JOIN Results r ON c.name = r.car
  GROUP BY c.class
)
SELECT 
  cs.car_name,
  cs.car_class,
  ROUND(cs.average_position, 4) AS average_position,
  cs.race_count,
  cs.car_country,
  crc.total_races
FROM CarStats cs
JOIN TargetClasses tc ON cs.car_class = tc.car_class
JOIN ClassRaceCounts crc ON cs.car_class = crc.car_class
ORDER BY cs.average_position, cs.car_name;
