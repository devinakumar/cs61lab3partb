#!/usr/bin/env python

from __future__ import print_function        # make print a function
from datetime import datetime                # get datetime
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors

CURRENT_YEAR = 2016


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

    def schedule(self, manuscriptId, year, period):
        if year < CURRENT_YEAR:
            print("This is not a valid year for publication.  Please enter a valid publication year.")
            return
        if period not in ('1', '2', '3', '4'):
            print("This is not a valid issue number.  Please choose among numbers 1, 2, 3, and 4.")
            return
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
        # check if issue has been published
        query3 = "SELECT COUNT(*) FROM JournalIssue WHERE Year = %d AND Period = '%s' AND PrintDate IS NOT NULL;" % (year, period)
        cursor3 = self.con.cursor(buffered=True)
        cursor3.execute(query3)
        issuePublished = cursor3.fetchone()[0]
        if issuePublished >= 1:
            print("This issue has already been published/set for publication.")
            cursor3.close()
            return
        cursor3.close()

        # check if issue exists; if not, then create it
        query4 = "SELECT COUNT(*) FROM JournalIssue WHERE Year = %d AND Period = '%s' AND PrintDate IS NULL;" % (year, period)
        cursor4 = self.con.cursor(buffered=True)
        cursor4.execute(query4)
        issueExists = cursor4.fetchone()[0]
        if issueExists == 0:
            cursor4.close()
            query5 = "INSERT INTO JournalIssue (Year, Period) VALUES (%d, '%s');" % (year, period)
            print("making a new issue")
            cursor5 = self.con.cursor(buffered=True)
            cursor5.execute(query5)
            self.con.commit()
            cursor5.close()
        else:
            cursor4.close()
            # add up all of the manuscripts that are already in the issue; if adding this one would exceed 100, then do not add it
            query5 = "SELECT PagesOccupied FROM Manuscript WHERE JournalIssueYear=%d AND JournalIssuePeriod='%s';" % (year, period)
            print("checking pages")
            cursor5 = self.con.cursor(buffered=True)
            cursor5.execute(query5)
            issueManuscripts = cursor5.fetchall()
            print(issueManuscripts)
            count = 0
            for manuscript in issueManuscripts:
                print(manuscript)
                count = count + manuscript[0]
            cursor5.close()
            if count >= 100:
                print("This issue is already full.  Please schedule this manuscript for a different issue.")
                return
            query6 = "SELECT PagesOccupied FROM Manuscript WHERE ManuscriptId=%d;" % (manuscriptId)
            cursor6 = self.con.cursor(buffered=True)
            cursor6.execute(query6)
            finalCount = cursor6.fetchone()[0] + count
            if finalCount > 100:
                print("The addition of this manuscript would make the issue exceed its page limit.  Please assign the manuscript to a different issue.")
                cursor6.close()
                return
            # print(count)
            # print(finalCount)
            cursor6.close()

        # if all these checks pass, add the manuscript
        query7 = "UPDATE Manuscript SET Status='%s', JournalIssueYear=%d, JournalIssuePeriod='%s' WHERE ManuscriptId=%d;" % ('Scheduled', year, period, manuscriptId)
        cursor7 = self.con.cursor(buffered=True)
        cursor7.execute(query7)
        self.con.commit()
        cursor7.close()
        return

    def publish(self, year, period):
        print("in publish")
        # check if issue has been published
        query = "SELECT COUNT(*) FROM JournalIssue WHERE Year = %d AND Period = '%s' AND PrintDate IS NOT NULL;" % (year, period)
        cursor = self.con.cursor(buffered=True)
        cursor.execute(query)
        issuePublished = cursor.fetchone()[0]
        print(issuePublished)
        if issuePublished >= 1:
            print("This issue has already been published/set for publication.")
            cursor.close()
            return
        cursor.close()

        # check if issue exists
        query2 = "SELECT COUNT(*) FROM JournalIssue WHERE Year = %d AND Period = '%s' AND PrintDate IS NULL;" % (year, period)
        cursor2 = self.con.cursor(buffered=True)
        cursor2.execute(query2)
        issueExists = cursor2.fetchone()[0]
        print(issueExists)
        if issueExists < 1:
            print("This issue does not exist.  Please try again.")
            cursor2.close()
            return
        cursor2.close()

        # check that there is at least 1 manuscript assigned
        query3 = "SELECT COUNT(*) FROM Manuscript WHERE JournalIssueYear = %d AND JournalIssuePeriod = '%s';" % (year, period)
        cursor3 = self.con.cursor(buffered=True)
        cursor3.execute(query3)
        manuscriptNumber = cursor3.fetchone()[0]
        print(manuscriptNumber)
        if manuscriptNumber < 1:
            print("There must be at least 1 manuscript schedule to appear in the issue to publish it.")
            cursor3.close()
            return
        cursor3.close()

        # set the manuscripts and issue to published
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        query4 = "UPDATE Manuscript SET Status = '%s' WHERE JournalIssueYear = %d AND JournalIssuePeriod = '%s';" % ('Published', year, period)
        cursor4 = self.con.cursor(buffered=True)
        cursor4.execute(query4)
        self.con.commit()
        cursor4.close()

        query5 = "UPDATE JournalIssue SET PrintDate = '%s' WHERE Year = %d AND Period = '%s';" % (timestamp, year, period)
        cursor5 = self.con.cursor(buffered=True)
        cursor5.execute(query5)
        self.con.commit()
        cursor5.close()
        return
