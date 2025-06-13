SELECT 
  cu.ID_customer,
  cu.name,
  COUNT(b.ID_booking) AS total_bookings,
  ROUND(SUM(r.price * (b.check_out_date - b.check_in_date)), 2) AS total_spent,
  COUNT(DISTINCT h.ID_hotel) AS unique_hotels
FROM Booking b
JOIN Customer cu ON b.ID_customer = cu.ID_customer
JOIN Room r ON b.ID_room = r.ID_room
JOIN Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY cu.ID_customer, cu.name
HAVING 
  COUNT(b.ID_booking) > 2 AND
  COUNT(DISTINCT h.ID_hotel) > 1 AND
  SUM(r.price * (b.check_out_date - b.check_in_date)) > 500
ORDER BY total_spent ASC;
