#!/usr/bin/env python

from __future__ import print_function        # make print a function
from datetime import datetime                # get datetime
import shlex                                 # for parsing
import auth
# import mysql.connector                       # mysql functionality
# import sys                                   # for misc errors

REGISTER_ERROR = "Invalid. Usage: register author FirstName LastName Email \"MailingAddress\""


class PrimaryAuthor:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    @staticmethod
    def register(con, input, salt):
        try:
            if len(input) == 6 and input[2] is not None and input[3] is not None and input[4] is not None and input[5] is not None:
                fname = input[2]
                lname = input[3]
                email = input[4]
                address = input[5]

                password = auth.createPassword(con, salt)

                if not password:
                    return

                query = "INSERT INTO PrimaryAuthor (FirstName, LastName, Email, MailingAddress) VALUES ('%s', '%s', '%s', '%s')" % (fname, lname, email, address)
                cursor = con.cursor(buffered=True)
                cursor.execute(query)
                authorId = cursor.lastrowid
                cursor.close()

                auth.register(con, authorId, 'PrimaryAuthor', password)

                print("Created an author with ID=%s... you can now login" % authorId)
            else:
                print(REGISTER_ERROR)
        except (ValueError, IndexError, NameError, TypeError):
            print(REGISTER_ERROR)

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
            self.__submitHelper(title, affiliation, RICode, secondaryAuthors, filename)
        except (ValueError, IndexError):
            print ("Invalid. Usage: submit title <Affiliation> <RICode> <author2> <author3> <author4> <filename>")
            return

    def __submitHelper(self, title, affiliation, ri, secondaryAuths, filename):
        manuscriptID = -1

        # First we need to update the author's affiliation
        query = "UPDATE PrimaryAuthor SET Affiliation = '%s' WHERE PrimaryAuthorId = %d" % (affiliation, self.id)

        # initialize a cursor and query db
        authorCursor = self.con.cursor(buffered=True)
        authorCursor.execute(query)
        authorCursor.close()

        # Now we need to perform the insert and return the manuscript ID
        date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        status = "Received"

        # Get the editor ID as the lowest ID #
        query = "SELECT EditorId FROM Editor ORDER BY EditorID"
        editorCursor = self.con.cursor(buffered=True)
        editorCursor.execute(query)
        result = editorCursor.fetchone()
        editorID = int(result[0])

        # insert manuscript
        query = "INSERT INTO Manuscript (Title, DateReceived, Status, RICode, PrimaryAuthorID, EditorID, PrimaryAuthorAffiliation, Document) VALUES ('%s', '%s', '%s', %d, %d, %d, '%s', '%s');" % (title, date, status, ri, self.id, editorID, affiliation, filename)

        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        manuscriptID = cursor.lastrowid

        # insert secondary authors
        for index, author in enumerate(secondaryAuths):
            self.__createSecondaryAuthor(author, index + 1, manuscriptID)

        print("Created a manuscript with ID=%s" % manuscriptID)
        self.con.commit()
        cursor.close()
        editorCursor.close()

        return

    def __createSecondaryAuthor(self, author, bylinePosition, manuscriptId):
        fullName = shlex.split(author)
        try:
            firstName = fullName[0]
            lastName = ' '.join(fullName[1:])
            query = "INSERT INTO SecondaryAuthor (BylinePosition, ManuscriptId, FirstName, LastName) VALUES (%d, %d, '%s', '%s');" % (bylinePosition, manuscriptId, firstName, lastName)
            cursor = self.con.cursor(buffered=True)
            cursor.execute(query)
            cursor.close()
        except IndexError:
            print("You did not enter a valid secondary author name")
            return

    def retract(self, input):
        try:
            manuscriptId = int(input[1])
        except (IndexError, ValueError):
            print("Invalid manuscriptId")
            return

        # Make sure the manuscript exists and is owned by the author
        query = "SELECT COUNT(*) FROM Manuscript WHERE PrimaryAuthorId = %d AND ManuscriptId = %d;" % (self.id, manuscriptId)
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        result = cursor.fetchone()
        if result[0] != 1:
            print("You do not have access to that manuscript, or it does not exist")
            return
        cursor.close()

        # Ask them if they are sure
        response = raw_input("Are you sure? (Yes/No) > ")
        if response.capitalize() != "Yes":
            print("OK, we won't delete it")
            return

        # Delete secondary authors
        query = "DELETE FROM SecondaryAuthor WHERE ManuscriptId = %d;" % manuscriptId
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        cursor.close()

        # Delete reviews
        query = "DELETE FROM Review WHERE ManuscriptId = %d;" % manuscriptId
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        cursor.close()

        # Delete manuscript
        query = "DELETE FROM Manuscript WHERE PrimaryAuthorId = %d AND ManuscriptId = %d;" % (self.id, manuscriptId)
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        self.con.commit()
        cursor.close()

        print("Deleted manuscript")
