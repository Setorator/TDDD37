

-- Update bonus for department managers to the earlier value plus 10 000
update jbmanager
set bonus = bonus + 10000
where id in (select manager from jbdept);

select * from jbmanager;

/*
###########################
# Results of the commands #
###########################

mysql> source task4.sql;
Query OK, 11 rows affected (0.00 sec)
Rows matched: 11  Changed: 11  Warnings: 0

+-----+-------+
| id  | bonus |
+-----+-------+
|  10 | 10000 |
|  13 | 10000 |
|  26 | 10000 |
|  32 | 10000 |
|  33 | 10000 |
|  35 | 10000 |
|  37 | 10000 |
|  55 | 10000 |
|  98 | 10000 |
| 129 | 10000 |
| 157 | 10000 |
| 199 |     0 |
+-----+-------+
12 rows in set (0.00 sec)



*/

