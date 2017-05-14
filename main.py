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
REGISTER_EDITOR_ERROR = "Invalid. Usage: register editor FirstName LastName"
REGISTER_AUTHOR_ERROR = "Invalid. Usage: register author FirstName LastName Email \"MailingAddress\""
REGISTER_REVIEWER_ERROR = "Invalid. Usage: register reviewer FirstName LastName Email Affiliation RICode [RICode] [RICode]"


def login(input):
    try:
        userType = input[1].capitalize()
        userId = int(input[2])

        if userType == "Author":
            userType = "PrimaryAuthor"

        query = "SELECT COUNT(*) FROM %s WHERE %sId = %d;" % (userType, userType, userId)

        # initialize a cursor
        cursor = con.cursor()

        # query db
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
        if userType == "Author":
            userType = "PrimaryAuthor"

        if userType == "Editor":
            registerEditor(con, input)
        elif userType == "Reviewer":
            registerReviewer(con, input)
        elif userType == "PrimaryAuthor":
            registerAuthor(con, input)
    except(ValueError, IndexError, NameError):
        print(REGISTER_ERROR)


def registerEditor(con, input):
    try:
        if len(input) == 4 and input[2] is not None and input[3] is not None:
            fname = input[2]
            lname = input[3]

            query = "INSERT INTO Editor (FirstName, LastName) VALUES ('%s', '%s')" % (fname, lname)

            # initialize a cursor and query db
            cursor = con.cursor()
            cursor.execute(query)
            con.commit()

            print("Created an editor with ID=%s" % cursor.lastrowid)
            cursor.close()
        else:
            print(REGISTER_EDITOR_ERROR)
    except(ValueError, IndexError, NameError):
        print(REGISTER_EDITOR_ERROR)


def registerReviewer(con, input):
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
            registerReviewerInterest(con, int(reviewerID), int(input[6 + x]))

        con.commit()
        print("Created a reviewer with ID=%s" % reviewerID)
        cursor.close()
    except (ValueError, NameError, IndexError, TypeError):
        print(REGISTER_REVIEWER_ERROR)


def registerReviewerInterest(con, reviewerID, ri):
    try:
        query = "INSERT INTO ReviewerInterests (RICode, ReviewerId) VALUES (%d, %d)" % (ri, reviewerID)
        cursor = con.cursor()
        cursor.execute(query)
        cursor.close()
    except(ValueError, IndexError, NameError, TypeError):
        print(REGISTER_REVIEWER_ERROR)


def registerAuthor(con, input):
    try:
        if len(input) == 6 and input[2] is not None and input[3] is not None and input[4] is not None and input[5] is not None:
            fname = input[2]
            lname = input[3]
            email = input[4]
            address = input[5]

            query = "INSERT INTO PrimaryAuthor (FirstName, LastName, Email, MailingAddress) VALUES ('%s', '%s', '%s', '%s')" % (fname, lname, email, address)
            cursor = con.cursor()
            cursor.execute(query)
            con.commit()
            print("Created an author with ID=%s" % cursor.lastrowid)
            cursor.close()
        else:
            print(REGISTER_AUTHOR_ERROR)
    except (ValueError, IndexError, NameError, TypeError):
        print(REGISTER_AUTHOR_ERROR)

if __name__ == "__main__":
    try:
        # initialize db connection
        con = mysql.connector.connect(host=config.SERVER, user=config.USERNAME, password=config.PASSWORD, database=config.DATABASE)

        running = True
        while running:
            try:
                input = shlex.split(raw_input('> '))
                command = input[0]

                # print(command)

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
                        user.assign(int(input[1]), int(input[2]))
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
                        user.reject(int(input[1]))
                    else:
                        print("Only editors may reject manuscripts.")
                elif command == 'accept':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.accept(int(input[1]))
                    else:
                        print("Only editors may accept manuscripts.")
                elif command == 'typeset':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.typeset(int(input[1]), int(input[2]))
                    else:
                        print("Only editors may typeset manuscripts.")
                elif command == 'schedule':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.schedule(int(input[1]), int(input[2]), input[3])
                    else:
                        print("Only editors may schedule manuscripts.")
                elif command == 'publish':
                    # print(type(user))
                    if isinstance(user, Editor):
                        user.publish(int(input[1]), input[2])
                    else:
                        print("Only editors may publish manuscripts.")
                elif command == 'review':
                    # print(type(user))
                    if isinstance(user, Reviewer):
                        user.review(input[1], int(input[2]), int(input[3]), int(input[4]), int(input[5]), int(input[6]))
                    else:
                        print("Only Reviewers may reviewer manuscripts.")
                elif command == 'retract':
                    if isinstance(user, PrimaryAuthor):
                        user.retract(input)
                    else:
                        print("Only authors may retract manuscripts.")
                elif command == 'quit':
                    running = False

                # reset db connection
                con = mysql.connector.connect(host=config.SERVER, user=config.USERNAME, password=config.PASSWORD, database=config.DATABASE)
            except mysql.connector.Error as e:        # catch SQL errors
                con.rollback()
                print("Invalid: {0}".format(e.msg))
    except:                                   # anything else
        print("Unexpected error: {0}".format(sys.exc_info()[0]))

    # cleanup
    try:
        con.close()
    except NameError:
        pass

    print("\nConnection terminated.\n\n", end='')
