-- -------------------
-- Task 14
-- -------------------


create table task14 (
       id integer,
       name varchar(50),
       dept integer,
       price integer,
       qoh integer,
       supplier integer,

       constraint pk_id_item
       		  primary key (id),
	constraint fk_on_shelf
		   foreign key (dept) references jbdept(id),	   
	constraint fk_deliver
		   foreign key (supplier) references jbsupplier(id));

insert into task14 select * from jbitem where price < (select avg(price) from jbitem);

select * from task14;
