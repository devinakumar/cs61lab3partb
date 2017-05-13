class PrimaryAuthor:
    def __init__(self, id, connection):
        self.id = id
        self.con = connection

    def register(self, fname, lname, email, address):
        return

    def greeting(self):
        # Retrieve basic information
        query = "SELECT FirstName, LastName, MailingAddress FROM PrimaryAuthor WHERE PrimaryAuthorId = %d;" % self.id

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)
        info = cursor.fetchone()

        fullName = "%s %s" % (info[0], info[1])
        mailingAddress = info[2]

        print "Welcome back, %s!" % fullName
        print "Your mailing address is %s\n" % mailingAddress

        cursor.close()

    def status(self):
        # Retrieve manuscript status counts
        query = "SELECT Status, COUNT(*) as `Number` FROM Manuscript WHERE PrimaryAuthorId = %d GROUP BY Status;" % self.id

        # initialize a cursor and query db
        cursor = self.con.cursor()
        cursor.execute(query)

        print "Manuscripts:"
        for row in cursor:
            print("".join(["{}: {}".format(col) for col in row]))

        cursor.close()

    def submit(self, title, affiliation, ri, secondaryAuths, filename):
        return

    def retract(self, manuscriptId):
        return
