import csv
import subprocess

designationsdict = {}

# File should be of just two columns, column one for name or IDENTITY used as AD Login. Second Column with TITLE or Designation.
importFile = "" #insert file location

with open(importFile, "r") as inp:
    reader = csv.reader(inp)
    importFile = {rows[0]:rows[1] for rows in reader}

for name in importFile:
    #change title/designation of the User
    subprocess.call("Powershell.exe Set-ADUser -Identity "+name+" -Title '"+importFile[name]+"'", shell=True)

    #change email address of the user
    subprocess.call("Powershell.exe Set-ADUser -Identity "+name+" -EmailAddress '"+importFile[name]+"'", shell=True)
