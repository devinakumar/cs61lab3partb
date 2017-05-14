#!/usr/bin/env python

"""
  go.python

  Henry Wilson & Devina Kumar

  Python 2.7.10
"""
from __future__ import print_function        # make print a function
import mysql.connector                       # mysql functionality
import sys                                   # for misc errors
import shlex                                 # for parsing
from editor import Editor
from reviewer import Reviewer
from author import PrimaryAuthor
import config

user = None

REGISTER_ERROR = "Invalid. Usage: register [author/reviewer/editor] ..."


def login(input):
    try:
        userType = input[1].capitalize()
        userId = int(input[2])

        if userType == "Author":
            userType = "PrimaryAuthor"

        query = "SELECT COUNT(*) FROM %s WHERE %sId = %d;" % (userType, userType, userId)

        cursor = con.cursor()
        cursor.execute(query)

        result = cursor.fetchone()

        if result[0] == 1:
            if userType == "Editor":
                return Editor(userId, con)
            elif userType == "Reviewer":
                return Reviewer(userId, con)
            elif userType == "PrimaryAuthor":
                return PrimaryAuthor(userId, con)
        cursor.close()
    except (ValueError, IndexError):
        print ("User does not exist")


def register(input, con):
    try:
        userType = input[1].capitalize()
        if userType == "Editor":
            Editor.register(con, input)
        elif userType == "Reviewer":
            Reviewer.register(con, input)
        elif userType == "Author":
            PrimaryAuthor.register(con, input)
        else:
            raise ValueError()
    except(ValueError, IndexError, NameError, TypeError):
        print(REGISTER_ERROR)


if __name__ == "__main__":
    try:
        # initialize db connection
        con = mysql.connector.connect(host=config.SERVER, user=config.USERNAME, password=config.PASSWORD, database=config.DATABASE)

        print("Welcome! Connected to the database.")

        running = True
        while running:
            try:
                input = shlex.split(raw_input('> '))
                command = input[0]

                if command == 'login':
                    user = login(input)
                    user.greeting()
                    user.status()
                elif command == 'status':
                    user.status()
                elif command == 'register':
                    register(input, con)
                elif command == 'list':
                    user.list()
                elif command == 'assign':
                    if isinstance(user, Editor):
                        user.assign(input)
                    else:
                        print("Only editors may assign manuscripts to reviewers.")
                elif command == 'submit':
                    if isinstance(user, PrimaryAuthor):
                        user.submit(input)
                    else:
                        print("Only authors may submit manuscripts.")
                elif command == 'reject':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.reject(input)
                    else:
                        print("Only editors may reject manuscripts.")
                elif command == 'accept':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.accept(input)
                    else:
                        print("Only editors may accept manuscripts.")
                elif command == 'typeset':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.typeset(input)
                    else:
                        print("Only editors may typeset manuscripts.")
                elif command == 'schedule':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.schedule(input)
                    else:
                        print("Only editors may schedule manuscripts.")
                elif command == 'publish':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.publish(input)
                    else:
                        print("Only editors may publish manuscripts.")
                elif command == 'review':
                    # print(type(user))
                    if isinstance(user, Reviewer):
                        user.review(input)
                    else:
                        print("Only Reviewers may review manuscripts.")
                elif command == 'retract':
                    if isinstance(user, PrimaryAuthor):
                        user.retract(input)
                    else:
                        print("Only authors may retract manuscripts.")
                elif command == 'logout':
                    if user is not None:
                        user = None
                        print("Logged out")
                    else:
                        print("You are not logged in")
                elif command == 'quit':
                    running = False
            except mysql.connector.Error as e:        # catch SQL errors
                if "UserException1001" in str(e):
                    print("Either the RICode is invalid, or there are not 3 reviewers interested in it")
                else:
                    print("Invalid: {0}".format(e.msg))
                con.rollback()
    except:                                   # anything else
        print("Unexpected error: {0}".format(sys.exc_info()[0]))

    # cleanup
    try:
        con.close()
    except NameError:
        pass

    print("\nConnection terminated.\n\n", end='')
