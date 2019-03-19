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
        sequentialModel = km.load_model("Model/Checkpoints/Keras-CKPT-" + str((checkPoint * (i - 1)) + 1) + "-" + str(int(epochCount / checkPoint)) + ".h5")

    print ""
    print "- Starting " + str((i + 1)) + " of " + str(int(epochCount / checkPoint))

    sequentialModel.fit(modelTrain, modelPredict, batch_size = 512, initial_epoch = i * checkPoint, epochs = (i + 1) * checkPoint)
    modelName = "CKPT-" + str((checkPoint * i) + 1) + "-" + str(int(epochCount / checkPoint))
    sequentialModel.save("Model/Checkpoints/Keras-" + modelName + ".h5")
    coreConvert = kc.convert(sequentialModel)
    coreConvert.save("Model/Checkpoints/Core-" + modelName + ".mlmodel")

    print "✔︎ Checkpoint " + str((i + 1)) + " of " + str(int(epochCount / checkPoint))
    print ""


















#
# splitInput = []
# splitOutput = []
#
# for eachToken in tokenisedCorpus:
#
#     if len(eachToken) == 0:
#         continue
#
#     if len(eachToken) == ngramSize:
#         splitInput.append(np.asarray(eachToken[:-1]))
#     else:
#         splitInput.append(np.asarray(([0] * (ngramSize - len(eachToken))) + eachToken[:-1]))
#
#     splitOutput.append(eachToken[-1])
#
# inputList = np.asarray(splitInput)
# categoricalList = ku.to_categorical(splitOutput, num_classes = len(tokeniserObject.word_index) + 1)
#
# print inputList[0:50]
#
# print "Here - 4"
#
# predictionModel = km.Sequential([
#     kl.Embedding(input_dim = len(tokeniserObject.word_index) + 1, input_length = ngramSize - 1, output_dim = 32),
#     kl.LSTM(units = 128),
#     kl.Dense(128, activation = "relu"),
#     kl.Dense(len(tokeniserObject.word_index) + 1, activation = "softmax")
# ])
#
# predictionModel.compile(loss = "categorical_crossentropy", optimizer = "adam", metrics = ["accuracy"])
#
# print "Here - 5"
#
# predictionModel.fit(inputList, categoricalList, batch_size = 256, epochs = 1)
#
# outputModel = kml.convert(predictionModel, input_names = ["Input_Sequence"], output_names = ["Output_Probabilities"])
# outputModel.save("Test.mlmodel")


# index_word_lookup = dict([[v,k] for k,v in tokenizerObject.word_index.items()])
#
# for eachIndex in [0, 1, 543]:
#
#     print tokenized_sequences[eachIndex]
#     print list(map(lambda a: index_word_lookup[a], tokenized_sequences[eachIndex]))




# max_sequence_len = max([len(x) for x in tokenized_sequences])
# input_sequences = array(pad_sequences(
#     tokenized_sequences,
#     maxlen=max_sequence_len,
#     padding='pre'
# ))

# print input_sequences[0]
# print input_sequences[543]
# print input_sequences[542]



#
#
# print ngramCorpus


# textCorpus.split(" ")




#
# ngramCorpus =
#
# print ngramCorpus

#
# sentenceCorpus =
# word_data = "The best performance can bring in sky high success."
# nltk_tokens = nltk.word_tokenize(word_data)
#
# print(list(nltk.bigrams(nltk_tokens)))
#
#
# uniqueCorpus = set(splitCorpus)
#
# hotOnes = keras.preprocessing.text.one_hot(textCorpus, len(uniqueCorpus), filters = '[/:$%^&*(){}]', lower = False, split = " ")
#
# print uniqueCorpus
# print hotOnes
# #
#
#
#
# .split(" ")
# uniqueCorpus = set(cleanedCorpus)
# uniqueSize = len(uniqueCorpus)
#
# hotOnes =
#
#
#
#
# # define the document
# text = 'The quick brown fox jumped over the lazy dog. And he was very happy about it'
# # estimate the size of the vocabulary
# words = set(text_to_word_sequence(text))
#
# print(words)
#
# vocab_size = len(words)
# print(vocab_size)
# # integer encode the document
# result = one_hot(text, round(vocab_size*1.3))
# print(result)
#
# # print cleanedCorpus
