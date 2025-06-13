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
ClassStats AS (
  SELECT 
    car_class,
    AVG(average_position) AS class_avg_position,
    COUNT(*) AS car_count
  FROM CarStats
  GROUP BY car_class
  HAVING COUNT(*) >= 2
)
SELECT 
  cs.car_name,
  cs.car_class,
  ROUND(cs.average_position, 4) AS average_position,
  cs.race_count,
  cs.car_country
FROM CarStats cs
JOIN ClassStats cls ON cs.car_class = cls.car_class
WHERE cs.average_position < cls.class_avg_position
ORDER BY cs.car_class, cs.average_position;
