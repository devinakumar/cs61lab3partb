from __future__ import print_function        # make print a function
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors

class Editor:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    def register(self, fname, lname):
        return

    def status(self):
        return "got here"


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
