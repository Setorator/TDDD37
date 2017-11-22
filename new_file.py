#!/usr/bin/env python3

import os

name = str(input("Please enter name of file: "))
text= "# "+name+" by Kim Larsson (kimla207) and Janos Dani (janda553) #"
file_name = name+".txt"
line="#"*len(text)
top_text=line+"\n"+text+"\n"+line+"\n"

f = (file_name, "a")

with open(file_name, 'w') as file:
    file.write(top_text)
