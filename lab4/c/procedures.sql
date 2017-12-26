-- #############################################################
-- ################## Set up procedures ########################
-- #############################################################

drop procedure if exists addYear;
drop procedure if exists addDay;
drop procedure if exists addDestination;
drop procedure if exists addRoute;
drop procedure if exists addFlight;

drop function if exists calculateFreeSeats;
drop function if exists calculatePrice;



delimiter //

create procedure addYear(in year integer, in factor double)
begin
	insert into year (year,profit) values (year, factor);
end//

create procedure addDay(in year integer, in day varchar(10), in factor double)
begin
	insert into weekday (day, year, profit) values (day, year, factor);
end//

create procedure addDestination(in airport_code varchar(3), in name varchar(30), in country varchar(30))
begin
	insert into airport (airport_code, name, country) values (airport_code, name, country);
end//

create procedure addRoute(in departure_airport_code varchar(3), in arrival_airport_code varchar(3), in year integer, in route_price double)
begin
	declare route_id varchar(12) default concat(departure_airport_code,'-',arrival_airport_code,'-',year);
	insert into route (route_id, arr_to, dep_from, year, route_price) 
	values (route_id, arrival_airport_code, departure_airport_code, year, route_price);
end//


-- This is, despite the name, the addWeeklySchedule procedure.
create procedure addFlight(in departure_airport_code varchar(3), in arrival_airport_code varchar(3), in year integer, in day varchar(10), in departure_time time)
begin
	declare w integer default 1;
	declare r_id varchar(12);
	declare s_id integer;

	select route_id into r_id from route 
       	where route.arr_to = arrival_airport_code and route.dep_from = departure_airport_code and route.year = year;

	insert into weekly_schedule (route, dep_time, day, year) 
	values (r_id, departure_time, day, year);	

	
	select schedule_id into s_id from weekly_schedule order by weekly_schedule.schedule_id desc limit 1;
	
	while w < 53 do
	      insert into flight (schedule, week) values (s_id, w);
	      set w = w + 1;
	end while;
end//

-- #############################################################
-- #################### Helpfunctions ##########################
-- #############################################################

create function calculateFreeSeats(flightnumber integer)
returns integer
begin
	declare seats integer default 40;
	declare occupied_seats integer default 0;
	declare free_seats integer default 0;

	select count(*) into occupied_seats from booked_pass 
	where reservation_nr in (select res_number from reservation where flight = flightnumber);
		
	set free_seats = seats - occupied_seats;
	return free_seats;
end //

create function calculatePrice(flightnumber integer)
returns double
begin
	declare total_price double;
	declare route_factor double;
	declare weekday_factor double;
	declare profit_factor double;
	declare booked_passengers double;

	set booked_passengers = 40 - calculateFreeSeats(flightnumber);
	
	select route_price into route_factor 
	from route 
	where route_id in(
	      select route 
	      from weekly_schedule 
	      where schedule_id in(
	      	    select schedule 
		    from flight 
		    where flight_id = flightnumber));

	select profit into weekday_factor
	from weekday
	where day in(
	      select day
	      from weekly_schedule
	      where schedule_id in(
	      	    select schedule 
		    from flight 
		    where flight_id = flightnumber));
	
	select profit into profit_factor
	from year	
	where year in(
	      select year
	      from weekly_schedule
	      where schedule_id in(
	      	    select schedule 
		    from flight 
		    where flight_id = flightnumber));

	set total_price = route_factor * weekday_factor * (booked_passengers + 1.0)* 0.025 * profit_factor;
	
	return total_price;
end //


-- #############################################################
-- #################### Set up triggers ########################
-- #############################################################

create trigger rand_ticket_nr before insert on booked_pass
-- for each row?
begin

end //


delimiter ;


