#!/usr/bin/env python

from __future__ import print_function        # make print a function
from datetime import datetime                # get datetime
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
        # print("beginning of assign")

        # check if editor is assigned to manuscript
        query6 = "SELECT EditorId FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor6 = self.con.cursor(buffered=True)
        cursor6.execute(query6)
        resultEditor = cursor6.fetchone()
        if resultEditor[0] != self.id:
            print("Sorry, but you do not have the authority to assign reviewers for this manuscript.")
            cursor6.close()
            return
        cursor6.close()
        # print("first cursor done")

        # check if reviewer is retired
        query = "SELECT Retired FROM Reviewer WHERE ReviewerId = %d;" % (reviewerId)
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        resultReviewer = cursor.fetchone()
        if resultReviewer[0] == 1:
            print("Sorry, but this reviewer is retired.  Please assign this manuscript to someone else.")
            cursor.close()
            return
        cursor.close()
        # print("second cursor done")
        # print("first stage of assign done")

        # check if manuscript RI and reviewer RI match
        query5 = "SELECT RICode FROM ReviewerInterests WHERE ReviewerId = %d;" % (reviewerId)
        cursor5 = self.con.cursor(buffered=True)
        cursor5.execute(query5)
        resultRI = cursor5.fetchone()
        cursor5.close()
        # print("third cursor done")
        query2 = "SELECT RICode FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor2 = self.con.cursor(buffered=True)
        cursor2.execute(query2)
        resultManuscript = cursor2.fetchone()
        if resultRI[0] != resultManuscript[0]:
            print("Sorry, but this reviewer does not review manuscripts in this field.  Please assign this manuscript to another reviewer.")
            cursor2.close()
            return
        cursor2.close()

        # if they match, assign a manuscript by creating a review assigned to the reviewer with a timestamp
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        query3 = "INSERT INTO Review (ManuscriptId, ReviewerId, DateSent) VALUES (%d, %d, '%s');" % (manuscriptId, reviewerId, timestamp)
        cursor3 = self.con.cursor(buffered=True)
        cursor3.execute(query3)
        self.con.commit()
        cursor3.close()

        # change manuscript status to Under Review
        cursor4 = self.con.cursor(buffered=True)
        query4 = "UPDATE Manuscript SET Status='%s' WHERE ManuscriptId=%d;" % ('Under Review', manuscriptId)
        cursor4.execute(query4)
        self.con.commit()
        cursor4.close()
        return

    def reject(self, manuscriptId):
        # check if editor is assigned to manuscript
        query = "SELECT EditorId FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        resultEditor = cursor.fetchone()
        if resultEditor[0] != self.id:
            print("Sorry, but you do not have the authority to reject this manuscript.")
            cursor.close()
            return
        cursor.close()

        # check if manuscript is in appropriate stage to be rejected
        query2 = "SELECT Status FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor2 = self.con.cursor(buffered=True)
        cursor2.execute(query2)
        resultManuscript = cursor2.fetchone()
        if resultManuscript[0] not in ('Under Review', 'Received'):
            print("Sorry, but it is too late to reject this manuscript.")
            cursor2.close()
            return
        cursor2.close()

        # take the timestamp and reject the manuscript
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        query3 = "UPDATE Manuscript SET Status='%s', DateAcceptReject='%s' WHERE ManuscriptId=%d;" % ('Rejected', timestamp, manuscriptId)
        cursor3 = self.con.cursor(buffered=True)
        cursor3.execute(query3)
        self.con.commit()
        cursor3.close()
        return

    def accept(self, manuscriptId):
        # check if editor is assigned to manuscript
        query = "SELECT EditorId FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        resultEditor = cursor.fetchone()
        if resultEditor[0] != self.id:
            print("Sorry, but you do not have the authority to reject this manuscript.")
            cursor.close()
            return
        cursor.close()
        # print("made it past editor checking")
        # check if manuscript is in appropriate stage to be Accepted
        query2 = "SELECT Status FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor2 = self.con.cursor(buffered=True)
        cursor2.execute(query2)
        resultManuscript = cursor2.fetchone()
        if resultManuscript[0] not in ('Under Review'):
            print("Sorry, but this manuscript must be reviewed before it can be accepted.")
            cursor2.close()
            return
        cursor2.close()
        # print("made it past stage checking")
        # check if manuscript has enough reviews to be accepted
        query3 = "SELECT COUNT(*) FROM Review WHERE ManuscriptId = %d AND DateCompleted IS NOT NULL;" % (manuscriptId)
        cursor3 = self.con.cursor(buffered=True)
        cursor3.execute(query3)
        # print(cursor3.fetchone()[0])
        validReviews = cursor3.fetchone()[0]
        print(validReviews)
        # print("this is result reviews:")
        # print(resultReviews)
        if validReviews < 3:
            print("Sorry, but this manuscript must be reviewed by at least 3 reviewers before it can be accepted.")
            cursor3.close()
            return
        cursor3.close()
        # update status of manuscript
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        query4 = "UPDATE Manuscript SET Status='%s', DateAcceptReject='%s' WHERE ManuscriptId=%d;" % ('Accepted', timestamp, manuscriptId)
        cursor4 = self.con.cursor(buffered=True)
        cursor4.execute(query4)
        self.con.commit()
        cursor4.close()
        return

    def typeset(self, manuscriptId, pp):
        # check if editor is assigned to manuscript
        query = "SELECT EditorId FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        resultEditor = cursor.fetchone()
        if resultEditor[0] != self.id:
            print("Sorry, but you do not have the authority to typeset this manuscript.")
            cursor.close()
            return
        cursor.close()

        query2 = "SELECT Status FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor2 = self.con.cursor(buffered=True)
        cursor2.execute(query2)
        resultManuscript = cursor2.fetchone()
        if resultManuscript[0] not in ('Accepted'):
            print("Sorry, but this manuscript either must be reviewed, has already been rejected, or has already been typeset.")
            cursor2.close()
            return
        cursor2.close()

        query3 = "UPDATE Manuscript SET Status='%s', PagesOccupied=%d WHERE ManuscriptId=%d;" % ('Typeset', pp, manuscriptId)
        cursor3 = self.con.cursor(buffered=True)
        cursor3.execute(query3)
        self.con.commit()
        cursor3.close()
        return

    def schedule(self, manuscriptId, issue):
        # check if editor is assigned to manuscript
        query = "SELECT EditorId FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        resultEditor = cursor.fetchone()
        if resultEditor[0] != self.id:
            print("Sorry, but you do not have the authority to typeset this manuscript.")
            cursor.close()
            return
        cursor.close()
        # check if manuscript is typeset
        query2 = "SELECT Status FROM Manuscript WHERE ManuscriptId = %d;" % (manuscriptId)
        cursor2 = self.con.cursor(buffered=True)
        cursor2.execute(query2)
        resultManuscript = cursor2.fetchone()
        if resultManuscript[0] not in ('Typeset'):
            print("Sorry, but this manuscript either must be reviewed, has already been rejected, has not been typeset, or has already been published.")
            cursor2.close()
            return
        cursor2.close()
        # check if issue exists; if yes, then check whether it has been published and if not, then create the issue
        # add up all of the manuscripts that are already in the issue; if adding this one would exceed 100, then do not add it
        # if all these checks pass, add the manuscript

        return

    def publish(self, issue):
        return
