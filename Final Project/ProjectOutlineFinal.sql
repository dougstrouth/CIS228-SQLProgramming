/* RESET TABLE STRUCTURE */
DROP TABLE PATIENT CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE COUNTRY CASCADE CONSTRAINTS;
DROP TABLE DISEASE_TYPE CASCADE CONSTRAINTS;
DROP TABLE AFTEREFFECT CASCADE CONSTRAINTS;
DROP TABLE CAT_EVENT CASCADE CONSTRAINTS;
DROP TABLE SYMPTOM_LIST CASCADE CONSTRAINTS;
DROP TABLE LOCATION CASCADE CONSTRAINTS;
DROP TABLE DISEASE CASCADE CONSTRAINTS;
DROP TABLE HEALTH_PROFESSION CASCADE CONSTRAINTS;
DROP TABLE EXPECTED_SYMPTOM CASCADE CONSTRAINTS;
DROP TABLE CASE CASCADE CONSTRAINTS;
DROP TABLE OUTCOME CASCADE CONSTRAINTS;
DROP TABLE ENCOUNTER CASCADE CONSTRAINTS;
DROP TABLE TRAVEL_DESTINATION CASCADE CONSTRAINTS;
DROP TABLE ENCOUNTER_AFTEREFFECT CASCADE CONSTRAINTS;
DROP TABLE EXHIBITED_SYMPTOM CASCADE CONSTRAINTS;

/*RESET SEQUENCES*/

DROP SEQUENCE PATIENT_ID_SEQ;
DROP SEQUENCE REGION_ID_SEQ;
DROP SEQUENCE COUNTRY_ID_SEQ;
DROP SEQUENCE DISEASE_TYPE_ID_SEQ;
DROP SEQUENCE AFTEREFFECT_ID_SEQ;
DROP SEQUENCE CAT_EVENT_ID_SEQ;
DROP SEQUENCE SYMPTOM_LIST_ID_SEQ;
DROP SEQUENCE LOCATION_ID_SEQ;
DROP SEQUENCE DISEASE_ID_SEQ;
DROP SEQUENCE HEALTH_PROFESSION_ID_SEQ;
DROP SEQUENCE CASE_ID_SEQ;
DROP SEQUENCE OUTCOME_ID_SEQ;
DROP SEQUENCE ENCOUNTER_ID_SEQ;
DROP SEQUENCE TRAVEL_DESTINATION_ID_SEQ;


/* 1 Table creations */

/* GROUP 1 */
/* 2E NOT NULL CONSTRAINT */
 /*2A PRIMARY KEY */
 /*2D CHECK CONSTRAINT */
CREATE TABLE PATIENT
  (PATIENT_ID NUMBER(5),
   DOB DATE NOT NULL, 
   GENDER CHAR(1) NOT NULL,
   BLOOD_TYPE VARCHAR2(5) NOT NULL,
   ETHNICITY VARCHAR2(20) NOT NULL,
   CONSTRAINT PATIENT_ID_PK PRIMARY KEY (PATIENT_ID),
   CONSTRAINT PATIENT_GENDER_CK CHECK (GENDER IN('M','F'))); 


/* 2C UNIQUE CONSTRAINT */
CREATE TABLE REGION
(REGION_ID NUMBER(5),
  NAME VARCHAR2(20) NOT NULL,
  GEOGRAPHY VARCHAR2(20) NOT NULL,
  CONTINENT VARCHAR2(20) NOT NULL,
  CLIMATE VARCHAR2(20) NOT NULL,
  CONSTRAINT REGION_ID_PK PRIMARY KEY(REGION_ID),
  CONSTRAINT REGION_NAME_UK UNIQUE(NAME) 
);

CREATE TABLE COUNTRY
(COUNTRY_ID NUMBER(5),
  NAME VARCHAR2(20) NOT NULL,
  HEALTH_CENTER VARCHAR2(20) NOT NULL,
  CONTACT_NAME VARCHAR2(20),
  CONTACT_PHONE VARCHAR2(20),
  CONSTRAINT COUNTRY_ID_PK PRIMARY KEY(COUNTRY_ID)
);

CREATE TABLE DISEASE_TYPE
(DISEASE_TYPE_ID NUMBER(5),
  NAME VARCHAR2(20) NOT NULL,
  DESCRIPTION VARCHAR2(50) NOT NULL,
  CONSTRAINT DISEASE_TYPE_ID_PK PRIMARY KEY(DISEASE_TYPE_ID)
);

CREATE TABLE AFTEREFFECT
(AFTEREFFECT_ID NUMBER(5),
  NAME VARCHAR2(20) NOT NULL,
  DESCRIPTION VARCHAR2(50) NOT NULL,
  CONSTRAINT AFTEREFFECT_ID_PK PRIMARY KEY(AFTEREFFECT_ID)
);

CREATE TABLE CAT_EVENT
(CAT_EVENT_ID NUMBER(5),
  DATE_OF_EVENT DATE,
  DESCRIPTION VARCHAR2(50),
  CONSTRAINT CAT_EVENT_ID_PK PRIMARY KEY(CAT_EVENT_ID)
);

CREATE TABLE SYMPTOM_LIST
(SYMPTOM_ID NUMBER(5),
  NAME VARCHAR2(20) NOT NULL,
  DESCRIPTION VARCHAR2(50) NOT NULL,
  CONSTRAINT SYMPTOM_LIST_ID_PK PRIMARY KEY (SYMPTOM_ID)
);

/* GROUP 2 */
/* 2B FOREIGN KEY */

CREATE TABLE LOCATION
( LOCATION_ID NUMBER(5),
  REGION_ID NUMBER(5),
  CITY VARCHAR2(20) NOT NULL,
  STATE CHAR(2) NOT NULL,
  LATITUDE VARCHAR2(20),
  LONGITUDE VARCHAR2(20),
  CONSTRAINT LOCATION_ID_PK PRIMARY KEY (LOCATION_ID),
  CONSTRAINT LOCATION_REGION_ID_FK FOREIGN KEY (REGION_ID) 
    REFERENCES REGION(REGION_ID) 
);

CREATE TABLE DISEASE
(DISEASE_ID NUMBER(5),
  DISEASE_TYPE_ID NUMBER(5),
  NAME VARCHAR2(20) NOT NULL,
  TRANSMISSION_FORM VARCHAR2(50),
  CONSTRAINT DISEASE_ID_PK PRIMARY KEY (DISEASE_ID),
  CONSTRAINT DISEASE_TYPE_ID_FK FOREIGN KEY(DISEASE_TYPE_ID)
    REFERENCES DISEASE_TYPE(DISEASE_TYPE_ID)
);



/*GROUP 3 */
CREATE TABLE HEALTH_PROFESSION
(HEALTH_PROFESSION_ID NUMBER(5),
  LOCATION_ID NUMBER(5),
  LAST VARCHAR2(20) NOT NULL,
  FIRST VARCHAR2(20) NOT NULL,
  PHONE VARCHAR2(20) NOT NULL,
  EMAIL VARCHAR2(20),
  USER_ID VARCHAR2(20) NOT NULL,
  PASSWORD VARCHAR2(20) NOT NULL,
  CONSTRAINT HEALTH_PROFESSION_ID_PK PRIMARY KEY (HEALTH_PROFESSION_ID),
  CONSTRAINT HEALTH_PROFESSION_LOC_ID_FK FOREIGN KEY (LOCATION_ID)
    REFERENCES LOCATION(LOCATION_ID),
  CONSTRAINT HEALTH_PROFESSION_USER_ID_UK UNIQUE(USER_ID)
);

CREATE TABLE EXPECTED_SYMPTOM
(
  SYMPTOM_ID NUMBER(5),
  DISEASE_ID NUMBER(5),
  CONSTRAINT EXPECTED_SYMPTOM_PK PRIMARY KEY (SYMPTOM_ID, DISEASE_ID),
  CONSTRAINT EXPECTED_SYMPTOM_SYMPTOM_ID_FK FOREIGN KEY (SYMPTOM_ID)
    REFERENCES SYMPTOM_LIST (SYMPTOM_ID),
  CONSTRAINT EXPECTED_SYMPTOM_DISEASE_ID_FK FOREIGN KEY (DISEASE_ID)
    REFERENCES DISEASE (DISEASE_ID)
);

/*GROUP 4 */

/* 4 HANDLING VIRTUAL COLUMNS */
CREATE TABLE CASE
(CASE_ID NUMBER(5),
  PATIENT_ID NUMBER(5),
  HEALTH_PROFESSION_ID NUMBER(5),
  DISEASE_ID NUMBER(5),
  CAT_EVENT_ID NUMBER(5),
  DATE_CONTRACTED DATE NOT NULL,
  REPORTED_BY VARCHAR2(20) NOT NULL,
  DATE_REPORTED DATE NOT NULL,
  BETWEEN_CONTRACTION_AND_REPORT AS (DATE_REPORTED - DATE_CONTRACTED), 
  DATE_CLOSED DATE,
  OUTCOME_ID NUMBER(5),
  CONSTRAINT CASE_ID_PK PRIMARY KEY (CASE_ID),
  CONSTRAINT CASE_PATIENT_ID_FK FOREIGN KEY (PATIENT_ID)
    REFERENCES PATIENT(PATIENT_ID),
  CONSTRAINT CASE_HEALTH_PROFESSION_ID_FK FOREIGN KEY (HEALTH_PROFESSION_ID)
    REFERENCES HEALTH_PROFESSION(HEALTH_PROFESSION_ID),
  CONSTRAINT CASE_DISEASE_ID_FK FOREIGN KEY (DISEASE_ID)
    REFERENCES DISEASE(DISEASE_ID),
  CONSTRAINT CASE_CAT_EVEN_ID_FK FOREIGN KEY (CAT_EVENT_ID)
    REFERENCES CAT_EVENT(CAT_EVENT_ID)
);

CREATE TABLE OUTCOME
(OUTCOME_ID NUMBER(5),
  CASE_ID NUMBER(5) NOT NULL,
  DATE_OF_OUTCOME DATE NOT NULL,
  DESCRIPTION VARCHAR2(50),
  CONSTRAINT OUTCOME_ID_PK PRIMARY KEY (OUTCOME_ID),
  CONSTRAINT OUTCOME_CASE_ID_FK FOREIGN KEY (CASE_ID)
    REFERENCES CASE (CASE_ID)
);
/*SPECIAL ENTRY TO ADD OUTCOME_ID AS A FOREIGN KEY TO CASE SINCE THEY WERE MADE SIMULTANEOUSLY */ 
ALTER TABLE CASE
ADD CONSTRAINT CASE_OUTCOME_ID_FK FOREIGN KEY (OUTCOME_ID)
  REFERENCES OUTCOME (OUTCOME_ID);

/* GROUP 5 */
CREATE TABLE ENCOUNTER
(ENCOUNTER_ID NUMBER(5),
  CASE_ID NUMBER(5) NOT NULL,
  HEIGHT VARCHAR2(20),
  WEIGHT VARCHAR2(20),
  BLOOD_PRESSURE VARCHAR2(20),
  DATE_OF_ENCOUNTER DATE NOT NULL,
  CONSTRAINT ENCOUNTER_ID_PK PRIMARY KEY (ENCOUNTER_ID),
  CONSTRAINT ENCOUNTER_CASE_ID_FK FOREIGN KEY (CASE_ID)
    REFERENCES CASE(CASE_ID)
);

CREATE TABLE TRAVEL_DESTINATION
(TRAVEL_DESTINATION_ID NUMBER(5),
  LOCATION_ID NUMBER(5) NOT NULL,
  START_DATE DATE NOT NULL,
  END_DATE DATE,
  POI CHAR(1),
  CONSTRAINT TRAVEL_DESTINATION_ID_PK PRIMARY KEY (TRAVEL_DESTINATION_ID),
  CONSTRAINT TRAVEL_DESTINATION_LOC_ID_FK FOREIGN KEY (LOCATION_ID)
    REFERENCES LOCATION(LOCATION_ID),
  CONSTRAINT TRAVEL_DESTINATION_POI_CK CHECK (POI IN ('Y','N'))
);

/*GROUP 6 */
CREATE TABLE ENCOUNTER_AFTEREFFECT
(
  AFTEREFFECT_ID NUMBER(5) ,
  ENCOUNTER_ID NUMBER(5) ,
  CONSTRAINT ENCOUNTER_AFTEREFFECT_ID_PK PRIMARY KEY (AFTEREFFECT_ID, ENCOUNTER_ID),
  CONSTRAINT ENCOUNTER_AFTEREFFECT_AE_ID_FK FOREIGN KEY (AFTEREFFECT_ID)
    REFERENCES AFTEREFFECT(AFTEREFFECT_ID),
  CONSTRAINT ENCOUNTER_AFTEREFFECT_E_ID_FK FOREIGN KEY (ENCOUNTER_ID)
    REFERENCES ENCOUNTER(ENCOUNTER_ID)
);

CREATE TABLE EXHIBITED_SYMPTOM
(
  ENCOUNTER_ID NUMBER(5) ,
  SYMPTOM_ID NUMBER(5),
  CONSTRAINT EXHIBITED_SYMPTOM_PK PRIMARY KEY (ENCOUNTER_ID, SYMPTOM_ID),
  CONSTRAINT EXHIBITED_SYMPTOM_E_ID_FK FOREIGN KEY (ENCOUNTER_ID)
    REFERENCES ENCOUNTER(ENCOUNTER_ID),
  CONSTRAINT EXHIBITED_SYMPTOM_S_ID_FK FOREIGN KEY (SYMPTOM_ID)
    REFERENCES SYMPTOM_LIST(SYMPTOM_ID)
);

/*PRIMARY KEY SEQUENCE CREATION*/

/* 7A SEQUENCE CREATION */
CREATE SEQUENCE PATIENT_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  CACHE 5
  NOCYCLE; 

/* 7B ALTERING SEQUENCE */
ALTER SEQUENCE PATIENT_ID_SEQ
  NOCACHE;

/*ALL OTHER SEQUENCE CREATIONS */

CREATE SEQUENCE REGION_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE COUNTRY_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE DISEASE_TYPE_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE AFTEREFFECT_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE CAT_EVENT_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE SYMPTOM_LIST_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

CREATE SEQUENCE LOCATION_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE DISEASE_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  
  CREATE SEQUENCE HEALTH_PROFESSION_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;


  CREATE SEQUENCE CASE_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE OUTCOME_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE ENCOUNTER_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;

  CREATE SEQUENCE TRAVEL_DESTINATION_ID_SEQ
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOCYCLE;



/* 3 INSERT STATEMENTS */

INSERT INTO PATIENT
  VALUES (PATIENT_ID_SEQ.NEXTVAL, '28-MAR-63', 'M','O','RUSSIAN');
INSERT INTO PATIENT
  VALUES (PATIENT_ID_SEQ.NEXTVAL, '08-AUG-60', 'F','B','GERMAN');
INSERT INTO PATIENT
  VALUES (PATIENT_ID_SEQ.NEXTVAL, '03-MAR-03', 'M','A','ASIAN');

INSERT INTO REGION
  VALUES(REGION_ID_SEQ.NEXTVAL,'WEST COAST','WEST','NORTH AMERICA','VARIED');
INSERT INTO REGION
  VALUES(REGION_ID_SEQ.NEXTVAL,'DESERT STATES','MIDWEST','NORTH AMERICA','VERY WARM');

INSERT INTO COUNTRY
  VALUES(COUNTRY_ID_SEQ.NEXTVAL, 'AMERICA', 'GREEN MANORS ','ANTHONY EDWARDS', '(123)-123-1234');
INSERT INTO COUNTRY (COUNTRY_ID,NAME, HEALTH_CENTER,CONTACT_NAME)
  VALUES(COUNTRY_ID_SEQ.NEXTVAL,'AMERICA', 'BATES HOSPITAL','CONSTANCE PETERSEN');

INSERT INTO DISEASE_TYPE
  VALUES(DISEASE_TYPE_ID_SEQ.NEXTVAL, 'VIRUS','QUICK INFECTION');
INSERT INTO DISEASE_TYPE
  VALUES(DISEASE_TYPE_ID_SEQ.NEXTVAL, 'BRAIN INFECTION', 'INCREASED AGGRESIVENESS');

INSERT INTO AFTEREFFECT
  VALUES(AFTEREFFECT_ID_SEQ.NEXTVAL, 'SORES', 'BIG RED, ALL OVER');
INSERT INTO AFTEREFFECT
  VALUES(AFTEREFFECT_ID_SEQ.NEXTVAL,'HEADACHE','ONLY ON RT. SIDE');

INSERT INTO CAT_EVENT
  VALUES(CAT_EVENT_ID_SEQ.NEXTVAL,'09-MAY-58', 'MASSIVE OUTBREAK');
INSERT INTO CAT_EVENT
  VALUES(CAT_EVENT_ID_SEQ.NEXTVAL, '28-JUL-59','ACCIDENTAL DEATH');

INSERT INTO SYMPTOM_LIST
  VALUES(SYMPTOM_LIST_ID_SEQ.NEXTVAL, 'STAB WOUNDS', 'POINTED AND ALL OVER');
INSERT INTO SYMPTOM_LIST
  VALUES(SYMPTOM_LIST_ID_SEQ.NEXTVAL,'INSANITY','CUCKOO CRAZY');

INSERT INTO LOCATION
  VALUES(LOCATION_ID_SEQ.NEXTVAL, 1, 'BODEGA BAY', 'CA', '38.333250','-123.048057');
INSERT INTO LOCATION
  VALUES(LOCATION_ID_SEQ.NEXTVAL, 2, 'FAIRVALE','AZ','34.048928','-111.093731');

INSERT INTO DISEASE
  VALUES(DISEASE_ID_SEQ.NEXTVAL,1,'BIRD FLU','BIRD ATTACKS');
INSERT INTO DISEASE
  VALUES(DISEASE_ID_SEQ.NEXTVAL,2,'HULKISM','BIRD ATTACKS');

INSERT INTO HEALTH_PROFESSION
  VALUES(HEALTH_PROFESSION_ID_SEQ.NEXTVAL,1,'BRENNER','MITCH', '(603) 650-5000','MBRENNER@PSYCH.ORG','MBRENNER','BIRDCRAZY');
INSERT INTO HEALTH_PROFESSION
  VALUES(HEALTH_PROFESSION_ID_SEQ.NEXTVAL,2,'DANIELS','MELANIE', '(610)-459-0647', 'MDANIELS@PSYCH.ORG','MDANIELS','HOSPITABLEHOSPITAL');

INSERT INTO EXPECTED_SYMPTOM
  VALUES(1,1);
INSERT INTO EXPECTED_SYMPTOM
  VALUES(2,2);

INSERT INTO CASE(CASE_ID,PATIENT_ID,HEALTH_PROFESSION_ID,DISEASE_ID,CAT_EVENT_ID,DATE_CONTRACTED,REPORTED_BY,DATE_REPORTED,DATE_CLOSED)
  VALUES(CASE_ID_SEQ.NEXTVAL,1,1,1,1,'29-MAY-54','HARRY WARNER','29-MAR-63','16-NOV-12');
INSERT INTO CASE(CASE_ID,PATIENT_ID,HEALTH_PROFESSION_ID,DISEASE_ID,CAT_EVENT_ID,DATE_CONTRACTED,REPORTED_BY,DATE_REPORTED)
  VALUES(CASE_ID_SEQ.NEXTVAL,2,2,2,2,'28-DEC-45','DAVID SELZNICK','08-MAR-48');

INSERT INTO OUTCOME
  VALUES(OUTCOME_ID_SEQ.NEXTVAL,1,'09-SEP-61', 'DESTRUCTION OF TOWN');

/*BECAUSE OF FOREIGN KEY RESTRICTIONS THIS STATEMENT HAD TO BE ADDED AFTER THE INSERT STATEMENT*/
UPDATE CASE
  SET OUTCOME_ID=1
  WHERE CASE_ID=1; 

INSERT INTO ENCOUNTER
  VALUES(ENCOUNTER_ID_SEQ.NEXTVAL,1,'6 FT', '180 LBS','100 BPM','22-JUL-64');
INSERT INTO ENCOUNTER
  VALUES(ENCOUNTER_ID_SEQ.NEXTVAL,2,'5FT 4IN','115 LBS','85 BPM', '14-JUL-66');

INSERT INTO TRAVEL_DESTINATION
  VALUES(TRAVEL_DESTINATION_ID_SEQ.NEXTVAL,1,'1-JUN-56','22-DEC-56','Y');
INSERT INTO TRAVEL_DESTINATION
  VALUES(TRAVEL_DESTINATION_ID_SEQ.NEXTVAL,2,'19-DEC-69','21-JUN-72','N');

INSERT INTO ENCOUNTER_AFTEREFFECT
  VALUES(1,1);
INSERT INTO ENCOUNTER_AFTEREFFECT
  VALUES(2,2);

INSERT INTO EXHIBITED_SYMPTOM
  VALUES(1,1);
INSERT INTO EXHIBITED_SYMPTOM
  VALUES(2,2);

/* 5 MODIFY EXISTING ROWS */
/* 5A UPDATE COMMAND */
UPDATE PATIENT
  SET GENDER='F'
  WHERE PATIENT_ID=3;

/* 5B SUBSTITUTION VARIABLES */

/* 6 DELETING ROWS */
DELETE FROM PATIENT
  WHERE PATIENT_ID=3;


/* 8 INDEX CREATION */

/* 8A B-TREE */
CREATE INDEX COUNTRY_NAME_IDX
  ON COUNTRY(NAME);
/* 8B BITMAP */
CREATE BITMAP INDEX PATIENT_BLOOD_TYPE_IDX
  ON PATIENT(BLOOD_TYPE);
/* 8C FUNCTION-BASED */
CREATE INDEX CASE_CONTRACT_REPORT_IDX
  ON CASE(DATE_CONTRACTED - DATE_REPORTED);


/*END OF DATABASE CREATION SECTION */




/* 9 QUERIES FOR RESTRICTING ROWS AND SORTING DATA */

/*9A WHERE CLAUSE, 9B BETWEEN AND OPERATOR, 11Dd TO_DATE FUNCTION, 9Ga SECONDARY SORT IN ORDER BY CLAUSE  */
SELECT DOB, PATIENT_ID, GENDER, BLOOD_TYPE
  FROM PATIENT
  WHERE DOB BETWEEN TO_DATE('JANUARY 01, 60','MONTH DD, YY') AND TO_DATE('DECEMBER 31, 64','MONTH DD, YY')
  ORDER BY DOB DESC, GENDER;

/* 9C IN OPERATOR, 9E LOGICAL OPERATORS, 9Gb ORDER BY SELECT ORDER*/
SELECT PATIENT_ID,BLOOD_TYPE, GENDER 
  FROM PATIENT
  WHERE BLOOD_TYPE IN ('A','O')
  OR GENDER='F'
  ORDER BY 1 DESC;

/* 9D LIKE OPERATORS, 11Ac INITCAP CASE CONVERSION,11Bh CONCAT FUNCTION  */
SELECT CONCAT(INITCAP(FIRST),CONCAT(' ',INITCAP(LAST))) AS FULL_NAME, USER_ID, PASSWORD
  FROM HEALTH_PROFESSION
  WHERE LAST LIKE 'B%';

/*9F TREATMENT OF NULL VALUES */
SELECT PATIENT_ID,DISEASE_ID,DATE_CONTRACTED,REPORTED_BY,DATE_REPORTED
	FROM CASE
	WHERE DATE_CLOSED IS NULL;


/*10A CARTESIAN JOIN */
SELECT PATIENT_ID, NAME
	FROM PATIENT CROSS JOIN COUNTRY;


/*10B EQUALITY JOIN */
SELECT LOCATION_ID, TRAVEL_DESTINATION_ID, POI
	FROM LOCATION NATURAL JOIN TRAVEL_DESTINATION;

/*10C NON-EQUALITY JOIN */
SELECT PATIENT_ID, BLOOD_PRESSURE
	FROM PATIENT JOIN ENCOUNTER
	ON DATE_OF_ENCOUNTER>DOB;

/*10D SELF JOIN */

SELECT h.FIRST, h.LAST, p.LAST
	FROM HEALTH_PROFESSION h JOIN HEALTH_PROFESSION p 
	ON p.HEALTH_PROFESSION_ID = h.HEALTH_PROFESSION_ID;

/*10E OUTER JOIN */
SELECT LAST, FIRST, LOCATION_ID
	FROM LOCATION l FULL OUTER JOIN HEALTH_PROFESSION h 
	USING (LOCATION_ID);

/*11Bb LENGTH FUNCTION*/
SELECT USER_ID,LENGTH(PASSWORD)
	FROM HEALTH_PROFESSION;

/*11Ba SUBSTRING FUNCTION */
SELECT SUBSTR(LAST,1,3)
	FROM HEALTH_PROFESSION;

/* 11Ca ROUND FUNCTION */
SELECT ROUND(PATIENT_ID, 1)
	FROM PATIENT;

/* 11Ca POWER FUNCTION */
SELECT POWER(PATIENT_ID, 3)
	FROM PATIENT;


/* 11Db ADD_MONTHS FUNCTION, 11Dc LAST_DAY AND NEXT_DAY FUNCTION */
SELECT CASE_ID, PATIENT_ID, DATE_CONTRACTED, LAST_DAY(ADD_MONTHS(DATE_CONTRACTED,3) )"EXPECTED CLOSE DATE"
	FROM CASE;
SELECT CASE_ID, PATIENT_ID, DATE_CONTRACTED, NEXT_DAY(ADD_MONTHS(DATE_CONTRACTED,3), MON )"EXPECTED CLOSE DATE"
	FROM CASE;

/* 12C COUNT FUNCTION */

SELECT COUNT(PATIENT_ID) "NUMBER OF PATIENTS"
	FROM PATIENT;

/* 12E MIN FUNCTION, 12D MAX FUNCTION */
SELECT BLOOD_TYPE, MIN(PATIENT_ID)
	FROM PATIENT
	GROUP BY BLOOD_TYPE;
SELECT BLOOD_TYPE, MAX(PATIENT_ID)
	FROM PATIENT
	GROUP BY BLOOD_TYPE;

/*13A SINGLE-ROW SUB QUERY */
SELECT BLOOD_TYPE, PATIENT_ID
	FROM PATIENT
	WHERE PATIENT_ID=(SELECT MAX(PATIENT_ID)
						FROM PATIENT);

/*13B MULTIPLE-ROW SUB QUERY */
SELECT BLOOD_TYPE, PATIENT_ID
	FROM PATIENT
	WHERE PATIENT_ID IN (SELECT PATIENT_ID
						FROM CASE);

/*SELECT PATIENT WITH MULTIPLE DISEASES*/
SELECT PATIENT_ID, CASE_ID, DISEASE_ID
	FROM PATIENT NATURAL JOIN CASE FULL OUTER JOIN DISEASE 
		USING (DISEASE_ID)
	ORDER BY PATIENT_ID DESC;


/*SELECT PATIENTS PER HEALTH PROFESSIONAL GROUPED BY REGION */
SELECT PATIENT_ID, HEALTH_PROFESSION_ID, REGION_ID
	FROM CASE NATURAL JOIN HEALTH_PROFESSION NATURAL JOIN LOCATION;

/*LIST OF DISEASES WITHIN A REGION */ 
SELECT DISEASE_ID, REGION_ID
	FROM DISEASE NATURAL JOIN CASE NATURAL JOIN HEALTH_PROFESSION NATURAL JOIN LOCATION
	ORDER BY REGION_ID;


/*LIST OF SYMPTOMS AND RELATED DISEASES */
SELECT SYMPTOM_ID, NAME, DESCRIPTION, DISEASE_ID
	FROM EXPECTED_SYMPTOM NATURAL JOIN SYMPTOM_LIST;