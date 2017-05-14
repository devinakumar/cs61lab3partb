#!/usr/bin/env python

import hashlib
import getpass


def hashPassword(password, salt):
    return hashlib.sha512(password + salt).hexdigest()


def register(con, userId, userType, password):
	query = "INSERT INTO Credential (UserId,UserType,Password) VALUES (%d,'%s','%s');" % (userId, userType, password)
	cursor = con.cursor(buffered=True)
	cursor.execute(query)
	cursor.close()
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


def createPassword(con, salt):
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

	# Hash it and register relevant user
	hashedPassword = hashPassword(password1, salt)

	return hashedPassword