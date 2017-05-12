from __future__ import print_function        # make print a function
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors

class Reviewer:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    def register(self, fname, lname, RICodes):
        return

    def resign(self):
        print "Thank you for your service."
        return

    def status(self):
        return

    def review(self, manuscriptId, appropriateness, clarity, methodology, fieldContribution, recommendation):
        return
