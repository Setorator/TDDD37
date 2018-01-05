
drop view if exists depCities;
drop view if exists destCities;
drop view if exists depTimeStamp;
drop view if exists seatView;
drop view if exists allFlights;z


-- #############################################################
-- #                The view for all flights                   #
-- #############################################################
-- Split up to several views that combines in allFlight view

create view depCities(route, departure_city) as
select route.route_id, airport.name
from route, airport
where route.dep_from = airport.airport_code;

create view destCities(route, destination_city) as
select route.route_id, airport.name
from route, airport
where route.arr_to = airport.airport_code;

create view depTimeStamp(flight, route, dep_time, day, week, year) as
select flight_id, schedule.route, schedule.dep_time, schedule.day, wFlight.week, schedule.year 
from
(select flight_id, week, schedule from flight) as wFlight 
left join
(select schedule_id, dep_time, day, year, route from weekly_schedule) as schedule
on (wFlight.schedule = schedule.schedule_id);

create view seatView(flight, nr_of_free_seats, current_price_per_seat) as

select f.flight_id, calculateFreeSeats(f.flight_id), calculatePrice(f.flight_id)
from flight as f;

create view allFlights(
departure_city,
destination_city,
departure_time,
departure_day,
departure_week,
departure_year,
nr_of_free_seats,
current_price_per_seat) as

select dep.departure_city, dest.destination_city,
flight_date.dep_time, flight_date.day, flight_date.week, flight_date.year,
seats.nr_of_free_seats, seats.current_price_per_seat
from

(select route, departure_city from depCities) as dep
inner join
((select route, destination_city from destCities) as dest,
(select flight, route, dep_time, day, week, year from depTimeStamp) as flight_date,
(select flight, nr_of_free_seats, current_price_per_seat from seatView) as seats)
on (seats.flight = flight_date.flight and
   dep.route = dest.route and
   dep.route = flight_date.route and
   dest.route = flight_date.route);
