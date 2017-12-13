-- #############################################################
-- # lab4c by Kim Larsson (kimla207) and Janos Dani (janda553) #
-- #############################################################

-- Drop constraints
alter table airport  drop foreign key fk_located_in;
alter table route drop foreign key fk_arrives_to;
alter table route drop foreign key fk_departs_from;
alter table route_price drop foreign key fk_route;
alter table route_price drop foreign key fk_route_year;
alter table weekday drop foreign key fk_weekday_year;
alter table weekly_schedule drop foreign key fk_weekly_route;
alter table weekly_schedule drop foreign key fk_day;
alter table weekly_schedule drop foreign key fk_schedule_year;
alter table contact drop foreign key fk_contact_pass;
alter table flight drop foreign key fk_flight_schedule;
alter table flight drop foreign key fk_plane;
alter table reservation drop foreign key fk_responsible;
alter table reservation drop foreign key fk_flight;
alter table reserved_pass drop foreign key fk_passenger;
alter table reserved_pass drop foreign key fk_res_nr;
alter table booked drop foreign key fk_booked_res;
alter table booked drop foreign key fk_credit_card;

-- Drop tables
drop table city;
drop table airport;
drop table route;
drop table year;
drop table route_price;
drop table weekday;
drop table passenger;
drop table weekly_schedule;
drop table plane;
drop table contact;
drop table flight;
drop table reservation;
drop table credit_card;
drop table reserved_pass;
drop table booked;


-- #############################################################
-- ################## Create tables here #######################
-- #############################################################

-- Create table city 
create table city(
       city_id integer not null,
       name varchar(30) not null,

       constraint pk_city primary key(city_id));

-- Create table airport 
create table airport(
       airport_id integer not null,
       city integer not null,

       constraint pk_airport primary key(airport_id));

-- Create table routedef 
create table route(
       route_id integer not null,
       arr_to integer not null,
       dep_from integer not null,

       constraint pk_route primary key(route_id));

-- Create table year 
create table year(
       year integer not null,
       profit double not null,

       constraint pk_year primary key(year));

-- Create table route_price 
create table route_price(
       route integer not null,
       year integer not null,
       profit double not null,

       constraint pk_route_price primary key(route),
       constraint pk_route_price primary key(year));

-- Create table weekday 
create table weekday(
       day varchar(10) not null,
       year integer not null,
       profit double not null,

       constraint pk_weekday primary key(day),
       constraint pk_weekday primary key(year));

-- Create table passenger 
create table passenger(
       pass_id integer not null,
       first_name varchar(30) not null,
       last_name varchar(30) not null,

       constraint pk_passenger primary key(pass_id));

-- Create table weekly_schedule 
create table weekly_schedule(
       schedule_id integer not null,
       route integer not null,
       dep_time timestamp not null,
       day varchar(10) not null,
       year integer not null,

       constraint pk_weekly_schedule primary key(schedule_id));

-- Create table plane 
create table plane(
       plane_id integer not null,
       seats integer not null,

       constraint pk_plane primary key(plane_id));

-- Create table contact 
create table contact(
       contact_id integer not null,
       e_mail varchar(30) not null,
       phone bigint not null,

       constraint pk_contact primary key(contact_id));

-- Create table flight 
create table flight(
       flight_id integer not null,
       schedule integer not null,
       plane integer not null,
       week integer not null,  

       constraint pk_flight primary key(flight_id));

-- Create table reservation 
create table reservation(
       res_number integer not null,
       contact integer not null,
       flight integer not null,

       constraint pk_reservation primary key(res_number));

-- Create table credit_card 
create table credit_card(
       card_nr integer not null,
       holder varchar(60) not null, -- First name + last name = 30 + 30 

       constraint pk_credit_card primary key(card_nr));

-- Create table reserved_pass 
create table reserved_pass(
       pass_id integer not null,
       reservation_nr integer not null,
       ticket_nr integer not null,

       constraint pk_reserved_pass primary key(pass_id));

-- Create table booked 
create table booked(
       reservation integer not null,
       card integer not null,
       total_price double not null,       
       
       constraint pk_booked primary key(reservation));

-- #############################################################
-- ################## Set up foreign keys ######################
-- #############################################################


alter table airport  add constraint fk_located_in foreign key (city) references city(city_id);
alter table route add constraint fk_arrives_to foreign key (arr_to) references airport(airport_id);
alter table route add constraint fk_departs_from foreign key (dep_from) references airport(airport_id);
alter table route_price add constraint fk_route foreign key (route) references route(route_id);
alter table route_price add constraint fk_route_year foreign key (year) references year(year);
alter table weekday add constraint fk_weekday_year foreign key (year) references year(year);
alter table weekly_schedule add constraint fk_weekly_route foreign key (route) references route(route_id);
alter table weekly_schedule add constraint fk_day foreign key (day) references weekday(day);
alter table weekly_schedule add constraint fk_schedule_year foreign key (year) references weekday(year);
alter table contact add constraint fk_contact_pass foreign key (contact_id) references passenger(pass_id);
alter table flight add constraint fk_flight_schedule foreign key (schedule) references weekly_schedule(schedule_id);
alter table flight add constraint fk_plane foreign key (plane) references plane(plane_id);
alter table reservation add constraint fk_responsible foreign key (contact) references contact(contact_id);
alter table reservation add constraint fk_flight foreign key (flight) references flight(flight_id);
alter table reserved_pass add constraint fk_passenger foreign key (pass_id) references passenger(pass_id);
alter table reserved_pass add constraint fk_res_nr foreign key (reservation_nr) references reservation(res_number);
alter table booked add constraint fk_booked_res foreign key (reservation) references reservation(res_number);
alter table booked add constraint fk_credit_card foreign key (card) references credit_card(card_nr);


-- #############################################################
-- ################## Set up procedures ########################
-- #############################################################

delimiter //

create procedure addYear(in year integer, in factor double)
begin

end//

create procedure addDay(in year integer, in day varchar(10), in factor double)
begin

end//

create procedure addDestination(in airport_id integer, in city_id integer)
begin

end//

create procedure addYear(in year integer, in factor double)
begin

end//

create procedure addYear(in year integer, in factor double)
begin

end//



delimiter ;
