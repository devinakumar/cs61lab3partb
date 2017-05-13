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


SERVER   = "sunapee.cs.dartmouth.edu"        # db server to connect to
USERNAME = "hwilson"                            # user to connect as
PASSWORD = "Password1"                            # user's password
DATABASE = "hwilson2_db"                              # db to user

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

    # # initialize a cursor
    # cursor = con.cursor()
    #
    # # query db
    # cursor.execute(query)
    # result = cursor.fetchone()

        if userType == "Editor":
            registerEditor(con, input[2], input[3])
        elif userType == "Reviewer":
            return Reviewer(userId, con)
        elif userType == "PrimaryAuthor":
            return PrimaryAuthor(userId, con)
    # cursor.close()
    except NameError, e:
        print(e)

def registerEditor(con, fname, lname):
    try:
        query = "INSERT INTO Editor (FirstName, LastName) VALUES ('%s', '%s')" % (fname,lname)

        # initialize a cursor and query db
        cursor = con.cursor()
        cursor.execute(query)
        con.commit()
        print("herere")
        # except:
        #     print("herereytftyf")
        #     con.rollback()
        cursor.close()


    except (ValueError,IndexError, NameError):
      print ("User does not exist")

if __name__ == "__main__":
   try:
      # initialize db connection
      con = mysql.connector.connect(host=SERVER,user=USERNAME,password=PASSWORD,database=DATABASE)

      running = True
      while running:
        try:
          input = shlex.split(raw_input('> '))
          command = input[0]

          if command == 'login':
            user = login(input)
            user.status()
          elif command == 'status':
            user.status()
          elif command == 'register':
            register(input, con)

        except mysql.connector.Error as e:        # catch SQL errors
            print("SQL Error: {0}".format(e.msg))
   except:                                   # anything else
      print("Unexpected error: {0}".format(sys.exc_info()[0]))

   # cleanup
   con.close()

   print("\nConnection terminated.", end='')
