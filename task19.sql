
-- Task 19

-- ## Explanation ##
-- We start of with identify all the constraints (foreign keys) that prevents us from removing the suppliers 
-- from jbsupplier. 
-- This can be done by the query:  
-- mysql> select *  from INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'FOREIGN KEY';
-- An analyze of the resulting table gives us a chain that goes as follows: 
-- jbsale -> (fk_sale_item) -> jbitem -> (fk_item_supplier) -> jbsupplier.
-- Now we need to remove the entries associated with the "deepest" constraints, i.e. entries from jbsale.
-- After that we continue by removing the entries in jbitem and finally the entries from jbsupplier.
-- NOTICE: we created a table in task14 that has a foreign key associated with jbsupplier, therefore we 
-- need to remove entries from this table. We have commented out this in this file since we didn't know if 
-- the assistant has a task14-table created. If so, just uncomment the corresponding lines.

delete from jbsale
where item in
(select id from jbitem where supplier in 
(select id from jbsupplier where city in 
(select id from jbcity where name = "Los Angeles")));       

delete from jbitem
where supplier in 
(select id from jbsupplier where city in 
(select id from jbcity where name = "Los Angeles"));       

-- ################
-- Removes the entries in the task14-table 
-- ################
-- delete from task14
-- where supplier in 
-- (select id from jbsupplier where city in 
-- (select id from jbcity where name = "Los Angeles"));

delete from jbsupplier
where city in 
(select id from jbcity where name = "Los Angeles");
