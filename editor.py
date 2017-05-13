#!/usr/bin/env python

from __future__ import print_function        # make print a function
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors

class Editor:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    def greeting(self):
        # Retrieve basic information
        query = "SELECT FirstName, LastName FROM Editor WHERE EditorId = %d;" % self.id

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)
        info = cursor.fetchone()

        fullName = "%s %s" % (info[0], info[1])

        print("Welcome back, %s!" % fullName)

        cursor.close()

    def status(self):
        # Retrieve manuscript status counts
        query = ("SELECT COUNT(*) as `Number`, Status FROM Manuscript WHERE EditorId = %d GROUP BY Status;" % self.id)

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)

        statuses = {'Received': 0, 'Under Review': 0, 'Rejected': 0, 'Accepted': 0, 'Typeset': 0, 'Scheduled': 0, 'Published': 0}

        for row in cursor:
            statuses[row[1]] = row[0]

        for status, count in statuses.iteritems():
            print("%s: %d" % (status, count))

        cursor.close()

    def list(self):
        # Retrieve manuscript status counts
        query = ("SELECT ManuscriptId, Title, Status FROM Manuscript WHERE EditorId = %d ORDER BY FIELD(Status, 'Received', 'Under Review', 'Rejected', 'Accepted', 'Typeset', 'Scheduled', 'Published'), ManuscriptId;" % self.id)

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)

        for row in cursor:
            print("ID %s | %s | %s" % (row[0], row[1], row[2]))

        cursor.close()


    def assign(self, manuscriptId, reviewerId):
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
