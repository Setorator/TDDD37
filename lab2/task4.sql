

update jbmanager
set bonus = bonus + 10000
where id in (select manager from jbdept);

