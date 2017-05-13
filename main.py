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


SERVER = "sunapee.cs.dartmouth.edu"        # db server to connect to
USERNAME = "devina"                            # user to connect as
PASSWORD = "Devina.Kumar"                            # user's password
DATABASE = "devina_db"                              # db to user

user = None

def login(input):
  try:
    userType = input[1].capitalize()
    userId = int(input[2])

    if userType == "Author":
      userType = "PrimaryAuthor"

    query = "SELECT COUNT(*) FROM %s WHERE %sId = %d" % (userType,userType,userId)

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
  except (ValueError,IndexError):
    print ("User does not exist")

def register(input, con):
    try:
        userType = input[1].capitalize()
        if userType == "Author":
            userType = "PrimaryAuthor"

        if userType == "Editor":
            if len(input) == 4 and input[2] is not None and input[3] is not None:
                registerEditor(con, input[2], input[3])
            else:
                print("Please make sure that you have inputted values for first and last names.\nPlease follow this format: register editor FirstName LastName")
                return
        elif userType == "Reviewer":
            registerReviewer(con, input)
            return
        elif userType == "PrimaryAuthor":
            if len(input) == 6 and input[2] is not None and input[3] is not None and input[4] is not None and input[5] is not None:
                registerAuthor(con, input[2], input[3], input[4], input[5])
            else:
                print("Please register a new author using the following format:\n register author FirstName LastName Email \"MailingAddress\" [Affiliation]")
    # cursor.close()
    except(ValueError,IndexError, NameError):
        print("whoops")
    print("end")

def registerEditor(con, fname, lname):
    try:
        query = "INSERT INTO Editor (FirstName, LastName) VALUES ('%s', '%s')" % (fname,lname)

        # initialize a cursor and query db
        cursor = con.cursor()
        try:
            cursor.execute(query)
            con.commit()
        # print("herere")
        except(ValueError,IndexError, NameError):
            print("could not register editor")
            con.rollback()
        cursor.close()

    except(ValueError,IndexError, NameError):
      print("User does not exist")

def registerReviewer(con, input):
    print("in register reviewer beginning")
    riCodes = len(input) - 6
    if len(input) >= 7 and len(input) <= 9:
        fname = input[2]
        lname = input[3]
        email = input[4]
        affiliation = input[5]
        retired = 0
    else:
        print("Please register a reviewer with the following format:\nregister reviewer FirstName LastName Email Affiliation RICode [RICode] [RICode]")

    try:
        query = "INSERT INTO Reviewer (FirstName, LastName, Email, Affiliation, Retired) VALUES ('%s', '%s', '%s', '%s', '%s')" % (fname,lname, email, affiliation, retired)

        # initialize a cursor and query db
        cursor = con.cursor()
        try:
            cursor.execute(query)
            con.commit()
            reviewerID = cursor.lastrowid
            for x in range(0, riCodes):
                print(x)
                registerReviewerInterest(con, int(reviewerID), int(input[6+x]))
            # print(cursor.lastrowid)
            # print("herere")
        except IndexError, e:
            print(e)
            print("EXCEPT IN REGISTER REVIEWER")
            con.rollback()
        cursor.close()

    # except(ValueError,IndexError, NameError):
    #   print("User does not exist")
    except TypeError, e:
        print(e)

def registerReviewerInterest(con, reviewerID, ri):
    query = "INSERT INTO ReviewerInterests (RICode, ReviewerId) VALUES (%d, %d)" % (ri, reviewerID)
    cursor = con.cursor()
    try:
        cursor.execute(query)
        con.commit()
        print("registering reviewer interests")
    except(ValueError, IndexError, NameError):
        print("EXCEPT IN REGISTER REVIEWER INTEREST")
        con.rollback()
    cursor.close()


def registerAuthor(con, fname, lname, email, address):
    print("in register author beginning")
    print(fname, lname, email, address)
    # affiliation = None
    try:
        query = "INSERT INTO PrimaryAuthor (FirstName, LastName, Email, MailingAddress) VALUES ('%s', '%s', '%s', '%s')" % (fname,lname, email, address)

        # initialize a cursor and query db
        cursor = con.cursor()
        try:
            cursor.execute(query)
            con.commit()
            # print("herere")
        except(ValueError, IndexError, NameError):
            print("EXCEPT IN REGISTER AUTHOR")
            con.rollback()
        cursor.close()

    # except(ValueError,IndexError, NameError):
    #   print("User does not exist")
    except TypeError, e:
        print(e)


if __name__ == "__main__":
   try:
      # initialize db connection
      con = mysql.connector.connect(host=SERVER,user=USERNAME,password=PASSWORD,database=DATABASE)

      running = True
      while running:
        try:
          input = shlex.split(raw_input('> '))
          command = input[0]
          print(input)

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
            user.assign(int(input[1]), int(input[2]))
          elif command == 'submit':
            print(type(user))
            if isinstance(user, PrimaryAuthor):
              user.submit(input)
            else:
              print("Only authors may submit manuscripts.")

        except mysql.connector.Error as e:        # catch SQL errors
            print("SQL Error: {0}".format(e.msg))
   except:                                   # anything else
      print("Unexpected error: {0}".format(sys.exc_info()[0]))

   # cleanup
   con.close()

   print("\nConnection terminated.", end='')
