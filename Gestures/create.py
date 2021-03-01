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
        trainFile.write("{0},X,Y,Z".format(letter))
        trainFile.close()
        print(trainFileName)
    for j in range(5):
        testFileName = testFileDir + letter + str(i) + ".csv"
        testFile = open(trainFileName, "w")
        testFile.write("{0},X,Y,Z".format(letter))
        testFile.close()
