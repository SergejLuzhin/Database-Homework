--Задача 1

WITH AvgPositions AS (
  SELECT
    c.name AS car_name,
    c.class,
    AVG(r.position) AS avg_position,
    COUNT(r.race) AS race_count
  FROM Cars c
  JOIN Results r ON c.name = r.car
  GROUP BY c.name, c.class
),
MinPositions AS (
  SELECT class, MIN(avg_position) AS min_avg_position
  FROM AvgPositions
  GROUP BY class
)
SELECT 
  a.car_name,
  a.class,
  ROUND(a.avg_position, 2) AS avg_position,
  a.race_count
FROM AvgPositions a
JOIN MinPositions m ON a.class = m.class AND a.avg_position = m.min_avg_position
ORDER BY a.avg_position ASC;
