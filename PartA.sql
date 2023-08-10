/*
Part A: SQL using PostgreSQL Server (50 points)
You are hereby provided a list of flights that occurred in the first month of 2015 along with other flight information.
Using the SQL scripts and data provided, create a database named Flight_System and insert data into the tables to 
populate it. Write SQL queries to complete the following:
*/
(a)
SELECT 
    COUNT(DISTINCT TAIL_NUMBER) AS number_of_aircrafts, 
    COUNT(*) AS number_of_flights, 
    MIN(DEPARTURE_DELAY) AS min_depature_delay, 
    MAX(DEPARTURE_DELAY) AS max_depature_delay, 
    AVG(DEPARTURE_DELAY) AS avg_depepature_delay
FROM 
    FLIGHTS;
/****/
(b)
drop view FlightSummaryView
CREATE VIEW FlightSummaryView AS
SELECT 
    TO_DATE(year || '-' || month || '-' || day, 'YYYY-MM-DD') AS date,
    f.ORIGIN_AIRPORT AS IATA_CODE,
    a.AIRPORT AS ORIGIN_AIRPORT,
    CONCAT_WS(' ', a.CITY, a.STATE, a.COUNTRY) AS Address,
    COUNT(f.*) AS num_flights
	
FROM 
    FLIGHTS f
JOIN 
    AIRPORTS a ON f.ORIGIN_AIRPORT = a.IATA_CODE
WHERE 
    year = 2015 AND month = 1 AND day BETWEEN 1 AND 7 
GROUP BY 
   ORIGIN_AIRPORT, date, IATA_CODE,  Address
ORDER BY 
    IATA_CODE DESC;
	/*****************/
(C)	
Select f.count1,f.origin_airport, f.destination_airport, f.route_rank 
from 
(
Select  count(*)as count1,origin_airport, destination_airport,
              Row_number () over (partition by origin_airport order by count(*) DESC ) as route_rank
from flights
Group by origin_airport, destination_airport
) as f
WHERE route_rank <= 3;
/*****************/
(d)
SELECT
    a.iata_code AS airport_iata_code,
    a.airport AS air_name,
    f.airline AS airline_iata_code,
    an.airline AS airline_name,
    f.flight_number AS flight_number,
    f.tail_number AS tail_number,
    f.origin_airport AS origin_airport,
    f.destination_airport AS destination_airport,
    f.departure_time AS departure_time,
    f.arrival_time AS arrival_time
FROM
    flights f
JOIN
    airports a ON f.origin_airport = a.iata_code
JOIN
    airlines an ON f.airline = an.iata_code
WHERE
    f.day_of_week IN (1, 7) 
    AND f.arrival_time >= '0400' AND f.arrival_time <= '0500'
ORDER BY
    f.arrival_time;
/****************************/
(e)
WITH jfk_counting AS (
    SELECT ORIGIN_AIRPORT, COUNT(*) AS jfk_count
    FROM flights
    WHERE ORIGIN_AIRPORT = 'JFK'
    GROUP BY ORIGIN_AIRPORT
),
ny_counting AS (
    SELECT origin_airport, SUM(ny_count) OVER () AS ny_total_flights
    FROM (
        SELECT ORIGIN_AIRPORT, COUNT(*) AS ny_count
        FROM flights
        WHERE ORIGIN_AIRPORT IN ('JFK', 'LGA', 'EWR')
        GROUP BY ORIGIN_AIRPORT
    ) AS f
    GROUP BY origin_airport, ny_count
)

SELECT jfk_counting.ORIGIN_AIRPORT, jfk_count, ny_total_flights, ROUND(((jfk_count / ny_total_flights) * 100), 2) as JFK_Percent
FROM jfk_counting
JOIN ny_counting ON jfk_counting.ORIGIN_AIRPORT = ny_counting.origin_airport;
/************/
/*(F) part1*/
select * from flights
where origin_airport in ('Newark');
Select * from flights 
	where (origin_airport IN ('JFK', 'LGA')
		OR 
		  Destination_airport IN ('JFK', 'LGA', 'EWR'))
		AND 
		  Elapsed_time > 500 ;
/*(F)part 2*/		  
Update flights
	SET cancelled = 1
where (origin_airport IN ('JFK', 'LGA')
		OR 
		  Destination_airport IN ('JFK', 'LGA', 'EWR'))
		AND 
		  Elapsed_time > 500 
/************/
/*(G)*/
CREATE TEMPORARY TABLE Departure_Delays AS
SELECT 
    a.iata_code AS airport_code, 
    an.iata_code AS airline_code,
    an.airline AS airline_name,
    CASE 
        WHEN departure_delay >= -18 AND departure_delay <= 100 THEN 'small'
        WHEN departure_delay > 100 AND departure_delay <= 250 THEN 'medium'
        ELSE 'big'
    END AS departure_delay_category,
    COUNT(*) AS delays_ctg
FROM 
    flights f 
    JOIN airports a ON f.origin_airport = a.iata_code
    JOIN airlines an ON f.airline = an.iata_code
GROUP BY 
    departure_delay_category, airport_code, airline_code, airline_name
ORDER BY 
    delays_ctg DESC;
	
	
	
	
	
	
	
	
	