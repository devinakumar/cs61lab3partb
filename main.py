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
from author import Author


SERVER   = "sunapee.cs.dartmouth.edu"        # db server to connect to
USERNAME = "hwilson"                            # user to connect as
PASSWORD = "Password1"                            # user's password
DATABASE = "hwilson2_db"                              # db to user

user = None

def login(input):
  try:
    userType = input[1].capitalize()
    userId = int(input[2])

    if userType not in ['Editor','Reviewer','Author']:
      return

    QUERY = "SELECT COUNT(*) FROM %s WHERE %sId = %d" % (userType,userType,userId)

    # initialize a cursor
    cursor = con.cursor()

    # query db
    cursor.execute(QUERY)
    result = cursor.fetchone()

    if result[0] == 1:
      if userType == "Editor":
        user = Editor(userId, con)
      elif userType == "Reviewer":
        user = Reviewer(userId, con)
      elif userType == "Author":
        user = Author(userId, con)

      print("Welcome, %d" % user.id)
      user.status()

    cursor.close()
  except (ValueError,IndexError):
    print ("User does not exist")

if __name__ == "__main__":
   try:
      # initialize db connection
      con = mysql.connector.connect(host=SERVER,user=USERNAME,password=PASSWORD,database=DATABASE)

      running = True

      while running:
        try:
          input = shlex.split(raw_input('> '))

          if input[0] == 'login':
            user = login(input)
          else:
            print("Ok")
        except ValueError:
          print("Invalid input")

   except mysql.connector.Error as e:        # catch SQL errors
      print("SQL Error: {0}".format(e.msg))
   except:                                   # anything else
      print("Unexpected error: {0}".format(sys.exc_info()[0]))

   # cleanup
   con.close()

   print("\nConnection terminated.", end='')