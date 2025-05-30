
USE hotel_booking;
SHOW TABLES;

###Running a query to see repeat bookings 
SELECT g.first_name, g.last_name, g.guest_id, COUNT(*) AS num_bookings
FROM guests g
JOIN reservations r ON g.guest_id = r.guest_id
GROUP BY g.guest_id, g.first_name, g.last_name
HAVING COUNT(*) > 1
LIMIT 1000;

#--This is saying that there are no repeat guests and ppl only stay once

##---Had to double check--##
SELECT COUNT(*) FROM reservations;
SELECT COUNT(DISTINCT guest_id) FROM reservations;
SELECT COUNT(*) FROM guests;

##----##

###Total Revenue by Month

SELECT DATE_FORMAT(STR_TO_DATE(payment_dates, '%Y-%m-%d'), '%Y-%m') AS month,
       SUM(amount_in_$) AS total_revenue
FROM payments
GROUP BY month
ORDER BY month;

##--Guests who spent over $500--##
SELECT 
  g.guest_id, 
  g.first_name, 
  g.last_name, 
  SUM(p.amount_in_$) AS total_spent
FROM guests g
JOIN reservations r ON g.guest_id = r.guest_id
JOIN payments p ON r.reservation_id = p.reservation_id
GROUP BY g.guest_id, g.first_name, g.last_name
HAVING total_spent > 500
ORDER BY total_spent DESC;

##--Now that we have top 10 spenders, lets join membership status--##
SELECT 
    g.Guest_ID,
    CONCAT(g.First_Name, ' ', g.Last_Name) AS Full_Name,
    g.Membership_Status,
    SUM(amount_in_$) AS Total_Spent
FROM payments p
JOIN reservations r ON p.reservation_id = r.reservation_id
JOIN guests g ON r.guest_id = g.Guest_ID
GROUP BY g.Guest_ID, Full_Name, g.Membership_Status
ORDER BY Total_Spent DESC
LIMIT 10;

#Find Failed Payments and show reservation info and guest contact
SELECT 
    p.payment_id,
    p.reservation_id,
    p.payment_method,
    p.payment_status,
    p.amount_in_$,
    r.check_in_date,
    r.check_out_date,
    g.First_Name,
    g.Last_Name,
    g.Phone_number,
    g.Email
FROM payments p
JOIN reservations r ON p.reservation_id = r.reservation_id
JOIN guests g ON r.guest_id = g.Guest_ID
WHERE LOWER(p.payment_status) = 'failed';
