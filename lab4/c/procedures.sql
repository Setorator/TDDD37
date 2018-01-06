-- #############################################################
-- #                  Set up procedures                        #
-- #############################################################

drop procedure if exists addYear;
drop procedure if exists addDay;
drop procedure if exists addDestination;
drop procedure if exists addRoute;
drop procedure if exists addFlight;
drop procedure if exists addReservation;
drop procedure if exists addPassenger;
drop procedure if exists addContact;
drop procedure if exists addPayment;

drop function if exists calculatePassengers;
drop function if exists calculateFreeSeats;
drop function if exists calculatePrice;

drop trigger if exists randTicketNr;


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
-- #                      Helpfunctions                        #
-- #############################################################

create function calculateFreeSeats(flightnumber integer)
returns integer
begin
	declare seats integer default 40;
	declare occupied_seats integer default 0;
	declare free_seats integer default 0;
	  
	select count(*) into occupied_seats
	from booked_pass
	where ticket_nr != 0 and reservation_nr in (
	      select res_number
	      from reservation
	      where flight = flightnumber);

	if (occupied_seats is null) then
	   set occupied_seats = 0;
	end if;
	      	
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

create function calculatePassengers(res_nr integer)
returns integer
begin
	declare nr_pass integer;

	select count(*) into nr_pass
	from booked_pass
	where reservation_nr = res_nr;

	if (nr_pass is null) then 
	   set nr_pass = 0;
	end if;

	return nr_pass;

end //


-- #############################################################
-- #                    Set up triggers                        #
-- #############################################################

create trigger randTicketNr before update on booked_pass
for each row
begin
	declare is_unique boolean;
	declare random_nr integer unsigned;

	set is_unique = false;
	
	if (new.ticket_nr = 1)
	then		  
		
	repeat
	set random_nr = ceiling(rand() * 1000000);
	if (select count(*) from booked_pass where ticket_nr = random_nr) = 0
	then
		set is_unique = true;
	end if;
	
	until is_unique = true 
	end repeat;
	
	set new.ticket_nr = random_nr;
	end if;

end //

-- #############################################################
-- #                 Set up more procedures                    #
-- #############################################################

create procedure addReservation(in dep_airport_code varchar(3), in arr_airport_code varchar(3), in year integer, in week integer,
       		 		   in day varchar(10), in dep_time time, in nr_of_pass integer, out res_nr integer)
begin
	declare route_id varchar(12) default concat(dep_airport_code,'-',arr_airport_code,'-',year);
	declare flight_nr integer;

	select flight_id into flight_nr
	from flight	
	where flight.week = week and
	      flight.schedule in(
	      select schedule_id
	      from weekly_schedule
	      where weekly_schedule.route = route_id and
	      	    weekly_schedule.day = day and
		    weekly_schedule.year = year and
		    weekly_schedule.dep_time = dep_time);

	if not (flight_nr is null) then
	   if (calculateFreeSeats(flight_nr) >= nr_of_pass) then
	      insert into reservation(flight, nr_of_pass) values (flight_nr, nr_of_pass); 
	      
	      select res_number into res_nr
	      from reservation
	      order by res_number desc limit 1;
	   else
	      select "There are not enough seats available on the chosen flight" as "Error";
	   end if;
	else
	   select "There exists no flight for the given route, date and time" as "Error";
	end if;

	
end//

create procedure addPassenger(in res_nr integer, in pass_nr integer, in pass_name varchar(60))

begin
	declare reserved integer;
	declare reserved_pass integer;
	declare actual_pass integer;
	declare payed integer;

	select res_number into reserved
	from reservation
	where res_number = res_nr;

	select count(*) into actual_pass
	from booked_pass
	where reservation_nr = res_nr;

	select nr_of_pass into reserved_pass
	from reservation
	where res_number = res_nr;

	select reservation into payed
	from booked
	where reservation = res_nr;
	
	if not (reserved is null) then
	   if (actual_pass < reserved_pass) then
	       if (payed is null) then
	       	  insert into passenger(pass_id, name) values (pass_nr, pass_name);
	      	  insert into booked_pass(pass_id, reservation_nr) values (pass_nr, res_nr);
	       else
		  select "The booking has already been payed and no futher passengers can be added" as "Error";
	       end if;
	    else
	       select "The number of reserved passengers has already been reached" as "Error";
	    end if;    
	else
	   select "The given reservation number does not exist" as "Error";
	end if;
end//

create procedure addContact(in res_nr integer, in pass_nr integer, in email varchar(30), in phone bigint)

begin
	declare con_id integer;
	declare reserved integer;

	select res_number into reserved
	from reservation
	where res_number = res_nr;
	
	if not (reserved is null) then
	   select pass_id into con_id
	   from booked_pass
	   where pass_id = pass_nr and reservation_nr = res_nr;

	   if not (con_id is null) then
	      insert into contact(contact_id, e_mail, phone) values (con_id, email, phone);  
	      update reservation set contact = con_id where res_number = res_nr;
	   else
	      select "The person is not a passenger of the reservation" as "Error";
	   end if;
	else
	   select "The given reservation number does not exist" as "Error";
	end if;
end//


create procedure addPayment(in res_nr integer, in cardholder_name varchar(60), in credit_card_number bigint)

begin
	declare flight_nr integer;
	declare reserved_pass integer;
	declare con integer;
	declare nr_pass integer;
	declare tot_price integer;
	declare reserved integer;

	select res_number into reserved
	from reservation
	where res_number = res_nr;

	if not (reserved is null) then

	   select contact, flight into con, flight_nr 
	   from reservation
	   where res_number = res_nr;

	   set reserved_pass = calculatePassengers(res_nr);
	
	   if not (con is null) then 
	      if not (calculateFreeSeats(flight_nr) < reserved_pass) then 
	      	 set tot_price = calculatePrice(flight_nr) * reserved_pass;
	      	 insert into credit_card(card_nr, holder) values (credit_card_number, cardholder_name);
	      	 insert into booked(reservation, card, total_price) values (res_nr, credit_card_number, tot_price);
	      	 update booked_pass set ticket_nr = 1 where reservation_nr = res_nr;
	      else
		 select "The payment contains more passengers than there are free seats" as "Error";
  	      end if;
	   else
	      select "The reservation has no contact yet" as "Error";
	   end if;
	else
	   select "The given reservation number does not exist" as "Error";
	end if;
end//

-- #############################################################
-- #                     End delimiter                         #
-- #############################################################

delimiter ;
