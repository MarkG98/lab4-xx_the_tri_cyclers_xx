import csv
import sys

def memcheck():
    """
        This function reads csv file dumps of the register and memory contents
        and makes sure that appropriate adresses contain what they are supposed
        to. To use this file, you pass in arguments as seen below.

        Ex: python memchecker regmem 1,21 2,35 datamem 2048,5

        The above running of this script checks for register 1 to have value 21,
        register 2 to have value 35 and for data memory location 2048 to have
        value 5.
    """
    datamem = list()
    regmem = list()

    if len(sys.argv) != 1:
        params = sys.argv[1:]
    else:
        return

    tests_passed = 1

    with open('datamem.csv','r') as csvFile:
        reader = csv.reader(csvFile)
        for row in reader:
            datamem.append(row[0].strip())
        #datamem = [item.strip() for item in datamem]

    with open('regmem.csv','r') as csvFile:
        reader = csv.reader(csvFile)
        for row in reader:
            regmem.append(row[0].strip())
        #regmem = [item.strip() for item in regmem]

    mode = ''
    for item in params:
        if item == 'datamem' or item == 'regmem':
            mode = item
            continue
        else:
            check = item.split(",")
            check = [int(i) for i in check]

            if mode == 'datamem':
                if int(datamem[check[0]]) == check[1]:
                    print("Data at " + str(check[0]) + " has value " + str(check[1]) + "\n")
                else:
                    print("Data memory at location " + str(check[0]) + " has " + str(int(str(datamem[check[0]]),2)) + " not " + str(int(str(check[1]),2)))
                    tests_passed = 0
            if mode == 'regmem':
                if int(regmem[check[0]]) == check[1]:
                    print("Reg " + str(check[0]) + " has value " + str(check[1]) + "\n")
                else:
                    print("Register memory at location " + str(check[0]) + " has " + str(regmem[check[0]]) + " not " + str(check[1]))
                    tests_passed = 0

    if tests_passed == 1:
        print("ALL VALUES AS EXPECTED")
    else:
        print("FAILED")

if __name__ == "__main__":
    memcheck()
