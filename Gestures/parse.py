'''
File: parse.py
Author: Pablo Moreno
---------------------------------------------------------------------------------------------------
How the script works: This script is designed to take all of the data from the letter .csv files
and put them into their correct train/test files.

Setup: In order for the script to work, please download the .csv file from the Excel Kira provided.
Then move the file into the Gestures directory and rename it to whichever lowercase letter the file
corresponds to.

This is how you should call the script:
python parse.py k

This will look for k.csv, parse the data inside it and assign the data to the correct train and test
files. This script will need to be modified for non-letter data since it removes the first 7
characters in order to accomodate for the 'k,X,Y,Z' at the beginning of each file. Additionally, at
the time of writing this, only lower-case test and train cases exist, though this script will be
able to handle capital letters once the directories are created.
'''

import sys

def main():

    letter = sys.argv[1]
    
    mainFile = letter + ".csv"
    f = open(mainFile, 'r')
    text = f.read()
    f.close()
    splitText = text.split(',,,')
    for i in range(20):
        text = splitText[i]

        # remove the first letter and x y z
        if i == 0:
            text = text[7:]

        fileName = ""
        # do train stuff first
        if i < 15:
            fileName = "train/" + letter + "/" + letter + str(i) + ".csv"

        # do test stuff second
        else:
            fileName = "test/" + letter + "/" + letter + str(i % 15) + ".csv"

        newFile = open(fileName, 'a')
        newFile.write(text)
        newFile.close()

main()
