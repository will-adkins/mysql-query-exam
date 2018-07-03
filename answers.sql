-- 1. Select a distinct list of ordered airports codes. Be sure to name the column correctly. 

select distinct departAirport as Airports
from flight
order by departAirport;

-- 2. Provide a list of flights with a delayed status that depart from San Francisco (SFO).

select name, flightNumber, scheduledDepartDateTime, arriveAirport, status
from flight f
join airline a on f.airlineID = a.ID
where status = 'delayed'
and departAirport = 'SFO';

-- 3. Provide a distinct list of cities that American Airlines departs from.

select distinct departAirport as Cities
from flight
where airlineID = 1;

-- 4. Provide a distinct list of airlines that conducts flights departing from ATL.

select distinct a.name as Airline
from airline a
join flight f on f.airlineID = a.ID
where departAirport = 'ATL';

-- 5. Provide a list of airlines, flight numbers, departing airports, and arrival airports 
-- where flights departed on time.

select a.name, f.flightNumber, f.departAirport, f.arriveAirport
from airline a
join flight f on f.airlineID = a.ID
where f.scheduledDepartDateTime = f.actualDepartDateTime;

-- 6. Provide a list of airlines, flight numbers, gates, status, and arrival times arriving into Charlotte (CLT) 
-- on 10-30-2017. Order your results by the arrival time.

select a.name as Airline, f.flightNumber as Flight, f.gate as Gate, TIME(f.scheduledArriveDateTime) as Arrival, f.status as Status
from airline a
join flight f on a.ID = f.airlineID
where arriveAirport = 'CLT'
and DATE(f.scheduledArriveDateTime) = '2017-10-30';

-- 7. List the number of reservations by flight number. Order by reservations in descending order.

select f.flightNumber as flight, count(r.ID) as reservations
from flight f
join reservation r on f.ID = r.flightID
group by f.flightNumber
order by reservations DESC;

-- 8. List the average ticket cost for coach by airline and route. Order by AverageCost in descending order.

select a.name as airline, f.departAirport, f.arriveAirport, AVG(r.cost) as AverageCost
from reservation r
join flight f on r.flightID = f.ID
join airline a on f.airlineID = a.ID
where r.class = 'coach'
group by f.departAirport, arriveAirport
order by AverageCost DESC;

-- 9. Which route is the longest?

select departAirport, arriveAirport, miles
from flight
order by miles DESC
limit 1;

-- 10. List the top 5 passengers that have flown the most miles. Order by miles.

select p.firstName, p.lastName, SUM(f.miles) as miles
from passenger p
join reservation r on r.passengerID = p.ID
join flight f on r.flightID = f.ID
group by p.ID
order by miles DESC, p.firstName
limit 5;

-- 11. Provide a list of American airline flights ordered by route and arrival date and time. 

select a.name as Name, concat_ws(' --> ', f.departAirport, f.arriveAirport) as Route, 
DATE(f.scheduledArriveDateTime) as 'Arrive Date', TIME(f.scheduledArriveDateTime) as 'Arrive Time'
from airline a
join flight f on f.airlineID = a.ID
where a.name = "American"
order by route, DATE(f.scheduledArriveDateTime), TIME(f.scheduledArriveDateTime);

-- 12. Provide a report that counts the number of reservations and totals the reservation costs 
-- (as Revenue) by Airline, flight, and route. Order the report by total revenue in descending order.

select a.name as Airline, f.flightNumber as Flight, concat_ws(' --> ', f.departAirport, f.arriveAirport) as Route,
COUNT(r.ID) as 'Reservation Count', SUM(r.cost) as Revenue
from airline a
join flight f on f.airlineID = a.ID
join reservation r on r.flightID = f.ID
group by Airline, Flight, Route
order by Revenue DESC;

-- 13. List the average cost per reservation by route. Round results down to the dollar.

select concat_ws(' --> ', f.departAirport, f.arriveAirport) as Route, FLOOR(AVG(r.cost)) as 'Avg Revenue'
from flight f
join reservation r on r.flightID = f.ID
group by Route
order by AVG(r.cost) DESC;

-- 14. List the average miles per flight by airline.

select a.name as Airline, AVG(f.miles) as 'Avg Miles Per Flight'
from airline a
join flight f on a.ID = f.airlineID
group by Airline;

-- 15. Which airlines had flights that arrived early?

select distinct a.name as Airline
from airline a
join flight f on f.airlineID = a.ID
where f.scheduledArriveDateTime > f.actualArriveDateTime;
