import csv
import subprocess

designationsdict = {}

# File should be of just two columns, column one for name or IDENTITY used as AD Login. Second Column with TITLE or Designation.
designationCSV = "" #insert file location

with open(designationCSV, "r") as inp:
    reader = csv.reader(inp)
    designationsdict = {rows[0]:rows[1] for rows in reader}

for name in designationsdict:
    subprocess.call("Powershell.exe Set-ADUser -Identity "+name+" -Title '"+designationsdict[name]+"'", shell=True)