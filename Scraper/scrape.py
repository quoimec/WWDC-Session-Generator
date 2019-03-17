#!/usr/bin/env python
# -*- coding: utf-8 -*-

import requests
import lxml
from bs4 import BeautifulSoup
import datetime
from timer import Timer
import os

class ScrapeWWDC:

    def __init__(self, listWWDC, rateLimit = 3.0):

        self.listWWDC = listWWDC
        self.rateLimit = rateLimit
        self.lastScrape = datetime.datetime.now()

        self.timerObject = Timer()
        self.errorList = []

    def getSoup(self, passedURL):

        """
            GetSoup:
                The core scraping function that reaches out to the passed URL and retrieves a bs4 soup of HTML data.

            Arguments:
                passedURL (string): The request URL

            Returns:
                soupData (soup): A bs4 soup of the requested resource OR
                none: If the server responds with anything other than a 200 response code
        """

        userHeader = {
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Charset": "ISO-8859-1,utf-8;q=0.7,*;q=0.3",
            "Accept-Encoding": "none",
            "Accept-Language": "en-US,en;q=0.8",
            "Connection": "keep-alive"
        }

        httpResponse = requests.get(passedURL, headers = userHeader)

        if httpResponse.status_code != 200:
            self.errorList.append(passedURL)
            return None

        soupData = BeautifulSoup(httpResponse.text, "lxml")

        return soupData

    def getSessionList(self, passedSoup, stemURL):

        """
            GetSessionList:
                Retrieves the URLs for every listed session for a WWDC year

            Arguments:
                passedSoup (soup): The request URL

            Returns:
                soupData (soup): A bs4 soup of the requested resource OR
                none: If the server responds with anything other than a 200 response code
        """

        finalStem = stemURL if stemURL[-1] != "/" else stemURL[:-1]

        sessionList = passedSoup.findAll("li", {"class": "collection-item"})
        return list(map(lambda a: finalStem + a.find("a", href=True)["href"], sessionList))

    def getSession(self, passedSoup):

        sessionYear = self.cleanText(passedSoup.find("p", {"class": "smaller lighter"}).text).split(" - ")[0].split(" ")[1]
        sessionNumber = self.cleanText(passedSoup.find("p", {"class": "smaller lighter"}).text).split(" - ")[1].split(" ")[1]
        sessionTitle = self.cleanText(passedSoup.find("h1").text)
        sessionTranscript = self.cleanText(" ".join(list(map(lambda a: self.cleanText(a.text), passedSoup.findAll("span", {"class": "sentence"})))))

        return sessionYear, sessionNumber, sessionTitle, sessionTranscript

    def cleanText(self, passedText):

        buildingText = passedText.replace("\r\n", " ").replace("\r", " ").replace("\n", " ").replace("\t", " ")

        while "  " in buildingText:
            buildingText = buildingText.replace("  ", " ")

        return buildingText

    def executeScrape(self):

        self.timerObject.startJob("Stage 1: Session List")
        lengthWWDC = len(self.listWWDC)
        sessionList = []

        for eachIndex, eachWWDC in enumerate(self.listWWDC):

            self.timerObject.updateJob(eachIndex, lengthWWDC)
            soupWWDC = self.getSoup(eachWWDC)

            if soupWWDC != None:
                sessionList += self.getSessionList(soupWWDC, eachWWDC)

        self.timerObject.completeJob("Stage 1: Session List")

        self.timerObject.startJob("Stage 2: Session Transcripts")
        lengthSessions = len(sessionList)

        if not os.path.exists("Data/"):
            os.makedirs("Data/")

        for eachIndex, eachSession in enumerate(sessionList):

            self.timerObject.updateJob(eachIndex, lengthSessions, len(self.errorList))
            sessionSoup = self.getSoup(eachSession)

            if sessionSoup != None:

                sessionYear, sessionNumber, sessionTitle, sessionTranscript = self.getSession(sessionSoup)

                if not os.path.exists("Data/" + sessionYear + "/"):
                    os.makedirs("Data/" + sessionYear + "/")

                fileName = sessionYear + "/" + sessionNumber + ":" + sessionTitle.replace(" ", "-").replace("/", "-") + ".txt"
                transcriptFile = open("Data/" + fileName, "w")
                transcriptFile.write(sessionTranscript)
                transcriptFile.close()

        self.timerObject.completeJob("Stage 2: Session Transcripts", self.errorList)

    def completeCorpus(self):

        corpusFile = open("Data/Corpus.txt", "w")

        for eachYear in os.listdir("Data/"):

            yearDirectory = "Data/" + eachYear

            if not os.path.isdir(yearDirectory):
                continue

            for eachFile in os.listdir(yearDirectory):

                if eachFile[-4:] != ".txt":
                    continue

                corpusFile.write(open(yearDirectory + "/" + eachFile, "r").read())

        corpusFile.close()


listWWDC = [
    "https://developer.apple.com/videos/wwdc2015",
    "https://developer.apple.com/videos/wwdc2016",
    "https://developer.apple.com/videos/wwdc2017",
    "https://developer.apple.com/videos/wwdc2018"
]

scrapeJob = ScrapeWWDC(listWWDC)

scrapeJob.completeCorpus()
