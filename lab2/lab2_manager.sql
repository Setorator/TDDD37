
-- Task 3


create table jbmanager
       (id integer,
       bonus integer default null,
       
       constraint pk_manager primary key(id),
       
       constraint fk_employee foreign key(id) references jbemployee(id));

-- Insert manager id from jbemployee, excluding NULL
insert into jbmanager
select manager, null
from jbemployee
where manager in (select id from jbemployee)
group by jbemployee.manager;


-- Insert manager id from jbdept who is not already part of jbmanager, excluding NULL
insert into jbmanager
select manager, null
from jbdept
where manager not in (select id from jbmanager)
group by jbdept.manager;


-- Rearange foreign keys
alter table jbdept drop foreign key fk_dept_mgr;
alter table jbdept add constraint fk_dept_mgr foreign key (manager) references jbmanager(id) on delete set null;

alter table jbemployee drop foreign key fk_emp_mgr;
alter table jbemployee add constraint fk_emp_mgr foreign key (manager) references jbmanager(id) on delete set null;

-- select * from jbmanager;

