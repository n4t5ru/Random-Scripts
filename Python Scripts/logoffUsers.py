import subprocess

clientName = []

pcList = "" # Insert File location

with open(pcList, "r") as inp:
    
    for line in inp:
        clientName.append(line.strip('\n'))

for pcName in clientName:
    subprocess.call("Powershell.exe logoff 1 /SERVER:"+pcName, shell=True)