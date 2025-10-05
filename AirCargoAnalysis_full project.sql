/* ============================================================
   ✈️ AIR CARGO DATABASE ANALYSIS PROJECT
   Author: Noopura Vaidya
   Database: PostgreSQL
   Description: Complete SQL workflow covering schema creation,
                data cleaning, analytical queries, and functions.
   ============================================================ */

/* ============================================================
   TASK 1 – Create Database (Optional if already done)
   ============================================================ */
-- CREATE DATABASE air_cargo_db;
-- \c air_cargo_db;


/* ============================================================
   TASK 2 – Create the required tables
   ============================================================ */
CREATE TABLE customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10)
);

CREATE TABLE aircraft (
    aircraft_id VARCHAR(10) PRIMARY KEY,
    aircraft_type VARCHAR(50),
    manufacturer VARCHAR(50),
    capacity INT
);

CREATE TABLE routes (
    route_id VARCHAR(10) PRIMARY KEY,
    flight_num VARCHAR(10),
    origin_airport VARCHAR(50),
    destination_airport VARCHAR(50),
    aircraft_id VARCHAR(10),
    distance_miles INT,
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id)
);

CREATE TABLE class (
    class_id VARCHAR(10) PRIMARY KEY,
    class_name VARCHAR(50),
    description VARCHAR(100)
);

CREATE TABLE ticket_details (
    ticket_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    aircraft_id VARCHAR(10),
    route_id VARCHAR(10),
    class_id VARCHAR(10),
    brand VARCHAR(50),
    no_of_tickets INT,
    price_per_ticket NUMERIC(10,2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id)
);

CREATE TABLE passengers_on_flights (
    passenger_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    aircraft_id VARCHAR(10),
    route_id VARCHAR(10),
    class_id VARCHAR(10),
    seat_num VARCHAR(10),
    travel_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id)
);


/* ============================================================
   TASK 3 – Verify tables and imported data
   ============================================================ */
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

SELECT * FROM customer LIMIT 10;
SELECT * FROM aircraft LIMIT 10;
SELECT * FROM routes LIMIT 10;


/* ============================================================
   TASK 4 – Clean and prepare data (if imported from CSV)
   ============================================================ */
-- Example: Convert distance to integer and remove text
-- ALTER TABLE routes ALTER COLUMN distance_miles TYPE INT USING distance_miles::INT;
-- Remove null header rows
-- DELETE FROM customer WHERE customer_id = 'customer_id';


/* ============================================================
   TASK 5 – Display all customers
   ============================================================ */
SELECT * FROM customer;


/* ============================================================
   TASK 6 – Show customers who have booked tickets
   ============================================================ */
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    t.brand
FROM customer c
JOIN ticket_details t ON c.customer_id = t.customer_id;


/* ============================================================
   TASK 7 – Find number of passengers per travel class
   ============================================================ */
SELECT 
    class_id,
    COUNT(*) AS total_passengers
FROM passengers_on_flights
GROUP BY class_id
ORDER BY total_passengers DESC;


/* ============================================================
   TASK 8 – Calculate total revenue generated
   ============================================================ */
SELECT 
    SUM(no_of_tickets * price_per_ticket) AS total_revenue
FROM ticket_details;


/* ============================================================
   TASK 9 – Check if total revenue crossed 10,000
   ============================================================ */
SELECT 
    SUM(no_of_tickets * price_per_ticket) AS total_revenue,
    CASE 
        WHEN SUM(no_of_tickets * price_per_ticket) > 10000 THEN 'Revenue has crossed 10,000'
        ELSE 'Revenue has not crossed 10,000'
    END AS revenue_status
FROM ticket_details;


/* ============================================================
   TASK 10 – Identify highest ticket price per class (window fn)
   ============================================================ */
SELECT 
    class_id, 
    price_per_ticket,
    MAX(price_per_ticket) OVER (PARTITION BY class_id) AS max_price_per_class
FROM ticket_details;


/* ============================================================
   TASK 11 – Calculate total tickets per brand
   ============================================================ */
SELECT 
    brand, 
    SUM(no_of_tickets) AS total_tickets
FROM ticket_details
GROUP BY brand
ORDER BY total_tickets DESC;


/* ============================================================
   TASK 12 – Categorize routes by travel distance
   ============================================================ */
SELECT 
    route_id,
    flight_num,
    distance_miles,
    CASE 
        WHEN distance_miles <= 2000 THEN 'SDT - Short Distance Travel'
        WHEN distance_miles BETWEEN 2001 AND 6500 THEN 'IDT - Intermediate Distance Travel'
        ELSE 'LDT - Long Distance Travel'
    END AS route_category
FROM routes;


/* ============================================================
   TASK 13 – Use ROLLUP for hierarchical aggregation
   ============================================================ */
SELECT 
    customer_id, 
    aircraft_id,
    SUM(no_of_tickets * price_per_ticket) AS total_value
FROM ticket_details
GROUP BY ROLLUP (customer_id, aircraft_id);


/* ============================================================
   TASK 14 – Count total passengers per aircraft
   ============================================================ */
SELECT 
    aircraft_id,
    COUNT(passenger_id) AS passenger_count
FROM passengers_on_flights
GROUP BY aircraft_id
ORDER BY passenger_count DESC;


/* ============================================================
   TASK 15 – Find average ticket price by class
   ============================================================ */
SELECT 
    class_id,
    AVG(price_per_ticket) AS avg_ticket_price
FROM ticket_details
GROUP BY class_id;


/* ============================================================
   TASK 16 – Function: Check complimentary service eligibility
   ============================================================ */
CREATE OR REPLACE FUNCTION complimentary_services(p_class_id TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    IF LOWER(p_class_id) IN ('business', 'economy plus') THEN
        RETURN 'Yes';
    ELSE
        RETURN 'No';
    END IF;
END;
$$;

-- Example usage:
-- SELECT complimentary_services('Business');


/* ============================================================
   TASK 17 – Function: Fetch routes longer than 2000 miles
   ============================================================ */
CREATE OR REPLACE FUNCTION get_long_distance_routes_fn()
RETURNS TABLE (
    route_id TEXT,
    flight_num TEXT,
    origin_airport TEXT,
    destination_airport TEXT,
    aircraft_id TEXT,
    distance_miles INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.route_id,
        r.flight_num,
        r.origin_airport,
        r.destination_airport,
        r.aircraft_id,
        r.distance_miles
    FROM routes r
    WHERE r.distance_miles > 2000;
END;
$$;

-- SELECT * FROM get_long_distance_routes_fn();


/* ============================================================
   TASK 18 – Categorize all flights dynamically using CASE
   ============================================================ */
SELECT 
    route_id, 
    flight_num, 
    distance_miles,
    CASE 
        WHEN distance_miles <= 2000 THEN 'Short Distance'
        WHEN distance_miles BETWEEN 2001 AND 6500 THEN 'Intermediate Distance'
        ELSE 'Long Distance'
    END AS flight_category
FROM routes;


/* ============================================================
   TASK 19 – Create index for optimization
   ============================================================ */
CREATE INDEX idx_route_id ON passengers_on_flights(route_id);

-- Check query speed before and after:
-- EXPLAIN ANALYZE SELECT * FROM passengers_on_flights WHERE route_id = 'R001';


/* ============================================================
   TASK 20 – Function: Fetch customers whose last name is 'Scott'
   ============================================================ */
CREATE OR REPLACE FUNCTION fetch_customer_lastname_scott()
RETURNS TABLE (
    customer_id TEXT,
    first_name TEXT,
    last_name TEXT,
    date_of_birth DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.date_of_birth
    FROM customer c
    WHERE LOWER(c.last_name) = 'scott'
    ORDER BY c.customer_id;
END;
$$;

-- SELECT * FROM fetch_customer_lastname_scott();

