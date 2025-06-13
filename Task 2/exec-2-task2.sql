SELECT 
  a.car_name,
  a.class AS car_class,
  ROUND(a.avg_position, 4) AS average_position,
  a.race_count,
  cl.country AS car_country
FROM (
  SELECT 
    c.name AS car_name,
    c.class,
    AVG(r.position) AS avg_position,
    COUNT(*) AS race_count
  FROM Cars c
  JOIN Results r ON c.name = r.car
  GROUP BY c.name, c.class
) a
JOIN Classes cl ON a.class = cl.class
ORDER BY a.avg_position ASC, a.car_name ASC
LIMIT 1;
