## CS 61 Lab 2, Part 5
### Setup
Replace information in config.py with the appropriate testing information (if it is not the login you wish to use)


Run setup.sql on the database you choose to use


### Functionalities
QUIT: A user may quit out of the program at any time using the following command:


```quit```


#### Author functionality:


REGISTER: A user may register an author using the following command:


```register author [fname] [lname] [email] “[mailing address]”```


LOGIN: A user may login to an author account using the following command:


```login author [authorID]```


This will also be followed by the output from the "Status" command.


STATUS: A user may show the status of his or her author account, which will provide a summary of the number of manuscripts in various phases. Please note that using the "List" command will show specific information about manuscripts with which the author is associated as a primary author. An author may see status using the following command:


```status```


LIST: This command shows specific information about the manuscripts with which the author is associated as a primary author. An author may see his or her list of manuscripts using the following command:


```list```


SUBMIT: This command allows authors to submit manuscripts for which he or she is the primary author. This command provides the title, the author's current affiliation (a string), RICode representing the subject area, optional additional authors, and the document itself (we made this a string as per our discussion in class). An author may submit a manuscript with the following command:


```submit [title] [affilation] [RICode] [author2] [author3] [author4] [documentString]```


RETRACT: This command allows authors to retract a manuscript from the system. This command asks if the author is sure.  If the answer is yes, then the secondary authors, reviews, and manuscript from the system. An author may retract a manuscript with the following command:


```retract [manuscriptID]```


#### Editor functionality:


REGISTER: A user may register an editor using the following command:


```register editor [fname] [lname]```


LOGIN: A user may login to an editor account using the following command:


```login author [editorID]```


This will also be followed by the output from the "Status" command.


STATUS: A user may show the status of his or her editor account, which will provide a summary of the number of manuscripts in various phases. Please note that using the "List" command will show specific information about manuscripts with which the editor is associated. An editor may see status using the following command:


```status```


LIST: This command shows specific information about the manuscripts with which the editor is associated. An editor may see his or her list of manuscripts using the following command:


```list```

ASSIGN: This command assigns a manuscript to a reviewer to be reviewed.  This command ensures that the editor has the authority to assign the manuscript, that the reviewer is not retired, that the manuscript is not already published/typeset, and that the reviewer has an interest in the field of the manuscript.  This creates a blank review for the reviewer that the reviewer may fill out at his or her discretion.  An editor may assign a manuscript for review using the following command:


```assign [manuscriptID] [reviewerID]```


REJECT: This command sets the status of a manuscript to "Rejected."  This command ensures that the editor has the authority to reject the manuscript and that the manuscript is in a stage that allows it to be rejected.  Then, this command marks the time that the decision was made and sets the status of the manuscript to "Rejected."  An editor may reject a manuscript with the following command:


```reject [manuscriptID]```


ACCEPT: This command sets the status of a manuscript to "Accepted."  This command ensures that the editor has the authority to accept the manuscript, that the manuscript is in the appropriate stage to be accepted and that the manuscript has at least 3 completed reviews associated with it.  Then, the command marks that time that the decision was made and sets the status of the manuscript to "Accepted.""  An editor may accept a manuscript with the following command:


```accept [manuscriptID]```


TYPESET: This command sets the status of a manuscript to "Typeset."  This command ensures that the editor has the authority to typeset the manuscript and that the manuscript is in the appropriate stage to be typeset.  Then, the command updates the status to "Typeset" and stores the number of pages that the manuscript will occupy.  An editor may typeset a manuscript with the following command:


```typeset [manuscriptID] [pagesOccupied]```


SCHEDULE: This command sets the status of a manuscript to "Scheduled" and assigns it to the appropriate issue.  This command ensures that the year and issue number the editor enters are valid (no past years, no invalid issue numbers), that the editor has the authority to schedule the manuscript, that the manuscript is in the appropriate stage to be scheduled (typeset), that the issue in question has not already been published, that the issue in question exists (if not, then it is created) and that adding the manuscript would not exceed the 100-page limit per issue.  Then, the command updates the status of the manuscript to "Scheduled" and updates the issue number and year.  Unlike the command provided to us in the spec, we decided to implement this by dividing issue into its components, year and period, on the command line.  An editor may schedule a manuscript with the following command:


```schedule [manuscriptID] [Year] [Period]```


PUBLISH: This command publishes an issue and sets the status of all its manuscripts to "Published."  This command ensures that the issue exists, that it has not already been published and that the issue contains at least 1 manuscript.  Then, the command updates the print date (assumed to be the date/time that the publish decision is made because this causes the issue to be sent for publication) and updates the status of all of the manuscripts in the issue to "Published."  An editor may publish an issue with the following command:


```publish [Year] [Period]```


#### Reviewer functionality:


REGISTER: This command registers a reviewer.  We collect information about a reviewer's affiliation and email because this is one of the only opportunities to do so.  This command also assumed that users are not retired upon registration.  A user may register a reviewer using the following command:


```register reviewer [fname] [lname] [email] "[affiliation]" [RICode1] [RICode2] [RICode3] ```


RESIGN: This command resigns a reviewer.  This command updates the Retired field of a user, and thanks the user, and logs out the user.  The reviews that a resigned reviewer has not completed will not appear in the tallies for valid reviews to determine manuscript approval.  In addition, the user will not be able to login after resigning.  A reviewer may resign using the following command:


```resign```


LOGIN: A user may login to a reviewer account using the following command:


```login reviewer [reviewerID]```


This will also be followed by the output from the "Status" command.


STATUS: A user may show the status of his or her reviewer account, which will provide a summary of the number of manuscripts in various phases associated with the reivewer. Please note that using the "List" command will show specific information about manuscripts with which the reviewer is associated. A reviewer may see status using the following command:


```status```


LIST: This command shows specific information about the manuscripts with which the reviewer is associated. A reviewer may see his or her list of manuscripts using the following command:


```list```


REVIEW: This command allows a reviewer to submit a review about a specific manuscript.  This command checks that the reviewer has the authority to review the manuscript and that the manuscript is under review.  The manuscript records the timestamp of the recommendation(accept/reject) and notes all the scores in the review table.  We designed this command so that a reviewer may revise his or her review.  A reviewer may review a manuscript with the following command:


```review [recommendation] [manuscriptID] [appropriateness] [clarity] [methodology] [contributionToField]```


### Testing

NOTE: The things in the parentheses are just what the program returned to us, but the password and IDs will likely vary depending on how many times you register a new user/your password choice.  We just included it as a reference.


Please run the following command to start the program:


```python main.py```


The program will prompt you for a key to connect to the database.  Please enter this as the key:


```test```

#### Test register functions
To test the register function, please register an editor, an author, and a reviewer.  Please note down the passwords and IDs that you use/the system returns to you.

Editor: ```register editor Devina Kumar``` (password: devina, id: 101)

Author: ```register author Henry Wilson henry.wilson.iii.18@dartmouth.edu "Hinman 1201"``` (password: henry, id: 101)

Reviewer: ```register reviewer Charles Palmer charlespalmer@dartmouth.edu "Dartmouth" 1 2 3``` (password: charles, id: 101)


Using the IDs and passwords you just created, please use the ID for the editor you just created to log in: ```login editor 101```

After logging in, try logging out: ```logout```

#### Make a manuscript
Please log in to the account of the author you just created and enter the password when prompted: ```login author 101```

Submit a new manuscript: ```submit "My Manuscript" "Dartmouth" "1" "Devina Kumar" "Theodore Geisel" "Text here"``` (ManuscriptID: 18)

Check status (it should now show received as having 1 manuscript): ```status```

List the manuscripts (it should now show more specific information for the manuscript): ```list```

Log out from the author: ```logout```

#### Assign reviews
Now, to test the editor functions, please log in to editor 94's account using the password "test": ```login editor 94``` (password: test)

It should show one manuscript that is received.  Now, to get more information about the manuscript, we use the list command: ```list```

This should show the id of the manuscript (9).  We can now use this to assign the manuscript to reviewers:

```assign 9 7```

```assign 9 49```

```assign 9 54```

All of these reviewers have the appropriate RICodes, but let us try to assign this to a reviewer whose RICode is not compatible: ```assign 9 1```

The manuscript will not be assigned.  Now, let us try to assign a manuscript that does not belong to the editor: ```assign 4 9```

These commands should not have worked.  Now, if we use the status or list command again, we see that the manuscript has moved to the review stage: ```status```

Let us now log out of editor 94's account: ```logout```

#### Review a manuscript
Now, let us log in to reviewer 7's account using the password "test": ```login reviewer 7``` (password: test)

If we use enter the command ```list```, we can see that manuscript 9 is designated to this reviewer.  Let us now enter a review for manuscript 9: ```review accept 9 8 9 8 8```

Let us now log out of reviewer 7's account with the command ```logout``` and log in to reviewer 49's account using the password test: ```login reviewer 49``` (password: test)

Again, if we use enter the command ```list```, we can see that manuscript 9 is designated to this reviewer.  Let us now enter a review for manuscript 9: ```review reject 9 5 5 4 3```

Let us now log out of reviewer 49's account with the command ```logout``` and login to reviewer 54's account using the password test: ```login reviewer 54``` (password: test)

Again, if we use enter the command ```list```, we can see that manuscript 9 is designated to this reviewer.  Let us now enter a review for manuscript 9: ```review accept 9 8 7 9 9```

Let us now log out of reviewer 54's account: ```logout```


#### Accept/Typeset/Schedule/Publish a manuscript
Now, to test the editor functions, please log in to editor 94's account again using the password "test": ```login editor 94``` (password: test)

Accept the manuscript that we just reviewed: ```accept 9```

If we use the command ```list```, we can see that the status of 9 is now "Accepted."

Now, let us typeset manuscript 9, saying that it will take up 99 pages: ```typeset 9 99```

If we use the command ```list```, we can see that the status of 9 is now "Typeset."

Now, let us schedule manuscript 9 for issue 2 of 2016: ```schedule 9 2016 2```

This should exceed the 100-page limit.  Now, let us try to schedule the manuscript for issue 3 of 2016: ```schedule 9 2016 3```

If we use the command ```list```, we can see that the status of 9 is now "Scheduled."

Now, let us publish issue 3 of 2016: ```publish 2016 3```

If we use the command ```list```, we can see that the status of 9 is now "Published."

Let us now log out of editor 94's account: ```logout```


#### Other functions
Let us log in to an author who has submitted a manuscript using the password "test": ```login author 31``` (password: test)

Now, let us retract the manuscript: ```retract 4``` (enter "Yes" on prompt)

If we use the list command, we should see nothing: ```list```

Log out of author 31's account: ```logout```

Log in to reviewer 5's account using the password "test": ```login reviewer 5```

Resign reviewer 5: ```resign```

You should be logged out automatically.  Try logging into reviewer 5's account again: ```login reviewer 5```

You should not be able to log in.

Now, log in to editor 100's account using the password "test": ```login editor 100``` (password: test)

This editor is assigned to a manuscript whose RICode is an interest of ex-reviewer 5.  Let us try to assign reviewer 5 to review this manuscript: ```assign 7 5```

The system should not allow a review to be assigned to a reviewer who is retired.

Now, log out of editor 100's account: ```logout```

Quit the program if you wish: ```quit```

### Extra Credit Part 2 Notes
 I was unable to login to the User. Thus, I print out all the commands to run in the relevant places (when you register or when a reviewer resigns)

