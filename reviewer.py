#!/usr/bin/env python

from __future__ import print_function        # make print a function
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors
from datetime import datetime                # get datetime

REGISTER_ERROR = "Invalid. Usage: register reviewer FirstName LastName Email Affiliation RICode [RICode] [RICode]"


class Reviewer:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    @staticmethod
    def register(con, input):
        try:
            riCodes = len(input) - 6
            if len(input) >= 7 and len(input) <= 9:
                fname = input[2]
                lname = input[3]
                email = input[4]
                affiliation = input[5]
                retired = 0
            else:
                raise ValueError()

            query = "INSERT INTO Reviewer (FirstName, LastName, Email, Affiliation, Retired) VALUES ('%s', '%s', '%s', '%s', '%s')" % (fname, lname, email, affiliation, retired)

            # initialize a cursor and query db
            cursor = con.cursor()
            cursor.execute(query)

            reviewerID = cursor.lastrowid
            for x in range(0, riCodes):
                Reviewer.insertReviewerInterest(con, int(reviewerID), int(input[6 + x]))

            con.commit()
            print("Created a reviewer with ID=%s... you can now login" % reviewerID)
            cursor.close()
        except (ValueError, NameError, IndexError, TypeError):
            print(REGISTER_ERROR)

    @staticmethod
    def insertReviewerInterest(con, reviewerID, ri):
        try:
            query = "INSERT INTO ReviewerInterests (RICode, ReviewerId) VALUES (%d, %d)" % (ri, reviewerID)
            cursor = con.cursor()
            cursor.execute(query)
            cursor.close()
        except(ValueError, IndexError, NameError, TypeError):
            print(REGISTER_ERROR)

    def resign(self):
        try:
            query = "UPDATE Reviewer SET Retired=%d WHERE ReviewerId=%d;" % (1, self.id)
            cursor = self.con.cursor()
            cursor.execute(query)
            self.con.commit()
            cursor.close()
            print("Thank you for your service.")
            return
        except(ValueError, IndexError, NameError, TypeError):
            print("Unable to resign.")

    def greeting(self):
        # Retrieve basic information
        query = "SELECT FirstName, LastName FROM Reviewer WHERE ReviewerId = %d;" % self.id

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)
        info = cursor.fetchone()

        fullName = "%s %s" % (info[0], info[1])

        print("Welcome back, %s!" % fullName)

        cursor.close()

    def status(self):
        # Retrieve manuscript status counts
        query = ("SELECT COUNT(*) as `Number`, Status FROM Manuscript WHERE ManuscriptId IN (SELECT ManuscriptId FROM Review WHERE ReviewerId = %d) GROUP BY Status;" % self.id)

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
        query = ("SELECT ManuscriptId, Title, Status FROM Manuscript WHERE ManuscriptId IN (SELECT ManuscriptId FROM Review WHERE ReviewerId = %d) ORDER BY FIELD(Status, 'Received', 'Under Review', 'Rejected', 'Accepted', 'Typeset', 'Scheduled', 'Published'), ManuscriptId;" % self.id)

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)

        for row in cursor:
            print("ID %s | %s | %s" % (row[0], row[1], row[2]))

        cursor.close()

    # def review(self, recommendation, manuscriptId, appropriateness, clarity, methodology, fieldContribution):

    def review(self, input):
        try:
            recommendation = input[1]
            manuscriptId = int(input[2])
            appropriateness = int(input[3])
            clarity = int(input[4])
            methodology = int(input[5])
            fieldContribution = int(input[6])
            # check if reviewer has been assigned to manuscript
            query = "SELECT COUNT(*) FROM Review WHERE ManuscriptId = %d AND ReviewerId = %d;" % (manuscriptId, self.id)
            cursor = self.con.cursor(buffered=True)
            cursor.execute(query)
            manuscriptNumber = cursor.fetchone()[0]
            # print(manuscriptNumber)
            if manuscriptNumber < 1:
                print("This reviewer has not been assigned to review this manuscript.")
                cursor.close()
                return
            cursor.close()

            # check if manuscript is under review
            query2 = "SELECT Status FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
            cursor2 = self.con.cursor(buffered=True)
            cursor2.execute(query2)
            resultManuscript = cursor2.fetchone()
            if resultManuscript[0] not in ('Under Review'):
                print("Sorry, but this manuscript is not in the reviewing process.")
                cursor2.close()
                return
            cursor2.close()

            # submit review
            print(recommendation)
            if recommendation == 'accept':
                timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                query3 = "UPDATE Review SET Appropriateness=%d, Clarity=%d, Methodology=%d, ContributionField=%d, Recommendation='%s', DateCompleted='%s' WHERE ManuscriptId=%d AND ReviewerId=%d;" % (appropriateness, clarity, methodology, fieldContribution, 'Accept', timestamp, manuscriptId, self.id)
                cursor3 = self.con.cursor(buffered=True)
                cursor3.execute(query3)
                self.con.commit()
                cursor3.close()
            elif recommendation == 'reject':
                print("in reject")
                timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                query4 = "UPDATE Review SET Appropriateness=%d, Clarity=%d, Methodology=%d, ContributionField=%d, Recommendation='%s', DateCompleted='%s' WHERE ManuscriptId=%d AND ReviewerId=%d;" % (appropriateness, clarity, methodology, fieldContribution, 'Reject', timestamp, manuscriptId, self.id)
                cursor4 = self.con.cursor(buffered=True)
                cursor4.execute(query4)
                self.con.commit()
                cursor4.close()
            else:
                print("Recommendation must be accept or reject.")
                return
            return
        except (ValueError, IndexError, TypeError, NameError):
            print("Invalid usage: review [recommendation] [manuscriptID] [appropriateness] [clarity] [methodology] [contributionToField]")
