## CS 61 Lab 2, Part 5
### Author functionality:


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


### Editor functionality:


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












