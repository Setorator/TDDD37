
-- Task 3


create table jbmanager
       (id int,
       bonus int,
       
       constraint pk-manager primary key(id),
       
       constraint fk_employee foreign key(id) references jbemployee(id));

alter table jbemployee drop constraint fk_dept_mgr;
alter table jbemployee add constraint fk_dept_mgr foreign key (manager) references jbmanager(id) on delete set null;

alter table jbemployee add constraint fk_dept_mgr foreign key (manager) references jbmanager(id) on delete set null;
