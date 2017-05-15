-- MySQL Workbench Synchronization
-- Generated: 2017-04-27 20:11
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Devina

USE `devina_db`;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
SET SQL_SAFE_UPDATES=0;

DROP TABLE IF EXISTS `devina_db`.`Manuscript`;
DROP TABLE IF EXISTS `devina_db`.`PrimaryAuthor`;
DROP TABLE IF EXISTS `devina_db`.`SecondaryAuthor`;
DROP TABLE IF EXISTS `devina_db`.`Editor`;
DROP TABLE IF EXISTS `devina_db`.`RICodes`;
DROP TABLE IF EXISTS `devina_db`.`ReviewerInterests`;
DROP TABLE IF EXISTS `devina_db`.`Reviewer`;
DROP TABLE IF EXISTS `devina_db`.`Review`;
DROP TABLE IF EXISTS `devina_db`.`JournalIssue`;
DROP TABLE IF EXISTS `devina_db`.`Credential`;

DROP TRIGGER IF EXISTS Manuscript_RICode;
DROP TRIGGER IF EXISTS Reviewer_Resigns;

CREATE TABLE IF NOT EXISTS `devina_db`.`Manuscript` (
  `ManuscriptId` INT(11) NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(45) NOT NULL,
  `DateReceived` DATETIME NOT NULL,
  `Status` ENUM('Received', 'Rejected', 'Under Review', 'Typeset', 'Accepted', 'Scheduled', 'Published') NOT NULL,
  `RICode` MEDIUMINT NOT NULL,
  `PrimaryAuthorId` INT(11) NOT NULL,
  `EditorId` INT(11) NOT NULL,
  `PagesOccupied` INT(11) NULL DEFAULT NULL,
  `StartingPage` INT(11) NULL DEFAULT NULL,
  `Order` INT(11) NULL DEFAULT NULL,
  `Document` VARCHAR(100) NOT NULL,
  `JournalIssueYear` INT(11) NULL DEFAULT NULL,
  `JournalIssuePeriod` ENUM('1', '2', '3', '4') NULL DEFAULT NULL,
  `PrimaryAuthorAffiliation` VARCHAR(100) NOT NULL,
  `DateAcceptReject` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`ManuscriptId`),
  INDEX `fk_Manuscript_RICodes_idx` (`RICode` ASC),
  INDEX `fk_Manuscript_PrimaryAuthor1_idx` (`PrimaryAuthorId` ASC),
  INDEX `fk_Manuscript_Editor1_idx` (`EditorId` ASC),
  INDEX `fk_Manuscript_JournalIssue2_idx` (`JournalIssueYear` ASC, `JournalIssuePeriod` ASC),
  CONSTRAINT `fk_Manuscript_RICodes`
    FOREIGN KEY (`RICode`)
    REFERENCES `devina_db`.`RICodes` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Manuscript_PrimaryAuthor1`
    FOREIGN KEY (`PrimaryAuthorId`)
    REFERENCES `devina_db`.`PrimaryAuthor` (`PrimaryAuthorId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Manuscript_Editor1`
    FOREIGN KEY (`EditorId`)
    REFERENCES `devina_db`.`Editor` (`EditorId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Manuscript_JournalIssue2`
    FOREIGN KEY (`JournalIssueYear` , `JournalIssuePeriod`)
    REFERENCES `devina_db`.`JournalIssue` (`Year` , `Period`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


CREATE TABLE    RICodes
  ( code        MEDIUMINT NOT NULL AUTO_INCREMENT,
    interest    varchar(64) NOT NULL,
    PRIMARY KEY (code)
  );

INSERT INTO RICodes (interest) VALUES
('Agricultural engineering'),
('Biochemical engineering'),
('Biomechanical engineering'),
('Ergonomics'),
('Food engineering'),
('Bioprocess engineering'),
('Genetic engineering'),
('Human genetic engineering'),
('Metabolic engineering'),
('Molecular engineering'),
('Neural engineering'),
('Protein engineering'),
('Rehabilitation engineering'),
('Tissue engineering'),
('Aquatic and environmental engineering'),
('Architectural engineering'),
('Civionic engineering'),
('Construction engineering'),
('Earthquake engineering'),
('Earth systems engineering and management'),
('Ecological engineering'),
('Environmental engineering'),
('Geomatics engineering'),
('Geotechnical engineering'),
('Highway engineering'),
('Hydraulic engineering'),
('Landscape engineering'),
('Land development engineering'),
('Pavement engineering'),
('Railway systems engineering'),
('River engineering'),
('Sanitary engineering'),
('Sewage engineering'),
('Structural engineering'),
('Surveying'),
('Traffic engineering'),
('Transportation engineering'),
('Urban engineering'),
('Irrigation and agriculture engineering'),
('Explosives engineering'),
('Biomolecular engineering'),
('Ceramics engineering'),
('Broadcast engineering'),
('Building engineering'),
('Signal Processing'),
('Computer engineering'),
('Power systems engineering'),
('Control engineering'),
('Telecommunications engineering'),
('Electronic engineering'),
('Instrumentation engineering'),
('Network engineering'),
('Neuromorphic engineering'),
('Engineering Technology'),
('Integrated engineering'),
('Value engineering'),
('Cost engineering'),
('Fire protection engineering'),
('Domain engineering'),
('Engineering economics'),
('Engineering management'),
('Engineering psychology'),
('Ergonomics'),
('Facilities Engineering'),
('Logistic engineering'),
('Model-driven engineering'),
('Performance engineering'),
('Process engineering'),
('Product Family Engineering'),
('Quality engineering'),
('Reliability engineering'),
('Safety engineering'),
('Security engineering'),
('Support engineering'),
('Systems engineering'),
('Metallurgical Engineering'),
('Surface Engineering'),
('Biomaterials Engineering'),
('Crystal Engineering'),
('Amorphous Metals'),
('Metal Forming'),
('Ceramic Engineering'),
('Plastics Engineering'),
('Forensic Materials Engineering'),
('Composite Materials'),
('Casting'),
('Electronic Materials'),
('Nano materials'),
('Corrosion Engineering'),
('Vitreous Materials'),
('Welding'),
('Acoustical engineering'),
('Aerospace engineering'),
('Audio engineering'),
('Automotive engineering'),
('Building services engineering'),
('Earthquake engineering'),
('Forensic engineering'),
('Marine engineering'),
('Mechatronics'),
('Nanoengineering'),
('Naval architecture'),
('Sports engineering'),
('Structural engineering'),
('Vacuum engineering'),
('Military engineering'),
('Combat engineering'),
('Offshore engineering'),
('Optical engineering'),
('Geophysical engineering'),
('Mineral engineering'),
('Mining engineering'),
('Reservoir engineering'),
('Climate engineering'),
('Computer-aided engineering'),
('Cryptographic engineering'),
('Information engineering'),
('Knowledge engineering'),
('Language engineering'),
('Release engineering'),
('Teletraffic engineering'),
('Usability engineering'),
('Web engineering'),
('Systems engineering');

CREATE TABLE IF NOT EXISTS `devina_db`.`PrimaryAuthor` (
  `PrimaryAuthorId` INT(11) NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `MailingAddress` VARCHAR(150) NOT NULL,
  `Affiliation` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`PrimaryAuthorId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `devina_db`.`SecondaryAuthor` (
  `BylinePosition` INT(11) NOT NULL,
  `ManuscriptId` INT(11) NOT NULL,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`BylinePosition`, `ManuscriptId`),
  INDEX `fk_SecondaryAuthor_Manuscript1_idx` (`ManuscriptId` ASC),
  CONSTRAINT `fk_SecondaryAuthor_Manuscript1`
    FOREIGN KEY (`ManuscriptId`)
    REFERENCES `devina_db`.`Manuscript` (`ManuscriptId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `devina_db`.`Reviewer` (
  `ReviewerId` INT(11) NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `Affiliation` VARCHAR(100) NOT NULL,
  `Retired` TINYINT(4) NOT NULL,
  PRIMARY KEY (`ReviewerId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `devina_db`.`Review` (
  `ManuscriptId` INT(11) NOT NULL,
  `ReviewerId` INT(11) NOT NULL,
  `Appropriateness` ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NULL DEFAULT NULL,
  `Clarity` ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NULL DEFAULT NULL,
  `Methodology` ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NULL DEFAULT NULL,
  `ContributionField` ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10') NULL DEFAULT NULL,
  `Recommendation` ENUM('Accept', 'Reject') NULL DEFAULT NULL,
  `DateSent` DATETIME NOT NULL,
  `DateCompleted` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`ManuscriptId`, `ReviewerId`),
  INDEX `fk_Review_Reviewer1_idx` (`ReviewerId` ASC),
  INDEX `fk_Review_Manuscript1_idx` (`ManuscriptId` ASC),
  CONSTRAINT `fk_Review_Reviewer1`
    FOREIGN KEY (`ReviewerId`)
    REFERENCES `devina_db`.`Reviewer` (`ReviewerId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Review_Manuscript1`
    FOREIGN KEY (`ManuscriptId`)
    REFERENCES `devina_db`.`Manuscript` (`ManuscriptId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `devina_db`.`Editor` (
  `EditorId` INT(11) NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(45) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`EditorId`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `devina_db`.`JournalIssue` (
  `Year` INT(11) NOT NULL,
  `Period` ENUM('1', '2', '3', '4') NOT NULL,
  `PrintDate` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`Year`, `Period`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `devina_db`.`ReviewerInterests` (
  `RICode` MEDIUMINT NOT NULL,
  `ReviewerId` INT(11) NOT NULL,
  PRIMARY KEY (`RICode`, `ReviewerId`),
  INDEX `fk_ReviewerInterests_Reviewer1_idx` (`ReviewerId` ASC),
  CONSTRAINT `fk_ReviewerInterests_Reviewer1`
    FOREIGN KEY (`ReviewerId`)
    REFERENCES `devina_db`.`Reviewer` (`ReviewerId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ReviewerInterests_RICodes1`
    FOREIGN KEY (`RICode`)
    REFERENCES `devina_db`.`RICodes` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
PACK_KEYS = Default;

CREATE TABLE IF NOT EXISTS `devina_db`.`Credential` (
  `UserId` INT(11) NOT NULL,
  `UserType` ENUM('PrimaryAuthor', 'Reviewer', 'Editor') NOT NULL,
  `Password` VARCHAR(512),
  PRIMARY KEY (`UserId`,`UserType`)
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
PACK_KEYS = Default;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `devina_db`.`Manuscript`;
TRUNCATE TABLE `devina_db`.`PrimaryAuthor`;
TRUNCATE TABLE `devina_db`.`SecondaryAuthor`;
TRUNCATE TABLE `devina_db`.`Editor`;
-- TRUNCATE TABLE `devina_db`.`RICodes`;
TRUNCATE TABLE `devina_db`.`ReviewerInterests`;
TRUNCATE TABLE `devina_db`.`Reviewer`;
TRUNCATE TABLE `devina_db`.`Review`;
TRUNCATE TABLE `devina_db`.`JournalIssue`;
TRUNCATE TABLE `devina_db`.`Credential`;

SET FOREIGN_KEY_CHECKS = 1;

DROP VIEW IF EXISTS LeadAuthorManuscripts;
DROP VIEW IF EXISTS AnyAuthorManuscripts;
DROP VIEW IF EXISTS PublishedIssues;
DROP VIEW IF EXISTS ReviewQueue;
DROP VIEW IF EXISTS WhatsLeft;
DROP VIEW IF EXISTS ReviewStatus;

-- View: LeadAuthorManuscripts

-- For all authors, their basic information (name etc.) and
-- the manuscript(s) for which they are the primary author (if any),
-- along with the status of the manuscript(s).
-- Results ordered by author last name and then by increasing submission timestamp.
-- Permissions: Editor.

CREATE VIEW LeadAuthorManuscripts (`FirstName`,`LastName`,`Title`,`Status`,`DateReceived`)
AS
  SELECT p.FirstName as FirstName, p.LastName as LastName, m.Title as Title, m.`Status`, m.DateReceived FROM Manuscript as m
    INNER JOIN PrimaryAuthor as p ON m.PrimaryAuthorId = p.PrimaryAuthorId
  UNION
  SELECT s.FirstName as FirstName, s.LastName as LastName, NULL, NULL, NULL FROM SecondaryAuthor as s
  ORDER BY LastName ASC, DateReceived ASC;


-- View: AnyAuthorManuscripts

-- For all authors, their name and the manuscript(s) for which they
-- are among the authors (if any), along with the status of the manuscript(s).
-- Results ordered by author last name and then by increasing submission timestamp.
-- Permissions: Author, Editor.

CREATE VIEW AnyAuthorManuscripts (`FirstName`,`LastName`,`Title`,`Status`,`DateReceived`)
AS
  SELECT p.FirstName as FirstName, p.LastName as LastName, m.Title as Title, m.`Status` as `Status`, m.DateReceived as DateReceived
  FROM Manuscript as m
  INNER JOIN PrimaryAuthor as p ON m.PrimaryAuthorId = p.PrimaryAuthorId
  UNION
  SELECT s.FirstName as FirstName, s.LastName as LastName, m.Title as Title, m.`Status` as `Status`, m.DateReceived as DateReceived
  FROM SecondaryAuthor as s
  INNER JOIN Manuscript as m ON m.ManuscriptId = s.ManuscriptId
  ORDER BY LastName ASC, DateReceived ASC;

-- View: PublishedIssues

-- For all completed (published) issues, the issue year, issue number (1, 2, 3, or 4),
-- the title of each manuscript included in that issue, with page numbers, ordered by
-- issue name and page numbers.
-- Permissions: Author, Editor, Reviewer.

CREATE VIEW PublishedIssues (`Year`,`Number`,`Title`,`StartingPage`,`PagesOccupied`)
AS
  SELECT j.Year as Year, j.Period as Period, m.Title as Title, m.StartingPage as StartingPage, m.PagesOccupied as PagesOccupied
  FROM Manuscript as m
  INNER JOIN JournalIssue as j ON j.Year = m.JournalIssueYear AND j.Period = m.JournalIssuePeriod
  WHERE j.PrintDate IS NOT NULL
  ORDER BY j.Year, j.Period, m.StartingPage;


-- View: ReviewQueue

-- For all manuscripts in UnderReview state. The primary author, manuscript id,
-- and assigned reviewer(s) are included, ordered by increasing manuscript
-- submission timestamp is included in the view. Also used by ReviewStatus view.
-- Permissions: Editor.

CREATE VIEW ReviewQueue (`FirstName`,`LastName`,`ManuscriptId`,`ReviewerFirstName`,`ReviewerLastName`,`DateReceived`)
AS
  SELECT p.FirstName as FirstName, p.LastName as LastName, m.ManuscriptId as ManuscriptId,
    rwr.FirstName as ReviewerFirstName, rwr.LastName as ReviewerLastName, m.DateReceived as DateReceived
  FROM Manuscript as m
  INNER JOIN PrimaryAuthor as p ON p.PrimaryAuthorId = m.PrimaryAuthorId
  INNER JOIN Review as r ON r.ManuscriptId = m.ManuscriptId
  INNER JOIN Reviewer as rwr ON rwr.ReviewerId = r.ReviewerId
  WHERE m.`Status` = 'Under Review'
  ORDER BY m.DateReceived;

-- View: WhatsLeft

-- For all manuscripts, the current status and the remaining steps
-- (e.g., ‘underreview’, typeset’, etc.) following the current status.
-- When a manuscript is in ‘underreview’ state its next step will be either
-- ‘accepted’ or ‘rejected’.
-- Permissions: Editor.

-- Status:
  -- Received --> Under Review/Rejected
  -- Under Review --> Accepted/Rejected
  -- Accepted --> Typeset
  -- Typeset --> Scheduled
  -- Scheduled --> Published
  -- Published --> N/A
  -- Rejected --> N/A

CREATE VIEW WhatsLeft (`ManuscriptId`,`Title`,`Status`,`NextStep`)
AS
  SELECT ManuscriptId, Title, `Status`,
    ( CASE
      WHEN `Status`='Received' THEN 'Under Review/Rejected'
      WHEN `Status`='Under Review' THEN 'Accepted/Rejected'
      WHEN `Status`='Accepted' THEN 'Typeset'
      WHEN `Status`='Typeset' THEN 'Scheduled'
      WHEN `Status`='Scheduled' THEN 'Published'
      WHEN `Status`='Published' THEN 'N/A'
      WHEN `Status`='Rejected' THEN 'N/A'
      END
        ) AS NextStep
  FROM Manuscript
  ORDER BY `Status`;


-- View: ReviewStatus

-- For all manuscripts assigned to the Reviewer, a view including:

-- -   the timestamp when it was assigned to this review
-- -   the manuscript id
-- -   the manuscript title
-- -   the review results (integer values 1-10)
--     -   appropriateness
--     -   clarity
--     -   methodology
--     -   contribution to the field
-- -   recommendation (either "accept" or "reject") ordered by increasing submission timestamp.  **Permissions: Editor, Reviewer.**

CREATE VIEW ReviewStatus (`ManuscriptId`,`ManuscriptTitle`,`DateSent`,`Appropriateness`,`Clarity`,`Methodology`,`ContributionField`,`Recommendation`)
AS
  SELECT m.ManuscriptId as ManuscriptId, m.Title as ManuscriptTitle, r.DateSent as DateSent, r.Appropriateness as Appropriateness,
    r.Clarity as Clarity, r.Methodology as Methodology, r.ContributionField as ContributionField, r.Recommendation as Recommendation
  FROM Review as r
    INNER JOIN Manuscript as m ON r.ManuscriptId = m.ManuscriptId
  ORDER BY r.DateCompleted;



-- Trigger 1: When an author is submitting a new manuscript
-- to the system with an RICode for which there is no reviewer
-- who handles that RICode you should raise an exception that
-- informs the author the paper can not be considered at this time.

DELIMITER /

CREATE TRIGGER Manuscript_RICode BEFORE INSERT ON Manuscript
FOR EACH ROW
BEGIN
  DECLARE signal_message VARCHAR(128);
  IF ((SELECT COUNT(*) FROM ReviewerInterests AS ri
      INNER JOIN Reviewer AS r ON r.ReviewerId = ri.ReviewerId
      WHERE r.Retired = '0' AND ri.RICode = new.RICode)
    < 3)
  THEN
    SET signal_message = CONCAT('UserException1001: Less than 3 reviewers are interested in the RICode =', CAST(new.RICode as CHAR));
    SIGNAL SQLSTATE '45000' SET message_text = signal_message;
  END IF;
END
/

DELIMITER ;

-- Trigger 2: When a reviewer resigns any manuscript in
-- “UnderReview” state for which that reviewer was the only
-- reviewer, that manuscript must be reset to “submitted”
-- state and an apprpriate exception message displayed.

DELIMITER /

CREATE TRIGGER Reviewer_Resigns BEFORE UPDATE ON Reviewer
FOR EACH ROW
BEGIN
  IF (new.Retired = '1' AND old.Retired = '0')
  THEN
    -- Here we need to set all manuscripts with <3 reviewers
    -- that was in a "UnderReview" state to "Received"
    -- However, since the update hasn't happened yet,
    -- we need to set any where manuscript <= 3 reviewers
    UPDATE Manuscript SET `Status` = 'Received'
    WHERE `Status` = 'Under Review' AND ManuscriptId IN (
      SELECT ManuscriptId FROM Review as r
      INNER JOIN Reviewer as v ON v.ReviewerId = r.ReviewerId
            WHERE v.Retired = '0' AND  r.ManuscriptId IN (
        SELECT r2.ManuscriptId FROM Review as r2
                WHERE r2.ReviewerId = old.ReviewerId
      )
            GROUP BY r.ManuscriptId
            HAVING COUNT(r.ManuscriptId) < 4
    );
  END IF;
END
/

DELIMITER ;
