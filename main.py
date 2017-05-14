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
import auth
import getpass

user = None

REGISTER_ERROR = "Invalid. Usage: register [author/reviewer/editor] ..."


def login(con, input, salt):
    try:
        userType = input[1].capitalize()
        userId = int(input[2])

        reviewerText = ""

        if userType == "Author":
            userType = "PrimaryAuthor"
        elif userType == "Reviewer":
            reviewerText = "AND retired = 0"

        query = "SELECT COUNT(*) FROM %s WHERE %sId = %d %s;" % (userType, userType, userId, reviewerText)

        cursor = con.cursor(buffered=True)
        cursor.execute(query)

        result = cursor.fetchone()
        cursor.close()

        if result[0] == 1:
            if not auth.checkPassword(con, userId, userType, salt):
                print("Invalid password")
                return

            # Determine user type and create the relevant object
            if userType == "Editor":
                return Editor(userId, con)
            elif userType == "Reviewer":
                return Reviewer(userId, con)
            elif userType == "PrimaryAuthor":
                return PrimaryAuthor(userId, con)
        else:
            raise ValueError()
        cursor.close()
    except (ValueError, IndexError):
        print ("User does not exist or is retired")
        return None


def register(con, input, salt):
    try:
        userType = input[1].capitalize()

        if userType == "Author":
            userType = "PrimaryAuthor"

        if userType == "Editor":
            Editor.register(con, input, salt)
        elif userType == "Reviewer":
            Reviewer.register(con, input, salt)
        elif userType == "PrimaryAuthor":
            PrimaryAuthor.register(con, input, salt)
        else:
            raise ValueError()

    except(ValueError, IndexError, NameError, TypeError):
        print(REGISTER_ERROR)


if __name__ == "__main__":
    try:
        # initialize db connection
        con = mysql.connector.connect(host=config.SERVER, user=config.USERNAME, password=config.PASSWORD, database=config.DATABASE)

        salt = getpass.getpass("Please enter master key: ")
        print("Welcome! Connected to the database.")
        running = True

        while running:
            try:
                input = shlex.split(raw_input('> '))
                command = input[0]

                if command == 'login':
                    if user is not None:
                        print("Please logout first")
                        continue
                    user = login(con, input, salt)
                    if user is not None:
                        user.greeting()
                        user.status()
                elif command == 'status':
                    user.status()
                elif command == 'register':
                    register(con, input, salt)
                elif command == 'list':
                    if user is not None:
                        user.list()
                    else:
                        print("You must login first")
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
                elif command == 'resign':
                    # print(type(user))
                    if isinstance(user, Reviewer):
                        user.resign()
                        user = None
                    else:
                        print("Only reviewers may resign electronically.")
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
                elif "CONSTRAINT `fk_ReviewerInterests_RICodes" in str(e):
                    print("RICode is invalid")
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
