from os import mkdir
from string import ascii_uppercase

for letter in ascii_uppercase:
    trainFileDir = "train/capital" + letter + "/"
    testFileDir = "test/capital" + letter + "/"
    mkdir(trainFileDir)
    mkdir(testFileDir)
    for i in range(15):
        trainFileName = trainFileDir + letter + str(i) + ".csv"
        trainFile = open(trainFileName, "w")
        trainFile.write(letter + ",X,Y,Z")
        trainFile.close()
    for j in range(5):
        testFileName = testFileDir + letter + str(j) + ".csv"
        testFile = open(testFileName, "w")
        testFile.write(letter + ",X,Y,Z")
        testFile.close()
