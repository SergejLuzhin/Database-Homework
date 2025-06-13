SELECT 
  cu.name,
  cu.email,
  cu.phone,
  COUNT(b.ID_booking) AS total_bookings,
  STRING_AGG(DISTINCT h.name, ', ') AS hotels,
  ROUND(AVG(b.check_out_date - b.check_in_date), 4) AS avg_stay_duration
FROM Booking b
JOIN Customer cu ON b.ID_customer = cu.ID_customer
JOIN Room r ON b.ID_room = r.ID_room
JOIN Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY cu.ID_customer, cu.name, cu.email, cu.phone
HAVING COUNT(b.ID_booking) > 2 AND COUNT(DISTINCT h.ID_hotel) >= 2
ORDER BY total_bookings DESC;
