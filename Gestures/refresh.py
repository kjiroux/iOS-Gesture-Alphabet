'''
File: refresh.py
Author: Pablo Moreno
---------------------------------------------------------------------------------------------------
How the script works: Restores any letter's files.

How to run:
python refresh.py c

This will restore all of the files for c.
'''

import sys

def main():

    letter = sys.argv[1]
    
    for i in range(20):

        text = letter + ",X,Y,Z"

        fileName = ""
        # do train stuff first
        if i < 15:
            fileName = "train/" + letter + "/" + letter + str(i) + ".csv"

        # do test stuff second
        else:
            fileName = "test/" + letter + "/" + letter + str(i % 15) + ".csv"

        newFile = open(fileName, 'w')
        newFile.write(text)
        newFile.close()

main()
