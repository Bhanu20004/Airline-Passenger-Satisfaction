
-- ============================================================
-- AIRLINE PASSENGER SATISFACTION
-- SQL DATA ANALYSIS QUERIES
-- Table: airline_passenger_satisfaction
-- ============================================================


-- ============================================================
-- 1. DATASET OVERVIEW
-- ============================================================

-- Query 1: Total passengers
SELECT
    COUNT(*) AS total_passengers
FROM airline_passenger_satisfaction;


-- Query 2: Overall satisfaction distribution
SELECT
    satisfaction,
    COUNT(*) AS passenger_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM airline_passenger_satisfaction
GROUP BY satisfaction
ORDER BY passenger_count DESC;


-- ============================================================
-- 2. PASSENGER DEMOGRAPHICS
-- ============================================================

-- Query 3: Gender distribution
SELECT
    gender,
    COUNT(*) AS passenger_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM airline_passenger_satisfaction
GROUP BY gender;


-- Query 4: Passenger age statistics
SELECT
    ROUND(AVG(age), 2) AS average_age,
    MIN(age) AS youngest_passenger,
    MAX(age) AS oldest_passenger
FROM airline_passenger_satisfaction;


-- Query 5: Customer type distribution
SELECT
    customer_type,
    COUNT(*) AS passenger_count
FROM airline_passenger_satisfaction
GROUP BY customer_type
ORDER BY passenger_count DESC;


-- ============================================================
-- 3. TRAVEL CHARACTERISTICS
-- ============================================================

-- Query 6: Distribution by travel purpose
SELECT
    type_of_travel,
    COUNT(*) AS passenger_count,
    ROUND(AVG(flight_distance), 2) AS average_flight_distance
FROM airline_passenger_satisfaction
GROUP BY type_of_travel;


-- Query 7: Passenger distribution by travel class
SELECT
    class,
    COUNT(*) AS passenger_count,
    ROUND(AVG(flight_distance), 2) AS average_flight_distance
FROM airline_passenger_satisfaction
GROUP BY class
ORDER BY passenger_count DESC;


-- Query 8: Flight distance statistics
SELECT
    ROUND(AVG(flight_distance), 2) AS average_distance,
    MIN(flight_distance) AS shortest_distance,
    MAX(flight_distance) AS longest_distance
FROM airline_passenger_satisfaction;


-- ============================================================
-- 4. FLIGHT DELAY ANALYSIS
-- ============================================================

-- Query 9: Average departure and arrival delays
SELECT
    ROUND(AVG(departure_delay), 2) AS average_departure_delay,
    ROUND(AVG(arrival_delay), 2) AS average_arrival_delay
FROM airline_passenger_satisfaction;


-- Query 10: Passengers experiencing flight delays
SELECT
    COUNT(*) AS total_passengers,

    SUM(
        CASE WHEN departure_delay > 0
        THEN 1 ELSE 0 END
    ) AS departure_delayed_passengers,

    SUM(
        CASE WHEN arrival_delay > 0
        THEN 1 ELSE 0 END
    ) AS arrival_delayed_passengers

FROM airline_passenger_satisfaction;


-- Query 11: Average delays by satisfaction
SELECT
    satisfaction,
    ROUND(AVG(departure_delay), 2) AS average_departure_delay,
    ROUND(AVG(arrival_delay), 2) AS average_arrival_delay
FROM airline_passenger_satisfaction
GROUP BY satisfaction;


-- ============================================================
-- 5. CUSTOMER SATISFACTION ANALYSIS
-- ============================================================

-- Query 12: Satisfaction by gender
SELECT
    gender,
    satisfaction,
    COUNT(*) AS passenger_count
FROM airline_passenger_satisfaction
GROUP BY gender, satisfaction
ORDER BY gender, satisfaction;


-- Query 13: Satisfaction by customer type
SELECT
    customer_type,
    satisfaction,
    COUNT(*) AS passenger_count
FROM airline_passenger_satisfaction
GROUP BY customer_type, satisfaction
ORDER BY customer_type, satisfaction;


-- Query 14: Satisfaction by travel class
SELECT
    class,
    satisfaction,
    COUNT(*) AS passenger_count
FROM airline_passenger_satisfaction
GROUP BY class, satisfaction
ORDER BY class, satisfaction;


-- Query 15: Satisfaction by travel purpose
SELECT
    type_of_travel,
    satisfaction,
    COUNT(*) AS passenger_count
FROM airline_passenger_satisfaction
GROUP BY type_of_travel, satisfaction
ORDER BY type_of_travel, satisfaction;


-- Query 16: Satisfaction percentage by travel class
SELECT
    class,
    COUNT(*) AS total_passengers,

    SUM(
        CASE WHEN satisfaction = 'satisfied'
        THEN 1 ELSE 0 END
    ) AS satisfied_passengers,

    ROUND(
        SUM(
            CASE WHEN satisfaction = 'satisfied'
            THEN 1 ELSE 0 END
        ) * 100.0 / COUNT(*),
        2
    ) AS satisfaction_percentage

FROM airline_passenger_satisfaction
GROUP BY class
ORDER BY satisfaction_percentage DESC;


-- ============================================================
-- 6. AIRLINE SERVICE QUALITY ANALYSIS
-- ============================================================

-- Query 17: Average ratings of all airline services
SELECT
    ROUND(AVG("departure_and_arrival_time_convenience"), 2) AS time_convenience,
    ROUND(AVG(ease_of_online_booking), 2) AS online_booking,
    ROUND(AVG("check-in_service"), 2) AS check_in_service,
    ROUND(AVG(online_boarding), 2) AS online_boarding,
    ROUND(AVG(gate_location), 2) AS gate_location,
    ROUND(AVG("on-board_service"), 2) AS onboard_service,
    ROUND(AVG(seat_comfort), 2) AS seat_comfort,
    ROUND(AVG(leg_room_service), 2) AS leg_room,
    ROUND(AVG(cleanliness), 2) AS cleanliness,
    ROUND(AVG(food_and_drink), 2) AS food_and_drink,
    ROUND(AVG("in-flight_service"), 2) AS inflight_service,
    ROUND(AVG("in-flight_wifi_service"), 2) AS wifi_service,
    ROUND(AVG("in-flight_entertainment"), 2) AS entertainment,
    ROUND(AVG(baggage_handling), 2) AS baggage_handling
FROM airline_passenger_satisfaction;


-- Query 18: Average service ratings by satisfaction
SELECT
    satisfaction,
    ROUND(AVG("departure_and_arrival_time_convenience"), 2) AS time_convenience,
    ROUND(AVG(ease_of_online_booking), 2) AS online_booking,
    ROUND(AVG("check-in_service"), 2) AS check_in_service,
    ROUND(AVG(online_boarding), 2) AS online_boarding,
    ROUND(AVG(gate_location), 2) AS gate_location,
    ROUND(AVG("on-board_service"), 2) AS onboard_service,
    ROUND(AVG(seat_comfort), 2) AS seat_comfort,
    ROUND(AVG(leg_room_service), 2) AS leg_room,
    ROUND(AVG(cleanliness), 2) AS cleanliness,
    ROUND(AVG(food_and_drink), 2) AS food_and_drink,
    ROUND(AVG("in-flight_service"), 2) AS inflight_service,
    ROUND(AVG("in-flight_wifi_service"), 2) AS wifi_service,
    ROUND(AVG("in-flight_entertainment"), 2) AS entertainment,
    ROUND(AVG(baggage_handling), 2) AS baggage_handling
FROM airline_passenger_satisfaction
GROUP BY satisfaction;


-- ============================================================
-- 7. ADVANCED BUSINESS ANALYSIS
-- ============================================================

-- Query 19: Satisfaction by age group
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age BETWEEN 56 AND 65 THEN '56-65'
        WHEN age >= 66 THEN '66+'
        ELSE 'Other'
    END AS age_group,

    COUNT(*) AS total_passengers,

    SUM(
        CASE WHEN satisfaction = 'satisfied'
        THEN 1 ELSE 0 END
    ) AS satisfied_passengers,

    ROUND(
        SUM(
            CASE WHEN satisfaction = 'satisfied'
            THEN 1 ELSE 0 END
        ) * 100.0 / COUNT(*),
        2
    ) AS satisfaction_percentage

FROM airline_passenger_satisfaction
GROUP BY age_group
ORDER BY age_group;


-- Query 20: Satisfaction by travel class and customer type
SELECT
    class,
    customer_type,
    satisfaction,
    COUNT(*) AS passenger_count
FROM airline_passenger_satisfaction
GROUP BY
    class,
    customer_type,
    satisfaction
ORDER BY
    class,
    customer_type,
    satisfaction;


-- Query 21: Passengers experiencing delays above 30 minutes
SELECT
    satisfaction,
    COUNT(*) AS passenger_count,
    ROUND(AVG(departure_delay), 2) AS average_departure_delay,
    ROUND(AVG(arrival_delay), 2) AS average_arrival_delay
FROM airline_passenger_satisfaction
WHERE departure_delay > 30
   OR arrival_delay > 30
GROUP BY satisfaction;


-- ============================================================
-- END OF ANALYSIS QUERIES
-- ============================================================
