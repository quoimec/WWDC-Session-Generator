#!/usr/bin/env python
# -*- coding: utf-8 -*-


import re
from functools import reduce
import json
from keras.preprocessing import text as kt
from keras import utils as ku
from keras import models as km
from keras import layers as kl
from nltk import ngrams
import numpy as np
from coremltools.converters import keras as kc

textCorpus = re.sub(r"[/:$%^&*(){}]", "", open("Model/Mini-Corpus.txt", "r").read()).replace(" -- ", " ").replace("-", " ").replace(", ", " , ").replace(". ", " .  .  ").replace("? ", " ?  ?  ").replace("! ", " !  !  ").replace("2015", "2019").replace("2016", "2019").replace("2017", "2019").replace("2018", "2019").lower()

def ngramCreate(wordList, ngramSize):

    if len(wordList) <= ngramSize:
        if len(wordList) >= 2:
            return [wordList]
        else:
            return [[]]
    else:
        return ngrams(wordList, ngramSize)

ngramSize = 7
ngramCorpus = [" ".join(b) for a in list(map(lambda c: ngramCreate(c.split(" "), ngramSize), re.split("  .  |  ?  |  !  ", textCorpus))) for b in a]

tokeniserObject = kt.Tokenizer(filters = '"#$%&()*+/:;<=>[\\]^_`{|}~\t\n')
tokeniserObject.fit_on_texts(ngramCorpus)
tokenisedCorpus = tokeniserObject.texts_to_sequences(ngramCorpus)
tokenisedVocabulary = len(tokeniserObject.word_index) + 1

json.dump(tokeniserObject.word_index, open("Model/word_index.json", "w"))

if max(list(map(lambda a: len(a), tokenisedCorpus))) > ngramSize:
    raise Exception("Error: Irregular token length -> Probably due to filtered symbol.")

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

epochCount = 100
checkPoint = 10

for i in range(0, int(epochCount / checkPoint)):

    if i > 0:
        sequentialModel = km.load_model("Model/Checkpoints/Keras-CKPT-" + str(i + 1) + "-" + str(int(epochCount / checkPoint)) + ".h5")

    print ""
    print "- Starting " + str((i + 1)) + " of " + str(int(epochCount / checkPoint))

    sequentialModel.fit(modelTrain, modelPredict, batch_size = 512, initial_epoch = i * checkPoint, epochs = (i + 1) * checkPoint)
    modelName = "CKPT-" + str(i + 1) + "-" + str(int(epochCount / checkPoint))
    sequentialModel.save("Model/Checkpoints/Keras-" + modelName + ".h5")
    coreConvert = kc.convert(sequentialModel)
    coreConvert.save("Model/Checkpoints/Core-" + modelName + ".mlmodel")

    print "✔︎ Checkpoint " + str(i + 1) + " of " + str(int(epochCount / checkPoint))
    print ""
