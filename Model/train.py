#!/usr/bin/env python
# -*- coding: utf-8 -*-


import re
from functools import reduce
import sqlite3
import os
from keras.preprocessing import text as kt
from keras import utils as ku
from keras import models as km
from keras import layers as kl
from nltk import ngrams
import numpy as np
from coremltools.converters import keras as kc

textFile = "Scraper/Data/Mini-Corpus.txt"
textCorpus = re.sub(r"[/:$%^&*(){}]", "", unicode(open(textFile, "r").read(), "utf-8")).replace(" -- ", " ").replace("-", " ").replace(", ", " , ").replace(". ", " .  .  ").replace("? ", " ?  ?  ").replace("! ", " !  !  ").replace("2015", "2019").replace("2016", "2019").replace("2017", "2019").replace("2018", "2019").lower().replace("ios 12", "ios 13").replace("ios 11", "ios 13").replace("ios 10", "ios 13").replace("ios 9", "ios 13").replace("mojave", "sonoma").replace("high sierra", "sonoma").replace("sierra", "sonoma").replace("el capitan", "sonoma")

def ngramCreate(wordList, ngramSize):

    if len(wordList) <= ngramSize:
        if len(wordList) >= 2:
            return [wordList]
        else:
            return [[]]
    else:
        return ngrams(wordList, ngramSize)

ngramSize = 9
ngramCorpus = [" ".join(b) for a in list(map(lambda c: ngramCreate(c.split(" "), ngramSize), re.split("  .  |  ?  |  !  ", textCorpus))) for b in a]

tokeniserObject = kt.Tokenizer(filters = '"#$%&()*+/:;<=>[\\]^_`{|}~\t\n')
tokeniserObject.fit_on_texts(ngramCorpus)
tokenisedCorpus = tokeniserObject.texts_to_sequences(ngramCorpus)
tokenisedVocabulary = len(tokeniserObject.word_index) + 1

def generateDatabase(databaseName, wordIndex):

    for eachFile in os.listdir("Model/"):
        if eachFile == databaseName:
            os.remove("Model/" + eachFile)

    databaseConnection = sqlite3.connect("Model/" + databaseName)
    databaseCursor = databaseConnection.cursor()

    databaseCursor.execute("CREATE TABLE Lookup (token integer PRIMARY KEY, value text NOT NULL);")

    for eachValue, eachToken in wordIndex.items():
        try:
            databaseCursor.execute("INSERT INTO Lookup (token, value) VALUES (?, ?);", (eachToken, eachValue))
        except:
            print("Skipping: " + str(eachValue))

    databaseConnection.commit()
    databaseConnection.close()

    print "✔︎ Generated SQLite Database with " + str(len(wordIndex) + 1) + " Entries"

generateDatabase("Tokenised.sqlite", tokeniserObject.word_index)

if max(list(map(lambda a: len(a), tokenisedCorpus))) > ngramSize:

    print("Error: Irregular token length -> Probably due to filtered symbol.")
    # tokenisedCorpus = list(filter(lambda a: len(a) <= ngramSize, tokenisedCorpus))

# Add check here to clean the tokenisedCorpus better

tokenisedCorpus = list(filter(lambda a: len(a) <= ngramSize and len(a) >= 2, tokenisedCorpus))

modelTrain, modelPredict = zip(*list(map(lambda a: ([0] * (ngramSize - len(a)) + a[:-1], a[-1]), tokenisedCorpus)))

modelTrain = np.array(modelTrain)
modelPredict = ku.to_categorical(np.array(modelPredict), num_classes = tokenisedVocabulary)

sequentialModel = km.Sequential([
    kl.Embedding(tokenisedVocabulary, 128, input_length = ngramSize - 1),
    kl.SpatialDropout1D(rate = 0.2),
    kl.LSTM(128, dropout = 0.2),
    kl.Dense(128, activation = "relu"),
    kl.Dense(tokenisedVocabulary, activation = "softmax")
])

sequentialModel.compile(loss = "categorical_crossentropy", optimizer = "adam", metrics=["accuracy"])

epochCount = 300
checkPoint = 3

for i in range(0, int(epochCount / checkPoint)):

    if i > 0:
        sequentialModel = km.load_model("Model/Checkpoints/Keras-CKPT-" + str(i) + "-" + str(int(epochCount / checkPoint)) + ".h5")

    print ""
    print "- Starting " + str((i + 1)) + " of " + str(int(epochCount / checkPoint))

    sequentialModel.fit(modelTrain, modelPredict, batch_size = 512, initial_epoch = i * checkPoint, epochs = (i + 1) * checkPoint)
    modelName = "CKPT-" + str(i + 1) + "-" + str(int(epochCount / checkPoint))
    sequentialModel.save("Model/Checkpoints/Keras-" + modelName + ".h5")
    coreConvert = kc.convert(sequentialModel)
    coreConvert.save("Model/Checkpoints/Core-" + modelName + ".mlmodel")

    print "✔︎ Checkpoint " + str(i + 1) + " of " + str(int(epochCount / checkPoint))
    print ""
