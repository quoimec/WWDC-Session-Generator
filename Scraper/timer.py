#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import time
import sys

class Timer:

    def __init__(self):

        self.startTime = datetime.datetime.now().time().strftime('%H:%M:%S')

    def elapsedTime(self):

        return str(datetime.datetime.strptime(datetime.datetime.now().time().strftime('%H:%M:%S'),'%H:%M:%S') - datetime.datetime.strptime(self.startTime,'%H:%M:%S'))

    def startJob(self, jobName):

        print("")
        print(" -", self.elapsedTime(), "- Starting", jobName)

    def updateJob(self, currentValue, totalValue, totalErrors = 0):

        sys.stdout.write('\r')
        sys.stdout.write(" - " + self.elapsedTime() + " - " + str(round((currentValue / totalValue) * 100, 2)) + "% Complete" + ("" if totalErrors == 0 else " - " + totalErrors + " Errors"))
        sys.stdout.flush()

    def completeJob(self, jobName, errorLog = []):

        sys.stdout.write('\r')
        sys.stdout.write(" ✔︎ " + self.elapsedTime() + " - Finished " + jobName)
        sys.stdout.flush()
        print("")

        if len(errorLog) > 0:
            print(errorLog)

        print("")
