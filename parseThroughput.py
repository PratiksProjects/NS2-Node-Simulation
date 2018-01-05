# run by typing "python parseThroughput.python filename"
# you can tunnel the output into a file by using ">> output.txt" after filename
import sys
import csv

final1 = []
final2 = []
throughPuts1 = []
throughPuts2 = []
flow1 = True
fname = sys.argv[1]

with open(fname , 'r') as f:
    for line in f.readlines()[1:]:
        if ':' in line:
            line = line.split(':')[1].strip()
            if flow1:
                flow1 = False
                throughPuts1.append(int(line))
            else:
                flow1 = True
                throughPuts2.append(int(line))
        else:
            avg1 = float(sum(throughPuts1)/len(throughPuts1))
            avg2 = float(sum(throughPuts2)/len(throughPuts2))
            final1.append(avg1)
            final2.append(avg2)
            throughPuts1 = []
            throughP2 = []
avg1 = float(sum(throughPuts1)/len(throughPuts1))
avg2 = float(sum(throughPuts2)/len(throughPuts2))
final1.append(avg1)
final2.append(avg2)
           
print("The average throughputs of Flow 1 for " + "are: ")
print(final1)
print("\n")
print("The average throughput of Flow 2 for " + "" + "are: ")
print(final2)