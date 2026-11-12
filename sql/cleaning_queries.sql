
-- ============================================================
-- AIRLINE PASSENGER SATISFACTION
-- SQL DATA CLEANING QUERIES
-- Table: airline_passenger_satisfaction
-- Database: PostgreSQL
-- ============================================================


-- ============================================================
-- 1. INITIAL DATA INSPECTION
-- ============================================================

-- Query 1: Check total number of records
SELECT
    COUNT(*) AS total_records
FROM airline_passenger_satisfaction;


-- Query 2: Inspect sample records
SELECT *
FROM airline_passenger_satisfaction
LIMIT 10;


-- Query 3: Check missing values in important columns
SELECT
    COUNT(*) FILTER (WHERE gender IS NULL) AS missing_gender,
    COUNT(*) FILTER (WHERE customer_type IS NULL) AS missing_customer_type,
    COUNT(*) FILTER (WHERE age IS NULL) AS missing_age,
    COUNT(*) FILTER (WHERE type_of_travel IS NULL) AS missing_travel_type,
    COUNT(*) FILTER (WHERE class IS NULL) AS missing_class,
    COUNT(*) FILTER (WHERE flight_distance IS NULL) AS missing_flight_distance,
    COUNT(*) FILTER (WHERE departure_delay IS NULL) AS missing_departure_delay,
    COUNT(*) FILTER (WHERE arrival_delay IS NULL) AS missing_arrival_delay,
    COUNT(*) FILTER (WHERE satisfaction IS NULL) AS missing_satisfaction
FROM airline_passenger_satisfaction;


-- ============================================================
-- 2. DUPLICATE RECORD CHECKING
-- ============================================================

-- Query 4: Count completely duplicated records
SELECT
    COUNT(*) - COUNT(DISTINCT ROW(
        gender,
        customer_type,
        age,
        type_of_travel,
        class,
        flight_distance,
        departure_delay,
        arrival_delay,
        satisfaction
    )) AS duplicate_records
FROM airline_passenger_satisfaction;


-- Query 5: Inspect possible duplicate records
SELECT
    gender,
    customer_type,
    age,
    type_of_travel,
    class,
    flight_distance,
    departure_delay,
    arrival_delay,
    satisfaction,
    COUNT(*) AS occurrence_count
FROM airline_passenger_satisfaction
GROUP BY
    gender,
    customer_type,
    age,
    type_of_travel,
    class,
    flight_distance,
    departure_delay,
    arrival_delay,
    satisfaction
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;


-- ============================================================
-- 3. STANDARDIZING TEXT VALUES
-- ============================================================

-- Query 6: Inspect categorical values
SELECT DISTINCT gender
FROM airline_passenger_satisfaction;

SELECT DISTINCT customer_type
FROM airline_passenger_satisfaction;

SELECT DISTINCT type_of_travel
FROM airline_passenger_satisfaction;

SELECT DISTINCT class
FROM airline_passenger_satisfaction;

SELECT DISTINCT satisfaction
FROM airline_passenger_satisfaction;


-- Query 7: Identify leading/trailing spaces
SELECT *
FROM airline_passenger_satisfaction
WHERE gender <> TRIM(gender)
   OR customer_type <> TRIM(customer_type)
   OR type_of_travel <> TRIM(type_of_travel)
   OR class <> TRIM(class)
   OR satisfaction <> TRIM(satisfaction);


-- ============================================================
-- 4. INVALID VALUE DETECTION
-- ============================================================

-- Query 8: Check invalid passenger ages
SELECT *
FROM airline_passenger_satisfaction
WHERE age < 0 OR age > 100;


-- Query 9: Check invalid flight distances
SELECT *
FROM airline_passenger_satisfaction
WHERE flight_distance < 0;


-- Query 10: Check negative flight delays
-- Negative values can represent early departures or arrivals.
SELECT *
FROM airline_passenger_satisfaction
WHERE departure_delay < 0
   OR arrival_delay < 0;


-- Query 11: Check invalid service ratings
-- Common dataset rating scale: 0 to 5.
SELECT *
FROM airline_passenger_satisfaction
WHERE "departure_and_arrival_time_convenience" NOT BETWEEN 0 AND 5
   OR ease_of_online_booking NOT BETWEEN 0 AND 5
   OR "check-in_service" NOT BETWEEN 0 AND 5
   OR online_boarding NOT BETWEEN 0 AND 5
   OR gate_location NOT BETWEEN 0 AND 5
   OR "on-board_service" NOT BETWEEN 0 AND 5
   OR seat_comfort NOT BETWEEN 0 AND 5
   OR leg_room_service NOT BETWEEN 0 AND 5
   OR cleanliness NOT BETWEEN 0 AND 5
   OR food_and_drink NOT BETWEEN 0 AND 5
   OR "in-flight_service" NOT BETWEEN 0 AND 5
   OR "in-flight_wifi_service" NOT BETWEEN 0 AND 5
   OR "in-flight_entertainment" NOT BETWEEN 0 AND 5
   OR baggage_handling NOT BETWEEN 0 AND 5;


-- Query 12: Check unexpected categorical values
SELECT *
FROM airline_passenger_satisfaction
WHERE LOWER(TRIM(gender)) NOT IN ('male', 'female')
   OR LOWER(TRIM(customer_type)) NOT IN ('loyal customer', 'disloyal customer')
   OR LOWER(TRIM(type_of_travel)) NOT IN ('business travel', 'personal travel')
   OR LOWER(TRIM(class)) NOT IN ('business', 'eco', 'eco plus')
   OR LOWER(TRIM(satisfaction)) NOT IN ('satisfied', 'neutral or dissatisfied');


-- ============================================================
-- 5. DATA CLEANING
-- ============================================================

-- Query 13: Create a cleaned table
-- This preserves the original source table.

DROP TABLE IF EXISTS airline_passenger_satisfaction_cleaned;

CREATE TABLE airline_passenger_satisfaction_cleaned AS
SELECT *
FROM airline_passenger_satisfaction;


-- Query 14: Remove leading and trailing spaces
UPDATE airline_passenger_satisfaction_cleaned
SET
    gender = TRIM(gender),
    customer_type = TRIM(customer_type),
    type_of_travel = TRIM(type_of_travel),
    class = TRIM(class),
    satisfaction = TRIM(satisfaction);


-- Query 15: Standardize categorical capitalization
UPDATE airline_passenger_satisfaction_cleaned
SET
    gender = INITCAP(LOWER(gender)),
    customer_type = INITCAP(LOWER(customer_type)),
    type_of_travel = INITCAP(LOWER(type_of_travel)),
    class = INITCAP(LOWER(class)),
    satisfaction = LOWER(satisfaction);


-- ============================================================
-- 6. MISSING VALUE HANDLING
-- ============================================================

-- Query 16: Fill missing arrival delays using the median.
-- Only run if missing arrival delays exist.

UPDATE airline_passenger_satisfaction_cleaned
SET arrival_delay = (
    SELECT PERCENTILE_CONT(0.5)
           WITHIN GROUP (ORDER BY arrival_delay)
    FROM airline_passenger_satisfaction_cleaned
    WHERE arrival_delay IS NOT NULL
)
WHERE arrival_delay IS NULL;


-- Query 17: Check remaining missing values in delay columns
SELECT
    COUNT(*) FILTER (
        WHERE departure_delay IS NULL
    ) AS missing_departure_delay,

    COUNT(*) FILTER (
        WHERE arrival_delay IS NULL
    ) AS missing_arrival_delay
FROM airline_passenger_satisfaction_cleaned;


-- ============================================================
-- 7. FINAL DATA VALIDATION
-- ============================================================

-- Query 18: Check cleaned table record count
SELECT
    COUNT(*) AS cleaned_total_records
FROM airline_passenger_satisfaction_cleaned;


-- Query 19: Check remaining missing values
SELECT
    COUNT(*) FILTER (WHERE gender IS NULL) AS missing_gender,
    COUNT(*) FILTER (WHERE customer_type IS NULL) AS missing_customer_type,
    COUNT(*) FILTER (WHERE age IS NULL) AS missing_age,
    COUNT(*) FILTER (WHERE type_of_travel IS NULL) AS missing_travel_type,
    COUNT(*) FILTER (WHERE class IS NULL) AS missing_class,
    COUNT(*) FILTER (WHERE flight_distance IS NULL) AS missing_flight_distance,
    COUNT(*) FILTER (WHERE departure_delay IS NULL) AS missing_departure_delay,
    COUNT(*) FILTER (WHERE arrival_delay IS NULL) AS missing_arrival_delay,
    COUNT(*) FILTER (WHERE satisfaction IS NULL) AS missing_satisfaction
FROM airline_passenger_satisfaction_cleaned;


-- Query 20: Final cleaned dataset preview
SELECT *
FROM airline_passenger_satisfaction_cleaned
LIMIT 10;


-- ============================================================
-- END OF CLEANING QUERIES
-- ============================================================
