#!/usr/bin/env python

from __future__ import print_function        # make print a function
from datetime import datetime                # get datetime
# import mysql.connector                       # mysql functionality
# import sys                                   # for misc errors


class PrimaryAuthor:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    def register(self, fname, lname, email, address):
        return

    def greeting(self):
        # Retrieve basic information
        query = "SELECT FirstName, LastName, MailingAddress FROM PrimaryAuthor WHERE PrimaryAuthorId = %d;" % self.id

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)
        info = cursor.fetchone()

        fullName = "%s %s" % (info[0], info[1])
        mailingAddress = info[2]

        print("Welcome back, %s!" % fullName)
        print("Your mailing address is %s\n" % mailingAddress)

        cursor.close()

    def status(self):
        # Retrieve manuscript status counts
        query = ("SELECT COUNT(*) as `Number`, Status FROM Manuscript WHERE PrimaryAuthorId = %d GROUP BY Status;" % self.id)

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
        query = ("SELECT ManuscriptId, Title, Status FROM Manuscript WHERE PrimaryAuthorId = %d ORDER BY FIELD(Status, 'Received', 'Under Review', 'Rejected', 'Accepted', 'Typeset', 'Scheduled', 'Published'), ManuscriptId;" % self.id)

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)

        for row in cursor:
            print("ID %s | %s | %s" % (row[0], row[1], row[2]))

        cursor.close()

    def submit(self, input):
        try:
            if (len(input) < 5):
                raise ValueError('')
            title = input[1]
            affiliation = input[2]
            RICode = int(input[3])
            secondaryAuthors = input[4:-1]  # index 3 through 2nd to last
            filename = input[-1]
            self.submitHelper(title, affiliation, RICode, secondaryAuthors, filename)
        except (ValueError, IndexError):
            print ("Invalid. Usage: submit <title> <Affiliation> <RICode> <author2> <author3> <author4> <filename>")

    def submitHelper(self, title, affiliation, ri, secondaryAuths, filename):
        manuscriptID = -1

        # First we need to update the author's affiliation
        query = "UPDATE PrimaryAuthor SET Affiliation = '%s' WHERE PrimaryAuthorId = %d" % (affiliation, self.id)

        # initialize a cursor and query db
        authorCursor = self.con.cursor(buffered=True)
        try:
            authorCursor.execute(query)
            self.con.commit()
        except IndexError, e:
            print(e)
            self.con.rollback()
        authorCursor.close()

        # Now we need to perform the insert and return the manuscript ID
        date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        status = "Received"

        # Get the editor ID as the lowest ID #
        query = "SELECT EditorId FROM Editor ORDER BY EditorID"
        editorCursor = self.con.cursor(buffered=True)
        editorCursor.execute(query)
        result = editorCursor.fetchone()
        print("result is %s" % result)
        editorID = int(result[0])
        print("editorID is %d" % editorID)
        print("editorID is %d" % editorID)

        query = "INSERT INTO Manuscript (Title, DateReceived, Status, RICode, PrimaryAuthorID, EditorID, PrimaryAuthorAffiliation, Document) VALUES ('%s', '%s', '%s', %d, %d, %d, '%s', '%s');" % (title, date, status, ri, self.id, editorID, affiliation, filename)

        # initialize a cursor and query db
        cursor = self.con.cursor(buffered=True)
        try:
            cursor.execute(query)
            self.con.commit()
            manuscriptID = cursor.lastrowid
        except IndexError, e:
            print(e)
            self.con.rollback()

        print("Created a manuscript with ID=%s" % manuscriptID)
        cursor.close()
        editorCursor.close()

        return

    def retract(self, manuscriptId):
        return
