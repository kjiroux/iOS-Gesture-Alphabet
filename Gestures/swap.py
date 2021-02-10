'''
File: swap.py
Author: Pablo Moreno
---------------------------------------------------------------------------------------------------
How the script works: This script is used to move 5 test files to training files. This is because
when testing our machine learning model we determined that we should have more training files and
less testing files.

How to call the script:
python swap.py

Note: Since the files have already been swapped, this script will not likely be very useful, but
may be used as a model in the future if a reverse swap script is necessary.
'''

from string import ascii_lowercase
import os

def main():

    for c in ascii_lowercase:
        testFileDir = "test/" + c + "/"
        trainFileDir = "train/" + c + "/"
        for i in range (5):
            testFileName = testFileDir + c + str(i + 5) + ".csv"
            trainFileName = trainFileDir + c + str(i + 10) + ".csv"
            testFile = open(testFileName, "r")
            testFileContents = testFile.read()
            testFile.close()
            os.remove(testFileName)
            trainFile = open(trainFileName, "w")
            trainFile.write(testFileContents)
            trainFile.close()

main()
