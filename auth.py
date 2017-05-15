#!/usr/bin/env python

import hashlib
import getpass


def hashPassword(password, salt):
    return hashlib.sha512(password + salt).hexdigest()


def register(con, userId, userType, password, salt):
	hashedPassword = hashPassword(password, salt)
	query = "INSERT INTO Credential (UserId,UserType,Password) VALUES (%d,'%s','%s');" % (userId, userType, hashedPassword)
	cursor = con.cursor(buffered=True)
	cursor.execute(query)
	cursor.close()

	userString = "TEAM11-%s" % (userType[0] + str(userId).zfill(3))

	query = "CREATE USER `%s`@'sunapee.cs.dartmouth.edu' IDENTIFIED BY '%s';" % (userString, password)
	print(query)
	# cursor = con.cursor(buffered=True)
	# cursor.execute(query)

	print('Warnings: %s' % cursor.fetchwarnings())
	# cursor.close()

	if userType == "PrimaryAuthor":
		query = "GRANT SELECT (`Title`,`Status`), INSERT ON `devina_db`.`Manuscript` TO `%s`@'sunapee.cs.dartmouth.edu';" % userString
		print(query)
		# cursor = con.cursor(buffered=True)
		# cursor.execute(query)
		# cursor.close()
	elif userType == "Editor":
		query = "GRANT ALL ON `devina_db`.`Manuscript` TO `%s`@'sunapee.cs.dartmouth.edu';" % userString
		query2 = "GRANT ALL ON `devina_db`.`Review` TO `%s`@'sunapee.cs.dartmouth.edu';" % userString
		print(query)
		print(query2)
		# cursor = con.cursor(buffered=True)
		# cursor2 = con.cursor(buffered=True)
		# cursor.execute(query)
		# cursor2.execute(query2)
		# cursor.close()
		# cursor2.close()
	elif userType == "Reviewer":
		query = "GRANT SELECT ON `devina_db`.`Manuscript` TO `%s`@'sunapee.cs.dartmouth.edu';" % userString
		query2 = "GRANT INSERT ON `devina_db`.`Review` TO `%s`@'sunapee.cs.dartmouth.edu';" % userString
		print(query)
		print(query2)
		# cursor = con.cursor(buffered=True)
		# cursor2 = con.cursor(buffered=True)
		# cursor.execute(query)
		# cursor2.execute(query2)
		# cursor.close()
		# cursor2.close()

	con.commit()
	return


def checkPassword(con, userId, userType, salt):
	# Ask for password
	password = getpass.getpass()
	hashedPassword = hashPassword(password, salt)

	# Check password versus database
	query = "SELECT COUNT(*) FROM Credential WHERE UserId = %d AND UserType = '%s' AND Password = '%s'" % (userId, userType, hashedPassword)
	cursor = con.cursor(buffered=True)
	cursor.execute(query)
	result = cursor.fetchone()

	cursor.close()

	if result[0] == 1:
		return True
	else:
		return False


def createPassword():
	# Prompt for password
	password1 = getpass.getpass("Please enter a password: ")
	password2 = getpass.getpass("Please confirm password: ")

	# Make sure they match
	if password1 != password2:
		print("Passwords do not match")
		return False
	elif len(password1) < 3:
		print("Password must be at least 3 characters")
		return False

	return password1