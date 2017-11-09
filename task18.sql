
-- Task 18

create view joined_debit_view as  
   select jbdebit.id, sum(quantity*price) as total
   from jbdebit left join (jbsale left join jbitem on jbsale.item = jbitem.id) on jbdebit.id = jbsale.debit
   group by jbdebit.id;
