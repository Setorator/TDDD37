
import mysql.connector


cnx = mysql.connector.connect(user = 'kimla207', password='______________________', host='db-und.ida.liu.se', database='company_schema.sql')

cursor = cnx.cursor()

query = ("select * from jbemployee")

cursor.execute(query)

for line in cursor:
  print(line)
  
  
cursor.close()
cnx.close()
