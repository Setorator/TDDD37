-- -------------------
-- Task 5
-- -------------------


-- Creating tables with respectiv primary keys
create table jbtransaction (
       id integer,
       tstamp timestamp not null default current_timestamp,
       amount integer not null default 0,
       type varchar(10),
       account integer not null,
       employee integer not null,

       constraint pk_transaction primary key(id));

create table jbaccount (
       accnr integer not null,
       balance integer not null default 0,
       owner varchar(30),

       constraint pk_account primary key(accnr));

create table jbcustomer (
       name varchar(30),
       address varchar(30),
       city integer,
       state varchar(6),

       constraint pk_customer primary key(name, address));



-- Adding respective constraint 
alter table jbcustomer add constraint fk_lives_in foreign key (city) references jbcity(id);

alter table jbaccount add constraint fk_owns_by foreign key (owner) references jbcustomer(name);

alter table jbtransaction add constraint fk_responsible foreign key (employee) references jbemployee(id);
alter table jbtransaction add constraint fk_from_account foreign key (account) references jbaccount(accnr);


-- Insert customers into jbcustomer with correct states.
insert into jbcustomer (name, address, city)
values ('Olle Einarson', 'Duck street 1', 10),
       ('Santa Claus', 'Duck street 2', 21),
       ('Elin Siiiiik', 'Duck street 3', 100),
       ('Jonas Doni', 'Duck street 4', 106),
       ('Cam Larsen', 'Duck street 5', 118),
       ('Olle Andersen', 'Duck street 6', 303),
       ('Esci Mo', 'Duck street 7', 537),
       ('Swe Den', 'Duck street 8', 609),
       ('Mark Den', 'Duck street 9', 752),
       ('Nor Den', 'Duck street 10', 802),
       ('En Ris', 'Duck street 11', 841),
       ('Brakf Is', 'Duck street 12', 900),
       ('Linux Mint', 'Duck street 13', 921),
       ('John Doe', 'Duck street 14', 981); 

update jbcustomer, jbcity
       set jbcustomer.state = jbcity.state 
       where jbcustomer.city = jbcity.id; 


-- Insert account data into jbaccount with fixed owners
insert into jbaccount (accnr, balance, owner)
values (10000000, 201365, 'Jonas Doni'),
       (11652133, 1452354, 'Jonas Doni'),
       (12591815, 784623, 'Cam Larsen'),
       (14096831, 1000000, 'Linux Mint'),
       (14356540, 1452354, 'Jonas Doni');


-- Insert data from jbdebit into transaction and derive 'amount' value.
insert into jbtransaction (id, tstamp, employee, account) (select * from jbdebit);

update jbtransaction, jbsale, jbitem
       set jbtransaction.amount = (jbsale.quantity * jbitem.price), jbtransaction.type = 'debit'
       where (jbtransaction.id = jbsale.debit) and (jbsale.item = jbitem.id);


-- The constraints for jbsale need to be created after the insertion of data into jbtranslation
-- since there already is data in jbsale that the constraint need to support
alter table jbsale drop foreign key fk_sale_debit;
alter table jbsale add constraint fk_sale_transaction foreign key (debit) references jbtransaction(id);
 


select * from jbcustomer;
select * from jbaccount;
select * from jbtransaction;



/*
###########################
# Results of the commands #
###########################


mysql> source task5.sql;
Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.01 sec)

Query OK, 0 rows affected (0.02 sec)

Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0

Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0

Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0

Query OK, 14 rows affected (0.01 sec)
Records: 14  Duplicates: 0  Warnings: 0

Query OK, 14 rows affected (0.00 sec)
Rows matched: 14  Changed: 14  Warnings: 0

Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

Query OK, 6 rows affected (0.00 sec)
Records: 6  Duplicates: 0  Warnings: 0

Query OK, 6 rows affected (0.00 sec)
Rows matched: 6  Changed: 6  Warnings: 0

Query OK, 8 rows affected (0.03 sec)
Records: 8  Duplicates: 0  Warnings: 0

Query OK, 8 rows affected (0.02 sec)
Records: 8  Duplicates: 0  Warnings: 0

+---------------+----------------+------+-------+
| name          | address        | city | state |
+---------------+----------------+------+-------+
| Brakf Is      | Duck street 12 |  900 | Calif |
| Cam Larsen    | Duck street 5  |  118 | Okla  |
| Elin Siiiiik  | Duck street 3  |  100 | NY    |
| En Ris        | Duck street 11 |  841 | Utah  |
| Esci Mo       | Duck street 7  |  537 | Wisc  |
| John Doe      | Duck street 14 |  981 | Wash  |
| Jonas Doni    | Duck street 4  |  106 | Neb   |
| Linux Mint    | Duck street 13 |  921 | Calif |
| Mark Den      | Duck street 9  |  752 | Tex   |
| Nor Den       | Duck street 10 |  802 | Colo  |
| Olle Andersen | Duck street 6  |  303 | Ga    |
| Olle Einarson | Duck street 1  |   10 | Mass  |
| Santa Claus   | Duck street 2  |   21 | Mass  |
| Swe Den       | Duck street 8  |  609 | Ill   |
+---------------+----------------+------+-------+
14 rows in set (0.01 sec)

+----------+---------+------------+
| accnr    | balance | owner      |
+----------+---------+------------+
| 10000000 |  201365 | Jonas Doni |
| 11652133 | 1452354 | Jonas Doni |
| 12591815 |  784623 | Cam Larsen |
| 14096831 | 1000000 | Linux Mint |
| 14356540 | 1452354 | Jonas Doni |
+----------+---------+------------+
5 rows in set (0.00 sec)

+--------+---------------------+--------+-------+----------+----------+
| id     | tstamp              | amount | type  | account  | employee |
+--------+---------------------+--------+-------+----------+----------+
| 100581 | 1995-01-15 12:06:03 |   1250 | debit | 10000000 |      157 |
| 100582 | 1995-01-15 17:34:27 |   1000 | debit | 14356540 |     1110 |
| 100586 | 1995-01-16 13:53:55 |    396 | debit | 14096831 |       35 |
| 100592 | 1995-01-17 09:35:23 |    650 | debit | 10000000 |      129 |
| 100593 | 1995-01-18 12:34:56 |    430 | debit | 11652133 |       35 |
| 100594 | 1995-01-18 10:10:10 |   3295 | debit | 12591815 |      215 |
+--------+---------------------+--------+-------+----------+----------+
6 rows in set (0.00 sec)



*/

