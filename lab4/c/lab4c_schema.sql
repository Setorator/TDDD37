-- #############################################################
-- # lab4c by Kim Larsson (kimla207) and Janos Dani (janda553) #
-- #############################################################

-- Drop constraints
alter table booked drop foreign key fk_credit_card;
alter table booked drop foreign key fk_booked_res;
alter table booked_pass drop foreign key fk_res_nr;
alter table booked_pass drop foreign key fk_passenger;
alter table contact drop foreign key fk_contact_pass;
alter table reservation drop foreign key fk_flight;
alter table reservation drop foreign key fk_resp;
alter table flight drop foreign key fk_flight_schedule;
alter table weekly_schedule drop foreign key fk_weekly_route;
alter table weekly_schedule drop foreign key fk_day;
alter table weekly_schedule drop foreign key fk_schedule_year;
alter table weekday drop foreign key fk_weekday_year;
alter table route drop foreign key fk_arrives_to;
alter table route drop foreign key fk_departs_from;

-- Drop tables
drop table airport;
drop table route;
drop table year;
drop table weekday;
drop table passenger;
drop table weekly_schedule;
drop table contact;
drop table flight;
drop table reservation;
drop table credit_card;
drop table booked_pass;
drop table booked;

-- #############################################################
-- ################## Create tables here #######################
-- #############################################################

-- Create table airport 
create table airport(
       airport_code varchar(3) not null,
       name varchar(30) not null,
       country varchar(30) not null,

       constraint pk_airport primary key(airport_code));

-- Create table route 
create table route(
       route_id varchar(12) not null,
       year integer not null,
       arr_to varchar(3) not null,
       dep_from varchar(3) not null,
       route_price double not null,
      
       constraint pk_route primary key(route_id));

-- Create table year 
create table year(
       year integer not null,
       profit double not null,

       constraint pk_year primary key(year));

-- Create table weekday 
create table weekday(
       day varchar(10) not null,
       year integer not null,
       profit double not null,

       constraint pk_weekday primary key(day, year));

-- Create table passenger 
create table passenger(
       pass_id integer not null,
       name varchar(60) not null,
       
       constraint pk_passenger primary key(pass_id));

-- Create table weekly_schedule 
create table weekly_schedule(
       schedule_id integer not null auto_increment,
       route varchar(12) not null,
       dep_time timestamp not null,
       day varchar(10) not null,
       year integer not null,

       constraint pk_weekly_schedule primary key(schedule_id));

-- Create table contact 
create table contact(
       contact_id integer not null,
       e_mail varchar(30) not null,
       phone bigint not null,

       constraint pk_contact primary key(contact_id));

-- Create table flight 
create table flight(
       flight_id integer not null auto_increment,
       schedule integer not null,
       week integer not null,  

       constraint pk_flight primary key(flight_id));

-- Create table reservation 
create table reservation(
       res_number integer not null auto_increment,
       contact integer,
       flight integer not null,
       nr_of_pass integer not null,

       constraint pk_reservation primary key(res_number));

-- Create table credit_card 
create table credit_card(
       card_nr integer not null,
       holder varchar(60) not null, -- First name + last name = 30 + 30 

       constraint pk_credit_card primary key(card_nr));

-- Create table booked_pass 
create table booked_pass(
       pass_id integer not null,
       reservation_nr integer not null,
       ticket_nr integer not null,

       constraint pk_booked_pass primary key(pass_id));

-- Create table booked 
create table booked(
       reservation integer not null,
       card integer not null,
       total_price double not null,       
       
       constraint pk_booked primary key(reservation));

-- #############################################################
-- ################## Set up foreign keys ######################
-- #############################################################


alter table route add constraint fk_arrives_to foreign key (arr_to) references airport(airport_code);
alter table route add constraint fk_departs_from foreign key (dep_from) references airport(airport_code);
alter table route add constraint fk_route_year foreign key (year) references year(year);
alter table weekday add constraint fk_weekday_year foreign key (year) references year(year);
alter table weekly_schedule add constraint fk_weekly_route foreign key (route) references route(route_id);
alter table weekly_schedule add constraint fk_day foreign key (day) references weekday(day);
alter table weekly_schedule add constraint fk_schedule_year foreign key (year) references weekday(year);
alter table flight add constraint fk_flight_schedule foreign key (schedule) references weekly_schedule(schedule_id);
alter table reservation add constraint fk_resp foreign key (contact) references contact(contact_id);
alter table reservation add constraint fk_flight foreign key (flight) references flight(flight_id);
alter table contact add constraint fk_contact_pass foreign key (contact_id) references passenger(pass_id);
alter table booked_pass add constraint fk_passenger foreign key (pass_id) references passenger(pass_id);
alter table booked_pass add constraint fk_res_nr foreign key (reservation_nr) references reservation(res_number);
alter table booked add constraint fk_booked_res foreign key (reservation) references reservation(res_number);
alter table booked add constraint fk_credit_card foreign key (card) references credit_card(card_nr);





