from __future__ import print_function        # make print a function
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors

class Author:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    def register(self, fname, lname, email, address):
        return

    def status(self):
        return

    def submit(self, title, affiliation, ri, secondaryAuths, filename):
        return

    def retract(self, manuscriptId):
        return
