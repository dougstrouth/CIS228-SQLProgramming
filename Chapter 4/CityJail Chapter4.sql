DROP TABLE Appeals;
DROP TABLE Crime_officers;
DROP TABLE Crime_charges;

SELECT constraint_name, constraint_type, search_condition, r_constraint_name
FROM user_constraints
WHERE table_name = 'Crime_codes';



ALTER TABLE Crime_codes
	ADD CONSTRAINT Crime_codes_Crime_code_pk PRIMARY KEY(Crime_code);
	
ALTER TABLE Crime_codes	
	MODIFY (Code_description CONSTRAINT Crime_codes_Code_descrip_nn NOT NULL);
	
ALTER TABLE Crime_codes
	ADD CONSTRAINT Crime_codes_Code_descrip_uk UNIQUE(Code_description);

ALTER TABLE Criminals
	ADD CONSTRAINT Criminals_Criminal_ID_pk PRIMARY KEY(Criminal_ID);

ALTER TABLE Officers
	ADD CONSTRAINT Officers_Officer_ID_pk PRIMARY KEY(Officer_ID);
ALTER TABLE Officers	
	ADD CONSTRAINT Officers_Badge_uk UNIQUE(Badge);
ALTER TABLE Officers
	MODIFY( Precinct CONSTRAINT Officers_Precinct_nn NOT NULL);

ALTER TABLE Prob_officers
	ADD CONSTRAINT Prob_officers_Prob_ID_pk PRIMARY KEY(Prob_ID);
ALTER TABLE Prob_officers
	MODIFY (STATUS CONSTRAINT Prob_officers_Status_nn NOT NULL);

ALTER TABLE Crimes
	ADD CONSTRAINT Crimes_Crime_ID_pk PRIMARY KEY(Crime_ID);
ALTER TABLE Crimes
	ADD CONSTRAINT Crimes_Hearing_date_ck CHECK(Hearing_date>Date_charged);
ALTER TABLE Crimes
	MODIFY (Status CONSTRAINT Crimes_Status_nn NOT NULL);
ALTER TABLE Crimes	
	ADD CONSTRAINT Crimes_Criminal_ID_fk FOREIGN KEY(Criminal_ID)
		REFERENCES Criminals(Criminal_ID);

ALTER TABLE Aliases
	ADD CONSTRAINT Aliases_Alias_ID_pk PRIMARY KEY(Alias_ID);
ALTER TABLE Aliases	
	ADD CONSTRAINT Aliases_Criminal_ID_fk FOREIGN KEY(Criminal_ID)
		REFERENCES Criminals(Criminal_ID);

ALTER TABLE Sentences
	ADD CONSTRAINT Sentences_Sentence_ID_pk PRIMARY KEY(Sentence_ID);
ALTER TABLE Sentences	
	ADD CONSTRAINT Sentences_End_date_ck CHECK(End_date>Start_date);
ALTER TABLE Sentences	
	MODIFY (Violations CONSTRAINT Sentences_Violations_nn NOT NULL);
ALTER TABLE Sentences	
	ADD CONSTRAINT Sentences_Criminal_ID_fk FOREIGN KEY(Criminal_ID)
		REFERENCES Criminals(Criminal_ID);
ALTER TABLE Sentences	
	ADD CONSTRAINT Sentences_Prob_ID_fk FOREIGN KEY(Prob_ID)
		REFERENCES Prob_officers(Prob_ID);

CREATE TABLE Appeals
(Appeal_ID NUMBER(5),
	Crime_ID Number(9,0),
	Filing_date DATE,
	Hearing_date DATE,
	Status CHAR(1) DEFAULT 'P',
		CONSTRAINT Appeals_Appeal_ID_pk PRIMARY KEY(Appeal_ID),
		CONSTRAINT Appeals_Crime_ID_fk FOREIGN KEY(Crime_ID)
			REFERENCES Crimes(Crime_ID));

CREATE TABLE Crime_officers
(Crime_ID NUMBER(9,0),
	Officer_ID NUMBER(8,0),
		CONSTRAINT Crime_o_CrimeOfficerID_pk PRIMARY KEY(Crime_ID, Officer_ID));

CREATE TABLE Crime_charges
(Charge_ID NUMBER(10,0),
	Crime_ID NUMBER(9,0),
	Crime_code NUMBER(3,0),
	Charge_status CHAR(2),
	Fine_amount NUMBER(7,2),
	Court_fee NUMBER(7,2),
	Amount_paID NUMBER(7,2),
	Pay_due_date DATE,
		CONSTRAINT Crime_charges_Charge_ID_pk PRIMARY KEY(Charge_ID),
		CONSTRAINT Crime_charges_Crime_ID_fk FOREIGN KEY(Crime_ID)
			REFERENCES Crimes(Crime_ID),
		CONSTRAINT Crime_charges_Crime_code_fk FOREIGN KEY (Crime_code)
			REFERENCES Crime_codes(Crime_code));


