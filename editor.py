#!/usr/bin/env python

from __future__ import print_function        # make print a function
from datetime import datetime                # get datetime
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors

class Editor:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    def register(self, fname, lname):
        query = "INSERT INTO Editor VALUES('%s', '%s')" % (fname,lname)

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)
        for row in cursor:
            print("".join(["{:<12}".format(col) for col in row]))

        cursor.close()
        return

    def status(self):
        return "got here"


    def assign(self, manuscriptId, reviewerId):
        # check if reviewer is retired
        query = "SELECT Retired, RICode FROM Reviewer WHERE ReviewerId = %d" % (reviewerId)
        cursor = self.con.cursor()
        cursor.execute(query)
        resultReviewer = cursor.fetchone()
        if result[0] == 1:
            print("Sorry, but this reviewer is retired.  Please assign this manuscript to someone else.")
            cursor.close()
            return
        cursor.close()

        # check if manuscript RI and reviewer RI match
        query2 = "SELECT RICode FROM Manuscript WHERE ReviewerId = %d" % (reviewerId)
        cursor2 = self.con.cursor()
        cursor2.execute(query2)
        resultManuscript = cursor2.fetchone()
        if resultReviewer[1] != resultManuscript[0]:
            print("Sorry, but this reviewer does not review manuscripts in this field.  Please assign this manuscript to another reviewer.")
            cursor2.close()
            return
        cursor2.close()

        # if they match, assign a manuscript by creating a review assigned to the reviewer with a timestamp
        timestamp = str(datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        query3 = "INSERT INTO ReviewerInterests (RICode, ReviewerId) VALUES (%d, %d)" % (ri, reviewerID)

        # change manuscript status to Under Review
        return

    def reject(self, manuscriptId):
        return

    def accept(self, manuscriptId):
        return

    def typeset(self, manuscriptId, pp):
        return

    def schedule(self, manuscriptId, issue):
        return

    def publish(self, issue):
        return
