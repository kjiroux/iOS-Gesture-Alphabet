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
