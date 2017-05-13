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
  `Document` BLOB NOT NULL,
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

SET FOREIGN_KEY_CHECKS = 1;

/*Editor*/
INSERT INTO Editor (FirstName,LastName) VALUES ("Ginger","Black");
INSERT INTO Editor (FirstName,LastName) VALUES ("Lara","Jarvis");
INSERT INTO Editor (FirstName,LastName) VALUES ("Howard","Harper");
INSERT INTO Editor (FirstName,LastName) VALUES ("Ella","Waller");
INSERT INTO Editor (FirstName,LastName) VALUES ("Iona","Ellis");
INSERT INTO Editor (FirstName,LastName) VALUES ("Scott","Bradley");
INSERT INTO Editor (FirstName,LastName) VALUES ("Maggy","Riddle");
INSERT INTO Editor (FirstName,LastName) VALUES ("Giacomo","Jimenez");
INSERT INTO Editor (FirstName,LastName) VALUES ("Josiah","Haley");
INSERT INTO Editor (FirstName,LastName) VALUES ("Reece","Christensen");
INSERT INTO Editor (FirstName,LastName) VALUES ("Tyler","Hood");
INSERT INTO Editor (FirstName,LastName) VALUES ("Doris","Bryant");
INSERT INTO Editor (FirstName,LastName) VALUES ("Colleen","Bonner");
INSERT INTO Editor (FirstName,LastName) VALUES ("Hope","Mercer");
INSERT INTO Editor (FirstName,LastName) VALUES ("Maxine","Neal");
INSERT INTO Editor (FirstName,LastName) VALUES ("Mercedes","York");
INSERT INTO Editor (FirstName,LastName) VALUES ("Yen","Munoz");
INSERT INTO Editor (FirstName,LastName) VALUES ("Leandra","Eaton");
INSERT INTO Editor (FirstName,LastName) VALUES ("Inez","Anderson");
INSERT INTO Editor (FirstName,LastName) VALUES ("Nomlanga","Morales");
INSERT INTO Editor (FirstName,LastName) VALUES ("Whoopi","Merritt");
INSERT INTO Editor (FirstName,LastName) VALUES ("Georgia","Talley");
INSERT INTO Editor (FirstName,LastName) VALUES ("Brett","Kinney");
INSERT INTO Editor (FirstName,LastName) VALUES ("Margaret","Jones");
INSERT INTO Editor (FirstName,LastName) VALUES ("Jaime","Brewer");
INSERT INTO Editor (FirstName,LastName) VALUES ("Lillian","Small");
INSERT INTO Editor (FirstName,LastName) VALUES ("Lucius","Giles");
INSERT INTO Editor (FirstName,LastName) VALUES ("Vance","Shepherd");
INSERT INTO Editor (FirstName,LastName) VALUES ("Darius","Buckner");
INSERT INTO Editor (FirstName,LastName) VALUES ("Lance","Terrell");
INSERT INTO Editor (FirstName,LastName) VALUES ("Uriah","Shelton");
INSERT INTO Editor (FirstName,LastName) VALUES ("Denton","Hancock");
INSERT INTO Editor (FirstName,LastName) VALUES ("Kane","Collier");
INSERT INTO Editor (FirstName,LastName) VALUES ("Jackson","French");
INSERT INTO Editor (FirstName,LastName) VALUES ("Ora","Neal");
INSERT INTO Editor (FirstName,LastName) VALUES ("Reese","Mcneil");
INSERT INTO Editor (FirstName,LastName) VALUES ("Katell","Herman");
INSERT INTO Editor (FirstName,LastName) VALUES ("Ginger","Bernard");
INSERT INTO Editor (FirstName,LastName) VALUES ("Cadman","Cantu");
INSERT INTO Editor (FirstName,LastName) VALUES ("Virginia","Griffin");
INSERT INTO Editor (FirstName,LastName) VALUES ("Callum","Franks");
INSERT INTO Editor (FirstName,LastName) VALUES ("Beverly","Mcguire");
INSERT INTO Editor (FirstName,LastName) VALUES ("Nelle","Hodges");
INSERT INTO Editor (FirstName,LastName) VALUES ("Elliott","Ayala");
INSERT INTO Editor (FirstName,LastName) VALUES ("Sylvia","Mcpherson");
INSERT INTO Editor (FirstName,LastName) VALUES ("Mechelle","Bauer");
INSERT INTO Editor (FirstName,LastName) VALUES ("Beverly","Baldwin");
INSERT INTO Editor (FirstName,LastName) VALUES ("Cheyenne","Arnold");
INSERT INTO Editor (FirstName,LastName) VALUES ("Jescie","Cervantes");
INSERT INTO Editor (FirstName,LastName) VALUES ("Porter","Norman");
INSERT INTO Editor (FirstName,LastName) VALUES ("Lysandra","Kelley");
INSERT INTO Editor (FirstName,LastName) VALUES ("Ray","Wiggins");
INSERT INTO Editor (FirstName,LastName) VALUES ("Hamish","Finley");
INSERT INTO Editor (FirstName,LastName) VALUES ("Merrill","Williams");
INSERT INTO Editor (FirstName,LastName) VALUES ("Cassandra","Heath");
INSERT INTO Editor (FirstName,LastName) VALUES ("Michael","Donaldson");
INSERT INTO Editor (FirstName,LastName) VALUES ("Dolan","Cotton");
INSERT INTO Editor (FirstName,LastName) VALUES ("Callum","Brewer");
INSERT INTO Editor (FirstName,LastName) VALUES ("Robert","Kennedy");
INSERT INTO Editor (FirstName,LastName) VALUES ("Tara","Morton");
INSERT INTO Editor (FirstName,LastName) VALUES ("Timon","Hodge");
INSERT INTO Editor (FirstName,LastName) VALUES ("Rhoda","Cortez");
INSERT INTO Editor (FirstName,LastName) VALUES ("Octavius","Gould");
INSERT INTO Editor (FirstName,LastName) VALUES ("Otto","Garner");
INSERT INTO Editor (FirstName,LastName) VALUES ("Ray","Moss");
INSERT INTO Editor (FirstName,LastName) VALUES ("Elizabeth","Merrill");
INSERT INTO Editor (FirstName,LastName) VALUES ("Raya","Garrett");
INSERT INTO Editor (FirstName,LastName) VALUES ("Shelby","Cardenas");
INSERT INTO Editor (FirstName,LastName) VALUES ("Hammett","Estrada");
INSERT INTO Editor (FirstName,LastName) VALUES ("Knox","Conley");
INSERT INTO Editor (FirstName,LastName) VALUES ("Abbot","Robbins");
INSERT INTO Editor (FirstName,LastName) VALUES ("Sean","Case");
INSERT INTO Editor (FirstName,LastName) VALUES ("Nola","Pope");
INSERT INTO Editor (FirstName,LastName) VALUES ("Thaddeus","Robles");
INSERT INTO Editor (FirstName,LastName) VALUES ("Shelby","Rollins");
INSERT INTO Editor (FirstName,LastName) VALUES ("April","Mccarty");
INSERT INTO Editor (FirstName,LastName) VALUES ("Abdul","Roberts");
INSERT INTO Editor (FirstName,LastName) VALUES ("Caesar","Cannon");
INSERT INTO Editor (FirstName,LastName) VALUES ("Chiquita","Gardner");
INSERT INTO Editor (FirstName,LastName) VALUES ("Micah","Wilkins");
INSERT INTO Editor (FirstName,LastName) VALUES ("Raphael","Johnston");
INSERT INTO Editor (FirstName,LastName) VALUES ("Warren","Acosta");
INSERT INTO Editor (FirstName,LastName) VALUES ("Ivory","Pruitt");
INSERT INTO Editor (FirstName,LastName) VALUES ("Silas","Cash");
INSERT INTO Editor (FirstName,LastName) VALUES ("Dacey","Romero");
INSERT INTO Editor (FirstName,LastName) VALUES ("Hoyt","Gregory");
INSERT INTO Editor (FirstName,LastName) VALUES ("Shafira","Mayer");
INSERT INTO Editor (FirstName,LastName) VALUES ("Winter","Frederick");
INSERT INTO Editor (FirstName,LastName) VALUES ("Jonas","Sloan");
INSERT INTO Editor (FirstName,LastName) VALUES ("Leilani","Barton");
INSERT INTO Editor (FirstName,LastName) VALUES ("Cora","Chambers");
INSERT INTO Editor (FirstName,LastName) VALUES ("Callie","Pennington");
INSERT INTO Editor (FirstName,LastName) VALUES ("Aubrey","Boyd");
INSERT INTO Editor (FirstName,LastName) VALUES ("Jonas","Clemons");
INSERT INTO Editor (FirstName,LastName) VALUES ("Mara","Burt");
INSERT INTO Editor (FirstName,LastName) VALUES ("Ruby","Thomas");
INSERT INTO Editor (FirstName,LastName) VALUES ("Irene","Justice");
INSERT INTO Editor (FirstName,LastName) VALUES ("Castor","Pitts");
INSERT INTO Editor (FirstName,LastName) VALUES ("Rudyard","Buchanan");
INSERT INTO Editor (FirstName,LastName) VALUES ("Hamish","Mejia");
/*Primary Authors*/
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Reed","Conrad","est.arcu.ac@telluseuaugue.edu","Ap #887-2111 Dapibus Rd.","Sed Eget LLC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Idola","Moore","placerat@enimsitamet.edu","5473 Tellus Road","Libero Lacus LLC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Eden","Carrillo","egestas@massaInteger.com","777-9473 Nam Rd.","Felis Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Whilemina","Savage","elit.Curabitur.sed@elit.net","2545 Morbi St.","Molestie Dapibus Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Caryn","Mercado","consectetuer@fermentum.co.uk","Ap #863-2010 Vestibulum Street","Adipiscing Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Maisie","Grimes","purus@risusaultricies.net","Ap #586-9404 Pulvinar Rd.","Lorem Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Herrod","Riley","pede@nulla.com","P.O. Box 420, 2001 Lacus. Road","In Dolor Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Abel","Hendrix","ligula.Aenean@magnaDuisdignissim.com","606 Libero Rd.","Metus Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Kaitlin","Becker","suscipit.nonummy.Fusce@tristique.org","Ap #201-5929 Tincidunt Street","Nibh Aliquam LLP");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Jaquelyn","Mcdaniel","dolor.Quisque@diamDuis.ca","1650 Pede Ave","Ut Eros Company");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Vivian","Rasmussen","mauris.Morbi.non@temporerat.ca","447-6138 Phasellus Rd.","Eleifend Institute");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Quemby","Charles","tortor@Morbiquisurna.ca","P.O. Box 188, 7815 Sagittis Av.","Risus Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Yael","Mcdonald","arcu.Sed@nibhAliquam.ca","2477 Nisi Rd.","Habitant Corp.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Charde","Burnett","dis@mauris.org","P.O. Box 663, 1806 Tellus. Av.","Curabitur Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Tamara","House","semper.Nam@cursusluctusipsum.edu","584-9111 Non, Rd.","Lorem Limited");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Phoebe","Dotson","a.malesuada@ut.edu","2995 Aliquet Av.","Vitae Odio Sagittis Institute");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Michelle","Hardin","Mauris@rhoncusProinnisl.org","4239 Egestas Avenue","Libero Et Tristique Corp.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Emmanuel","Thomas","sed.hendrerit@ante.edu","116 Lectus Road","Sem Vitae Aliquam PC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Candice","Rocha","a.enim.Suspendisse@aliquetmagnaa.net","806-6332 Dolor. Av.","Augue Scelerisque Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Gabriel","Roman","et.risus.Quisque@infelisNulla.edu","4439 Ante, Avenue","Orci Donec Nibh Company");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Todd","Wilkinson","convallis.dolor@Donec.com","7124 Diam Rd.","Eu Sem Consulting");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Olympia","Jenkins","Phasellus.libero@enimgravidasit.ca","P.O. Box 377, 9920 Commodo St.","At Libero Morbi LLP");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Seth","Houston","dui.augue.eu@lectusquis.ca","P.O. Box 507, 5205 Nullam Road","Lobortis Augue Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Yen","Neal","gravida.non.sollicitudin@dolorvitae.com","P.O. Box 504, 1005 Libero Street","Elit Elit Institute");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Thor","Morgan","Nunc@dui.com","4929 Sed Street","Tincidunt Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Rhea","Norman","Donec@sodalesMaurisblandit.edu","P.O. Box 529, 401 Lacus. Rd.","Cursus Integer Corp.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Mary","Tucker","Vestibulum@ligula.edu","468 Aenean Av.","Lorem Auctor Quis LLC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Nehru","Stein","arcu.Nunc.mauris@egetmetusIn.edu","P.O. Box 896, 6424 Iaculis St.","Facilisis Magna Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Emerald","Justice","tristique@Suspendissealiquet.co.uk","5038 Augue Road","Blandit Mattis Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Julie","Mcknight","et.lacinia.vitae@gravidamaurisut.co.uk","596-8983 Orci Rd.","Integer Eu PC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Liberty","Robbins","ut.pharetra@consequatlectussit.ca","476-1479 Feugiat St.","Per Conubia Nostra Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Justina","Wiggins","Phasellus.nulla.Integer@consequatpurus.com","129-7503 Senectus St.","Vulputate Eu LLC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Melvin","Britt","tellus.sem.mollis@Fuscemi.edu","P.O. Box 207, 9720 Donec Rd.","Enim Condimentum Eget Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Ima","Stewart","dui.lectus.rutrum@purus.ca","P.O. Box 476, 6069 Convallis Rd.","Donec Feugiat Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Gareth","Boone","a@auguemalesuadamalesuada.edu","2855 Aliquam Avenue","Dui In Sodales LLC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Cara","Hogan","vulputate.posuere@Nuncuterat.org","9261 Nec, Road","Risus Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Chanda","Mueller","arcu@Aeneangravida.ca","4308 Taciti Rd.","Nunc Est Mollis Ltd");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Zelenia","Ortega","Praesent@AeneanmassaInteger.ca","6008 Euismod Rd.","Suspendisse Sagittis Nullam Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Avram","Hicks","ipsum.Donec.sollicitudin@molestiearcuSed.ca","Ap #877-2280 Orci. Street","Sed Id Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Isadora","Hunter","mauris@eget.co.uk","361-1778 Iaculis Av.","Nullam Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Barclay","Lott","enim.nisl@Donecnibh.com","6929 Sociis Ave","Cursus Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Karyn","Johns","Mauris@tristiquealiquetPhasellus.org","Ap #594-3093 Hendrerit Rd.","Nibh Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Isabella","Blackburn","adipiscing.elit@nulla.ca","P.O. Box 247, 8033 Libero. Rd.","Lorem Ipsum Dolor Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Cameran","Dillon","eu.odio.tristique@Vivamuseuismodurna.edu","Ap #740-7201 Urna. Ave","Ultricies Corp.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Katell","French","sem@erosnec.net","444-3020 Mollis. St.","Ante Ipsum Primis Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Kameko","Boyd","arcu.imperdiet@sit.com","Ap #929-3744 Egestas Road","Sem Nulla Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Laith","Pruitt","lectus.quis@augue.ca","Ap #297-9027 Integer Road","Nulla Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Yen","Beasley","ultrices.sit.amet@elit.ca","9800 Risus. Av.","Pede Ultrices Foundation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Kenyon","Robinson","penatibus.et.magnis@elitafeugiat.edu","523-5974 Dictum St.","Sit Amet Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Kelly","Bullock","euismod.ac.fermentum@non.ca","7731 Urna. Road","Sed Auctor Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Tucker","Noble","nulla.Donec@dignissimmagnaa.net","P.O. Box 132, 2717 Eget Av.","Enim Nisl PC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Tana","Santana","consequat.auctor@mifringilla.com","Ap #375-7344 Lorem St.","Magnis Dis Parturient Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Bevis","Greer","In.nec.orci@odio.co.uk","Ap #852-2571 Orci Street","Donec Non Justo Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Kaden","Silva","Sed.pharetra.felis@tellus.com","P.O. Box 216, 8859 Diam Ave","Dignissim Limited");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Desiree","Foley","aptent@nec.edu","758-3816 Non, Rd.","Parturient Montes Foundation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Chanda","Lyons","nulla.Donec.non@rutrumeuultrices.org","Ap #967-7642 Praesent Road","Pellentesque Massa PC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Priscilla","Giles","nulla@Donecelementumlorem.edu","Ap #798-3990 Suspendisse Avenue","Velit Sed Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Grace","Moon","luctus.sit.amet@Quisquevarius.edu","977-7290 Dui St.","Mauris Quis Foundation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Joel","Kramer","aliquam.iaculis@egestas.org","409 Auctor Street","Dignissim Tempor Arcu Ltd");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Bianca","Hensley","nostra.per.inceptos@Sed.net","Ap #559-4280 Augue Road","Dis Corp.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Tatyana","Lawson","eu.tellus@eratneque.co.uk","Ap #350-5321 Lorem, Rd.","Mollis Ltd");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Chaney","Aguilar","amet.lorem.semper@fermentum.org","P.O. Box 791, 4225 Sem Av.","Fermentum Convallis Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Danielle","Carter","at.lacus@luctussit.edu","Ap #728-2771 Lobortis Rd.","Lacus Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Vivien","Howell","vehicula@euismod.edu","695-5661 Nec St.","Aliquam LLP");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Dakota","Macdonald","Proin.mi.Aliquam@nectempus.edu","790 Augue, Av.","Lectus Cum Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Demetrius","Daugherty","nulla.Cras.eu@venenatisamagna.ca","909-8701 Quam Av.","Imperdiet Nec Consulting");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Ronan","Bray","felis.purus@nullaCraseu.co.uk","Ap #717-321 Risus. Ave","Dolor Consulting");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Abraham","Dudley","dui@iaculisneceleifend.ca","4032 Cubilia Rd.","Mattis Foundation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Lars","Duke","sagittis.semper.Nam@Aenean.com","8526 Et Ave","Luctus Et Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Rachel","White","hendrerit@aaliquetvel.co.uk","368-113 Ante Avenue","Vulputate Posuere Vulputate LLC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Cailin","Howe","arcu@Etiamlaoreet.com","927 Eros St.","Vivamus Rhoncus Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Felicia","Spencer","Donec.sollicitudin@justonecante.org","P.O. Box 934, 4695 Mauris, Street","Facilisis Suspendisse Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Veda","Bauer","rhoncus.id@Fuscediamnunc.ca","P.O. Box 261, 5254 In Rd.","Dis Parturient Montes Limited");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Rajah","Matthews","sollicitudin.adipiscing@malesuadavel.com","1379 Blandit Avenue","Non Dui Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Shaine","Jennings","netus.et@tinciduntvehicula.co.uk","844-1246 Luctus. Ave","Id Libero Donec Institute");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Ori","Brady","eu.augue.porttitor@gravidaPraesenteu.org","733-6519 Augue Rd.","In Tempus Eu Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Gage","Acevedo","facilisis@ligula.co.uk","Ap #870-1046 Ullamcorper Ave","Sociis Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Gay","Hughes","molestie.orci.tincidunt@nonmassa.edu","167 Auctor Rd.","Dolor Quam LLC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Jin","Dodson","nascetur@semperpretiumneque.net","P.O. Box 653, 2755 Vestibulum Ave","Quisque Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Connor","Jefferson","ante.dictum@a.com","482-5350 In Road","Tortor Company");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Aaron","Cox","vel.est@Cumsociisnatoque.com","2847 Quis Street","Mattis Ornare Lectus Foundation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Emerson","Aguilar","morbi.tristique@eudoloregestas.ca","Ap #662-4721 Magna Avenue","Interdum Nunc Sollicitudin Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Alika","Bradley","orci.luctus.et@Suspendisse.ca","Ap #840-169 Turpis Avenue","Iaculis Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Nita","Blackburn","quis@acmattisvelit.co.uk","P.O. Box 458, 4047 Ultricies Rd.","Volutpat Nulla Dignissim LLP");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Driscoll","Fowler","luctus@pedeCras.com","P.O. Box 288, 3331 Malesuada St.","Parturient Montes Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Shelly","House","Donec.tempor@nuncest.ca","642-9190 Eu Av.","Orci Luctus Corp.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Amir","Branch","Curabitur@mus.ca","153-4911 Rutrum. Avenue","Hendrerit Consectetuer Foundation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Illiana","Dixon","lectus.rutrum.urna@scelerisque.co.uk","P.O. Box 921, 9642 Nullam Rd.","A Mi Institute");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Giselle","Macdonald","gravida@aliquameros.com","P.O. Box 424, 5929 Nisi Rd.","Elit Nulla Consulting");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Tyler","Vega","magna@Phasellus.org","523-148 In Ave","Enim LLC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Colt","Puckett","diam@acsemut.org","9224 Mi St.","Ullamcorper Viverra Maecenas Inc.");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Palmer","Sanchez","Quisque.varius.Nam@Cras.org","602-5345 Eget Avenue","Nec Orci Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Xerxes","Clayton","mauris.Morbi.non@sapien.net","700-2601 Pharetra. Rd.","Vitae Mauris Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Ralph","Garcia","quam.dignissim.pharetra@leoCrasvehicula.edu","3961 Fringilla Rd.","Suspendisse Aliquet Sem Incorporated");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Anika","Morgan","Suspendisse@sedlibero.ca","P.O. Box 124, 8315 Ipsum St.","Luctus Corporation");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Yen","Nichols","Praesent@volutpatNullafacilisis.org","277-8431 Arcu. St.","Pede Institute");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Ruth","Porter","lacus.pede.sagittis@eueleifend.net","P.O. Box 741, 2315 Dui, Ave","Massa Suspendisse Industries");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Fuller","Acosta","Nulla@ametorciUt.org","359-6811 Nullam Rd.","Nibh Enim Gravida PC");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Germaine","Burton","Lorem.ipsum.dolor@Ut.ca","496-881 Non Ave","Magna Associates");
INSERT INTO PrimaryAuthor (FirstName,LastName,Email,MailingAddress,Affiliation) VALUES ("Violet","Kent","quis.diam.luctus@pedeblanditcongue.edu","257-6745 Ridiculus Av.","Nulla Tincidunt Neque Corp.");

/*Reviewer*/
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Steven","Cobb","neque.Nullam@quis.edu","Cursus Corp.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Xavier","Puckett","parturient.montes@nuncsedpede.net","Sed Hendrerit Industries",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Reagan","Mcknight","accumsan.sed.facilisis@ullamcorpervelitin.ca","Sem Ut LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Amal","Waters","rhoncus.Nullam@Nulla.co.uk","Aliquam Arcu Aliquam Incorporated",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Kevin","Frazier","est.arcu@Pellentesqueultriciesdignissim.edu","Mi Fringilla Mi Ltd",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Omar","Bennett","sem.eget.massa@condimentumDonec.org","Luctus Aliquet Odio Incorporated",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Beverly","Morrow","at@eratvolutpat.edu","Eu Nulla Ltd",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Aladdin","Spears","scelerisque@loremDonec.net","Neque Et Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Echo","Hancock","amet.orci.Ut@dictum.com","Congue Turpis In Corporation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Perry","Rios","Maecenas@tellusid.ca","Elit Elit Fermentum Company",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Leilani","Wood","fringilla.Donec@duiquis.org","Nunc Inc.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Athena","Pollard","Ut@Aliquam.edu","Lobortis Corporation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Ira","Moody","interdum@velvenenatis.com","Imperdiet Nec Leo PC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Ivana","David","lobortis@nequenon.org","Fusce LLP",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Brandon","Owens","turpis.egestas@fermentum.ca","Mauris Elit Dictum Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Harrison","Douglas","ante@augue.net","Diam Pellentesque Habitant Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Nomlanga","Avila","blandit.viverra.Donec@enimsit.edu","Elementum Corporation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Shafira","Hunter","dui.Cras.pellentesque@acrisus.co.uk","A Institute",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Kelsey","Cash","elementum@Namnulla.net","Et PC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Alec","Kerr","ridiculus@temporloremeget.com","Pellentesque Ut Ipsum Company",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Silas","Dickerson","massa@sitametultricies.org","Ligula Nullam Enim Corporation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Louis","Boyd","euismod.urna@Crassed.org","Enim Mi Industries",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Signe","Hunt","aliquam.iaculis@aliquetdiam.com","Feugiat Industries",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Teegan","Rivas","Donec.vitae@et.org","Tellus Imperdiet LLP",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Boris","Wood","egestas@lectusquismassa.ca","Elit LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Ingrid","Mills","lobortis.Class.aptent@tinciduntneque.net","Ornare Fusce Mollis Company",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Belle","Goodwin","est@DonecfringillaDonec.net","Neque In Ornare Limited",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Dominic","Fisher","eget.massa.Suspendisse@accumsannequeet.org","Nec Tempus Scelerisque Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Stella","Delaney","est.Mauris@duinec.org","Non Lorem Vitae LLP",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Mia","Keith","velit.eu.sem@sit.co.uk","Eleifend Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Irma","Hardy","conubia@pedemalesuada.net","Quis Institute",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Tanner","Newman","nunc.sed.libero@odioapurus.net","Nisi Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Martina","Ayers","dictum.sapien.Aenean@turpis.net","Sed Limited",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Vielka","Ware","sit@estNuncullamcorper.com","Risus LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Alvin","Anderson","porttitor.tellus@liberonecligula.net","Facilisis Eget Ipsum Ltd",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Gage","Powell","sed.dictum@Uttincidunt.co.uk","At Velit Pellentesque Corp.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Rose","Hyde","ut@imperdietullamcorper.co.uk","In Magna Phasellus Corporation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Flynn","Craft","egestas.lacinia.Sed@idmollis.co.uk","Sed Pede Cum Inc.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Thomas","Cross","habitant.morbi@acmattis.com","Vestibulum Neque PC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Martina","Mcintosh","Nulla.facilisi@magnis.com","Vivamus Company",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Iola","Spence","id.ante@massalobortisultrices.org","In Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Kerry","Nixon","risus@magnisdis.co.uk","Nullam Ut LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Odysseus","Britt","nibh.Aliquam.ornare@Sed.ca","At Velit Cras Industries",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Hedda","Harrington","malesuada.ut.sem@pellentesquemassa.ca","Nec Urna Consulting",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Alma","Bush","sem.elit@MaurismagnaDuis.co.uk","Risus Quisque Libero Inc.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Rudyard","Mckenzie","accumsan.sed@blandit.com","Risus A Ultricies Company",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Rajah","Adams","rhoncus.id@molestiepharetranibh.edu","Montes Nascetur Ridiculus Limited",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Ross","Rowe","in.consequat@lorem.edu","Scelerisque Dui PC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Cameron","Weber","vel.nisl@sitamet.org","Vulputate Eu Odio LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Vernon","Cannon","ipsum@ipsumdolor.ca","Et Inc.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Venus","Prince","nisl.Nulla.eu@quis.ca","Blandit Viverra Ltd",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Regan","Carney","vitae.aliquet@Sed.org","Sed Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Adrian","Kemp","Donec.vitae@nisi.edu","Enim Inc.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Anjolie","Clayton","pharetra.Quisque.ac@vulputatelacus.edu","Proin Velit LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Urielle","Cameron","dui@eratEtiam.ca","Metus Facilisis Inc.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Rhoda","Sargent","molestie.in@lacusvestibulum.com","Dis Parturient Ltd",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Yeo","Meyers","ipsum.primis@purussapiengravida.co.uk","Lorem Auctor Quis Consulting",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Lara","Serrano","interdum.Sed.auctor@ametultricies.net","Sed Consulting",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Reuben","Malone","Etiam.vestibulum@a.co.uk","Neque Vitae Semper Institute",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Doris","Lott","mus.Donec.dignissim@Donecconsectetuermauris.edu","Ac Corp.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Herrod","Clayton","Cras@sedfacilisisvitae.org","Id Ante Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Phelan","Hammond","non.massa@aduiCras.org","Aenean LLP",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Raymond","Andrews","eu.elit.Nulla@pede.edu","A Aliquet Vel Corp.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Rosalyn","Poole","per.inceptos@vitae.org","Nulla Consulting",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Damian","Harris","tellus@pedenonummy.ca","Nulla Facilisis Suspendisse Corporation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Maris","Allison","turpis@volutpatNulla.ca","Nulla Magna Malesuada PC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Harding","Mason","velit.Cras.lorem@massaIntegervitae.org","Eu Lacus Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Brandon","Mccarthy","molestie.orci@Vivamus.com","Nullam Enim Sed Institute",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Caldwell","Horn","consectetuer.euismod.est@accumsannequeet.co.uk","Maecenas Foundation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Colleen","Klein","parturient.montes@Aenean.org","Gravida Aliquam Tincidunt LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Destiny","Salazar","arcu@magnaUt.ca","Integer Vulputate Risus Incorporated",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Signe","Foreman","sem.Pellentesque@arcuAliquamultrices.co.uk","Libero Limited",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Lana","Head","a.sollicitudin.orci@Nuncsed.net","Rhoncus Proin Nisl Corporation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Cruz","Kelley","magna.Duis.dignissim@sit.net","Lobortis Ultrices Consulting",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Jelani","Estrada","Vestibulum.ut@orcilacusvestibulum.ca","Facilisis Magna Tellus Institute",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Melodie","Dyer","velit.Sed.malesuada@aliquameuaccumsan.org","Magna Consulting",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Josiah","Skinner","elit@laciniaSedcongue.com","In LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Justine","Pate","sed.sapien.Nunc@amalesuadaid.ca","Nam LLP",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Indigo","Turner","justo@seddictumeleifend.org","Tempus Risus Consulting",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Dora","Doyle","eu.ultrices.sit@dui.edu","Faucibus Lectus A Inc.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Leandra","Macias","semper@dolorQuisquetincidunt.net","Nulla Tempor Augue Associates",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Clarke","Adkins","massa@volutpatnunc.ca","Mattis Velit Justo Foundation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Hunter","Jarvis","et@lobortis.com","Nullam LLP",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Anastasia","Waller","sapien.molestie@Fusce.edu","Aliquam Company",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Urielle","Terrell","vel@enim.edu","Risus Duis Corp.",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Rose","Powell","metus.urna@ridiculusmusDonec.net","Gravida Molestie Ltd",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Yardley","Woods","tincidunt.neque@Proinnislsem.net","Sit Institute",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Vivien","Terry","sit.amet.consectetuer@rutrumFusce.net","Nec Ligula Foundation",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Helen","Hess","enim.Curabitur@sitametmassa.co.uk","Lobortis Limited",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Abigail","Ellis","torquent.per@Sed.ca","Nibh LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Jillian","Lindsey","per.conubia.nostra@nunc.co.uk","Tincidunt Pede Ac LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Danielle","Sanford","lacus.Mauris.non@massalobortis.net","In At Pede Incorporated",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Fatima","Heath","malesuada@dictum.org","Orci Tincidunt Company",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Jerome","Hines","Integer.in.magna@liberoest.edu","Dui Institute",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Ebony","Singleton","dolor@SedmolestieSed.co.uk","Donec Est Incorporated",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Jescie","Woodward","Phasellus.vitae.mauris@ornareFuscemollis.org","Sem Incorporated",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Gregory","Manning","amet.diam@molestiepharetra.org","Lorem LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Aurora","Ferrell","in@enimnec.com","Sit Amet Diam LLC",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Jordan","Mcbride","odio.Nam@atortor.net","Ultricies Limited",0);
INSERT INTO Reviewer (FirstName,LastName,Email,Affiliation,Retired) VALUES ("Fleur","Maldonado","orci@cursus.com","Consectetuer Ipsum Nunc Consulting",0);

/*Journal Issue*/
INSERT INTO JournalIssue (Year,Period,PrintDate) VALUES (2016,'1',"2016-01-28 22:43:25");
INSERT INTO JournalIssue (Year,Period,PrintDate) VALUES (2016,'2',NULL);
INSERT INTO JournalIssue (Year,Period,PrintDate) VALUES (2016,'3',NULL);
INSERT INTO JournalIssue (Year,Period,PrintDate) VALUES (2016,'4',NULL);
INSERT INTO JournalIssue (Year,Period,PrintDate) VALUES (2017,'4',NULL);

/*Manuscript*/
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("lectus pede, ultrices","2017-01-20 22:43:25","Published",1,15,26,4,5,2,"",2016,'1', 'abc', "2017-01-24 23:43:25");
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("eu neque pellentesque","2017-01-26 04:23:12","Typeset",2,84,99,NULL,NULL,NULL,"",NULL,NULL, 'Shell', "2017-01-28 04:23:12");
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("Phasellus","2016-09-30 12:39:15","Rejected",3,49,44,NULL,NULL,NULL,"",NULL,NULL, 'Dartmouth', "2016-10-30 12:39:15");
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("Cras","2016-12-31 06:33:53","Under Review",4,31,92,NULL,NULL,NULL,"",NULL,NULL, 'JHU', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("Cum sociis natoque","2017-09-14 14:36:05","Under Review",5,81,35,12,56,4,"",NULL, NULL, 'Denver U', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("eu","2016-11-13 15:03:22","Received",6,19,41,NULL,NULL,NULL,"",NULL,NULL, 'Thayer', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("facilisis","2016-07-31 22:12:15","Received",7,68,100,NULL,NULL,NULL,"",NULL,NULL, 'SASS', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("adipiscing lobortis risus.","2016-11-14 14:30:49","Under Review",7,91,87,NULL,NULL,NULL,"",NULL,NULL, 'XH', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("dolor.","2017-07-24 20:03:02","Received",8,76,94,NULL,NULL,NULL,"",NULL,NULL, 'Harvard', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("augue malesuada","2016-11-02 18:15:49","Received",9,7,24,NULL,NULL,NULL,"",NULL,NULL, 'Princeton', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("libero. Donec consectetuer","2018-01-27 23:21:23","Received",10,2,98,NULL,NULL,NULL,"",NULL,NULL, 'University of Pennsylvania', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("lorem, auctor","2017-10-01 23:25:06","Received",10,51,5,NULL,NULL,NULL,"",NULL,NULL, 'Brown', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("Etiam","2016-11-27 13:35:56","Received",10,55,20,NULL,NULL,NULL,"",NULL,NULL,'Cornell', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("vulputate,","2016-08-30 02:48:36","Received",10,39,19,NULL,NULL,NULL,"",NULL,NULL,'Yale', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("euismod mauris","2018-04-09 06:25:01","Received",10,29,10,NULL,NULL,NULL,"",NULL,NULL,'Stanford', NULL);
INSERT INTO Manuscript (Title,DateReceived,`Status`,RICode,PrimaryAuthorId,EditorId,PagesOccupied,StartingPage,`Order`,Document,JournalIssueYear,JournalIssuePeriod, PrimaryAuthorAffiliation, DateAcceptReject) VALUES ("consectetuer ipsum","2017-08-07 10:09:32","Received",10,55,81,NULL,NULL,NULL,"",NULL,NULL,'UW', NULL);



/*Secondary Author*/
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,13,"Drew","Fowler");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,11,"Morgan","Kirkland");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (2,11,"Fiona","Schmidt");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,5,"Akeem","Albert");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (3,11,"Magee","Mccormick");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,12,"Driscoll","Foley");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,3,"Wayne","Patterson");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,15,"Zia","Giles");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,9,"Kessie","Delaney");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,6,"Judith","Potter");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,2,"Logan","Sparks");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (2,3,"Nevada","Pittman");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,1,"Adele","Simmons");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (2,13,"Jocelyn","Mercado");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (2,9,"Jane","Hall");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (2,2,"Veronica","Merrill");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (1,7,"Gray","Kramer");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (3,2,"Scott","Estrada");
INSERT INTO SecondaryAuthor (BylinePosition,ManuscriptId,FirstName,LastName) VALUES (2,12,"Grady","Howe");

/*Reviewer Interests*/
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (1,1);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,1);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,1);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,2);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,2);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,2);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,3);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,3);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (11,3);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,4);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,5);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,6);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,7);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (8,7);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (4,8);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,9);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,10);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,11);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,12);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,13);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,14);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,15);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,16);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,17);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,18);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,19);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,20);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,21);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,22);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,23);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (4,24);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,25);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,26);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,27);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,28);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,29);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,30);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,31);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,32);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,33);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,34);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,35);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (1,36);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,37);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,38);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,39);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,40);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (8,41);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,42);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (4,43);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,44);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,45);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,46);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (8,47);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (4,48);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (8,49);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,50);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,51);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (1,52);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,53);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (8,54);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,55);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (1,56);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,57);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,58);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,59);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,60);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (8,61);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,62);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,63);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (1,64);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,65);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,66);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,67);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,68);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,69);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,70);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,71);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (8,72);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,73);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,74);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (1,75);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (6,76);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (8,77);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (1,78);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (4,79);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,80);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,81);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,82);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,83);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,84);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (1,85);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,86);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,87);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,88);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,89);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,90);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,91);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (2,92);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (10,93);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (4,94);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,95);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,96);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (3,97);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (9,98);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (5,99);
INSERT INTO ReviewerInterests (RICode,ReviewerId) VALUES (7,100);




/*Review*/
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (1,1,'9','8','9','8',"Accept","2017-01-20 23:43:25","2017-01-21 23:43:25");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (1,52,'7','9','9','8',"Accept","2017-01-20 23:43:25","2017-01-22 10:23:15");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (1,64,'9','7','7','9',"Accept","2017-01-20 23:43:25","2017-01-21 10:20:10");

INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (2,1,'4','5','5','3',"Reject","2017-01-26 05:23:12","2017-01-28 05:23:12");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (2,7,'6','7','7','8',"Accept","2017-01-26 05:23:12","2017-01-27 09:23:12");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (2,17,'4','9','8','9',"Accept","2017-01-26 05:23:12","2017-01-27 22:23:12");

INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (3,1,'2','3','2','2',"Reject","2016-09-30 13:39:15","2016-10-01 12:39:15");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (3,4,'2','4','2','2',"Reject","2016-09-30 13:39:15","2016-10-01 15:39:15");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (3,22,'4','3','4','3',"Reject","2016-09-30 13:39:15","2016-09-30 18:39:15");

INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (4,8,'9','8','9','8',"Accept","2016-12-31 06:33:53","2017-01-01 06:33:53");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (4,24,'9','8','9','8',"Accept","2016-12-31 06:33:53","2017-01-01 08:33:53");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (4,43,'9','8','9','8',"Accept","2016-12-31 06:33:53","2017-01-02 06:33:53");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (4,94,'9','8','9','8',"Accept","2016-12-31 06:33:53","2017-01-02 06:33:53");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (4,79,NULL,NULL,NULL,NULL,NULL,"2016-12-31 06:33:53",NULL);


INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (5,2,'9','8','9','8',"Accept","2017-09-14 14:36:05","2017-09-15 14:36:05");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (5,12,'9','8','9','8',"Accept","2017-09-14 14:36:05","2017-09-16 14:36:05");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (5,16,'9','8','9','8',"Accept","2017-09-14 14:36:05","2017-09-18 14:36:05");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (5,37,NULL,NULL,NULL,NULL,NULL,"2017-09-14 14:36:05",NULL);

INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (8,2,'8','8','7','9',"Accept","2016-11-14 15:30:49","2016-11-12 15:30:49");
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (8,5,NULL,NULL,NULL,NULL,NULL,"2016-11-14 15:30:49",NULL);
INSERT INTO Review (ManuscriptId,ReviewerId,Appropriateness,Clarity,Methodology,ContributionField,Recommendation,DateSent,DateCompleted) VALUES (8,10,NULL,NULL,NULL,NULL,NULL,"2016-11-14 15:30:49",NULL);


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
