#!/usr/bin/env python
# -*- coding: utf-8 -*-


import re
from functools import reduce
from keras.preprocessing import text as kt
from keras import utils as ku
from keras import models as km
from keras import layers as kl
import coremltools
from keras.preprocessing.sequence import pad_sequences
import numpy as np

textCorpus = re.sub(r"[/:$%^&*(){}]", "", open("Model/Mini-Corpus.txt", "r").read()).replace(" -- ", " ").replace("-", " ").replace(", ", " , ").replace(". ", " .  .  ").replace("? ", " ?  ?  ").replace("! ", " !  !  ").replace("2015", "2019").replace("2016", "2019").replace("2017", "2019").replace("2018", "2019").lower()

def ngramCreate(wordList, ngramSize, minSize):

    # goodNgrams = listLen - (ngramSize - 1)
    #
    # ngramSize = 5
    # minSize = 3
    #
    # listLen = 11
    #
    # a, b, c, d, e, f, g, h, i, j, k
    #
    # goodNgrams = 7
    #
    # a, b, c, d, e
    # b, c, d, e, f
    # c, d, e, f, g
    # d, e, f, g, h
    # e, f, g, h, i
    # f, g, h, i, j
    # g, h, i, j, k

    if len(wordList) <= ngramSize:
        if len(wordList) >= minSize:
            return [wordList]
        else:
            return [[]]
    else:

        return zip(*[wordList[i:] for i in range(ngramSize)])
ngramSize = 7
ngramCorpus = [" ".join(b) for a in list(map(lambda c: ngramCreate(c.split(" "), ngramSize, 2), re.split("  .  |  ?  |  !  ", textCorpus))) for b in a]

tokeniserObject = kt.Tokenizer()
tokeniserObject.fit_on_texts(ngramCorpus)
tokenisedCorpus = tokeniserObject.texts_to_sequences(ngramCorpus)
