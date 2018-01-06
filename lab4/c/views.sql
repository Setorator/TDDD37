
drop view if exists depCities;
drop view if exists destCities;
drop view if exists weeklyFlight;
drop view if exists schedule;
drop view if exists depTimeStamp;
drop view if exists seatView;
drop view if exists allFlights;

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

create view weeklyFlight(flight_id, schedule, week) as 
select flight_id, schedule, week from flight;

create view schedule(schedule_id, route, dep_time, day, year) as
select schedule_id, route, dep_time, day, year from weekly_schedule;

create view depTimeStamp(flight, route, dep_time, day, week, year) as
select weeklyFlight.flight_id, schedule.route, schedule.dep_time, schedule.day, weeklyFlight.week, schedule.year 
from
weeklyFlight
left join
schedule
on (weeklyFlight.schedule = schedule.schedule_id);

create view seatView(flight, nr_of_free_seats, current_price_per_seat) as

select f.flight_id, calculateFreeSeats(f.flight_id), calculatePrice(f.flight_id)
from flight as f;

create view allFlights(
departure_city_name,
destination_city_name,
departure_time,
departure_day,
departure_week,
departure_year,
nr_of_free_seats,
current_price_per_seat) as

select depCities.departure_city, 
destCities.destination_city,
depTimeStamp.dep_time, 
depTimeStamp.day, 
depTimeStamp.week, 
depTimeStamp.year,
seatView.nr_of_free_seats, 
seatView.current_price_per_seat
from

depCities
inner join
(destCities,
depTimeStamp,
seatView)
on (seatView.flight = depTimeStamp.flight and
   depCities.route = destCities.route and
   depCities.route = depTimeStamp.route and
   destCities.route = depTimeStamp.route);
