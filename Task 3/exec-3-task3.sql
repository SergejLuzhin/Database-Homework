WITH HotelCategory AS (
  SELECT 
    h.ID_hotel,
    h.name AS hotel_name,
    AVG(r.price) AS avg_price,
    CASE 
      WHEN AVG(r.price) < 175 THEN 'Дешевый'
      WHEN AVG(r.price) <= 300 THEN 'Средний'
      ELSE 'Дорогой'
    END AS category
  FROM Hotel h
  JOIN Room r ON h.ID_hotel = r.ID_hotel
  GROUP BY h.ID_hotel, h.name
),
CustomerVisits AS (
  SELECT 
    DISTINCT c.ID_customer,
    c.name,
    hc.category,
    hc.hotel_name
  FROM Booking b
  JOIN Customer c ON b.ID_customer = c.ID_customer
  JOIN Room r ON b.ID_room = r.ID_room
  JOIN HotelCategory hc ON r.ID_hotel = hc.ID_hotel
),
PreferredType AS (
  SELECT 
    ID_customer,
    name,
    MAX(CASE 
      WHEN category = 'Дорогой' THEN 3
      WHEN category = 'Средний' THEN 2
      ELSE 1
    END) AS priority
  FROM CustomerVisits
  GROUP BY ID_customer, name
),
LabeledType AS (
  SELECT 
    p.ID_customer,
    p.name,
    CASE 
      WHEN p.priority = 3 THEN 'Дорогой'
      WHEN p.priority = 2 THEN 'Средний'
      ELSE 'Дешевый'
    END AS preferred_hotel_type
  FROM PreferredType p
),
CustomerHotels AS (
  SELECT 
    c.ID_customer,
    STRING_AGG(DISTINCT hc.hotel_name, ', ') AS visited_hotels
  FROM Booking b
  JOIN Customer c ON b.ID_customer = c.ID_customer
  JOIN Room r ON b.ID_room = r.ID_room
  JOIN HotelCategory hc ON r.ID_hotel = hc.ID_hotel
  GROUP BY c.ID_customer
)
SELECT 
  lt.ID_customer,
  lt.name,
  lt.preferred_hotel_type,
  ch.visited_hotels
FROM LabeledType lt
JOIN CustomerHotels ch ON lt.ID_customer = ch.ID_customer
ORDER BY 
  CASE lt.preferred_hotel_type
    WHEN 'Дешевый' THEN 1
    WHEN 'Средний' THEN 2
    WHEN 'Дорогой' THEN 3
  END,
  lt.ID_customer;
