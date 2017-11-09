-- Task 20

/*
We modified the view to also contain the quantity sold items, even those 
with a NULL-value on the sold column. This was made with a left join.
Furthermore we modified the query to show the sum of the sold items as well.
*/

create view jbsale_supply(supplier, item, delivered, sold) as 
select jbsupplier.name, jbitem.name, jbitem.qoh, jbsale.quantity
from jbsupplier, jbitem
left join jbsale
on jbitem.id = jbsale.item
where jbsupplier.id = jbitem.supplier;

select * from jbsale_supply;

select supplier, sum(delivered), sum(sold) from jbsale_supply 
group by supplier;
