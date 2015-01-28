CREATE SEQUENCE criminal_id_seq
	INCREMENT BY 1
	START WITH 1017
	NOCACHE
	NOCYCLE;

CREATE SEQUENCE crime_id_seq
	INCREMENT BY 1
	START WITH 1
	NOCACHE
	NOCYCLE;

INSERT INTO Criminals (criminal_id, first, last, city, state, zip)
	VALUES (criminal_id_seq.NEXTVAl, 'Johnny', 'Capps', 'Worcester', 'MA', 01603);

INSERT INTO Crimes (crime_id, criminal_id)
	VALUES(crime_id_seq.NEXTVAl,criminal_id_seq.CURRVAl);

CREATE INDEX criminal_name_idx
	ON Criminals (last);


CREATE INDEX criminal_street_idx
	ON Criminals (street);


CREATE INDEX criminal_phone_idx
	ON Criminals (phone);

