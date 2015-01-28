INSERT INTO Criminals (Criminal_ID, Last, First, Street, City, State, Zip, Phone, V_Status, P_status)
	VALUES (:Criminal_ID, :Last, :First, :Street, :City, :State, :Zip, :Phone, :V_Status,:P_status);


INSERT INTO Criminals (Criminal_ID, Last, First, City, State, Zip)
	VALUES (1015,'Fenter', 'Jim', 'Chesapeake', 'VA', 23320);

INSERT INTO Criminals  (Criminal_ID, Last, First, Street, City, State, Zip, Phone)
	VALUES (1016,'Saunder', 'Bill', '11 Apple Rd', 'Virginia Beach', 'VA',23455,7678217443);

INSERT INTO Criminals  (Criminal_ID, Last, First, Street, City, State, Zip, Phone)
	VALUES (1017,'Painter', 'Troy', '77 Ship Lane', 'Norfolk', 'VA', 22093,7677655454);
/* Part1 */

ALTER TABLE Criminals
	ADD (Mail_flag CHAR(1));

UPDATE Criminals
	SET Mail_flag='Y';

UPDATE Criminals
	SET Mail_flag='N'
	WHERE Street IS NULL;

UPDATE Criminals
	SET Phone='7225659032'
	WHERE Criminal_ID=1016;

DELETE FROM Criminals
	WHERE Criminal_ID=1017;
commit;
/* 
	Part2 
	Crimes Table information
	(Crime_ID NUMBER(9,0),
	Criminal_ID NUMBER(6,0),
	Classification CHAR(1),
	Date_charged DATE,
	Status CHAR(2),
	Hearing_date DATE,
	Appeal_cut_date DATE);

*/

INSERT INTO Crimes (Crime_ID, Criminal_ID, Classification, Date_charged, Status)
	VALUES(100,1010,'M','15-JUL-09', 'PD');

INSERT INTO Crimes (Crime_ID, Criminal_ID, Classification, Date_charged, Status)
	VALUES(130,1016,'M', '15-JUL-09','PD');


INSERT INTO Crimes (Crime_ID, Criminal_ID, Classification, Date_charged, Status)
	VALUES(130,1016,'P', '15-JUL-09','CL');