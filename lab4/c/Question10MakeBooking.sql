/******************************************************************************************
 Question 10, concurrency
 This is the second of two scripts that tests that the BryanAir database can handle concurrency.
 This script sets up a valid reservation and tries to pay for it in such a way that at most 
 one such booking should be possible (or the plane will run out of seats). This script should 
 be run in both terminals, in parallel. 
**********************************************************************************************/
SELECT "Testing script for Question 10, Adds a booking, should be run in both terminals" as "Message";
SELECT "Adding a reservations and passengers" as "Message";
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",21,@a); 
CALL addPassenger(@a,00000031,"Saruman");
CALL addPassenger(@a,00000032,"Orch1");
CALL addPassenger(@a,00000033,"Orch2");
CALL addPassenger(@a,00000034,"Orch3");
CALL addPassenger(@a,00000035,"Orch4");
CALL addPassenger(@a,00000036,"Orch5");
CALL addPassenger(@a,00000037,"Orch6");
CALL addPassenger(@a,00000038,"Orch7");
CALL addPassenger(@a,00000039,"Orch8");
CALL addPassenger(@a,00000040,"Orch9");
CALL addPassenger(@a,00000041,"Orch10");
CALL addPassenger(@a,00000042,"Orch11");
CALL addPassenger(@a,00000043,"Orch12");
CALL addPassenger(@a,00000044,"Orch13");
CALL addPassenger(@a,00000045,"Orch14");
CALL addPassenger(@a,00000046,"Orch15");
CALL addPassenger(@a,00000047,"Orch16");
CALL addPassenger(@a,00000048,"Orch17");
CALL addPassenger(@a,00000049,"Orch18");
CALL addPassenger(@a,00000050,"Orch19");
CALL addPassenger(@a,00000051,"Orch20");
CALL addContact(@a,00000031,"saruman@magic.mail",080667989); 
SELECT SLEEP(5);
SELECT "Making payment, supposed to work for one session and be denied for the other" as "Message";

lock tables allFlights read, credit_card read;
CALL addPayment (@a, "Sauron",7878787879);
unlock tables;

SELECT "Nr of free seats on the flight (should be 19 if no overbooking occured, otherwise -2): " as "Message", (SELECT nr_of_free_seats from allFlights where departure_week = 1) as "nr_of_free_seats";

  


