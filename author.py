from __future__ import print_function        # make print a function
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors

class PrimaryAuthor:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    def register(self, fname, lname, email, address):
        return

    def status(self):

        print "Welcome back!"

        query = "SELECT FirstName, LastName, MailingAddress FROM PrimaryAuthor WHERE PrimaryAuthorId = %d;" % self.id

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)

        for row in cursor:
            print("".join(["{:<12}".format(col) for col in row]))

        cursor.close()

        query = "SELECT COUNT(*) as `Number`, Status FROM Manuscript WHERE PrimaryAuthorId = %d GROUP BY Status;" % self.id

        # initialize a cursor
        cursor = self.con.cursor()

        # query db
        cursor.execute(query)

        for row in cursor:
            print("".join(["{:<12}".format(col) for col in row]))

        cursor.close()

    def submit(self, title, affiliation, ri, secondaryAuths, filename):
        return

    def retract(self, manuscriptId):
        return
