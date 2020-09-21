/* Tablespace */
CREATE TABLESPACE SIMPLE_LEDGER_DATA
  DATAFILE 'tbs_sl' SIZE 16M AUTOEXTEND ON NEXT 16M
  MAXSIZE UNLIMITED;

/* Schema */
CREATE USER SIMPLE_LEDGER IDENTIFIED BY SIMPLE_LEDGER
  DEFAULT TABLESPACE SIMPLE_LEDGER_DATA TEMPORARY TABLESPACE TEMP;
ALTER USER SIMPLE_LEDGER ACCOUNT LOCK;
GRANT CONNECT, RESOURCE, CREATE SEQUENCE TO SIMPLE_LEDGER;
ALTER USER SIMPLE_LEDGER QUOTA UNLIMITED ON SIMPLE_LEDGER_DATA;
GRANT MERGE ANY VIEW TO SIMPLE_LEDGER;

/* Application user */
CREATE USER SIMPLE_LEDGER_APP IDENTIFIED BY SIMPLE_LEDGER DEFAULT TABLESPACE SIMPLE_LEDGER_DATA TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE, CREATE SESSION TO SIMPLE_LEDGER_APP;
ALTER USER SIMPLE_LEDGER_APP QUOTA UNLIMITED ON SIMPLE_LEDGER_DATA;
GRANT MERGE ANY VIEW TO SIMPLE_LEDGER_APP;

/* Sequence */
CREATE SEQUENCE SIMPLE_LEDGER.SQ_DATA
  INCREMENT BY 1 START WITH 1
  NOCYCLE NOCACHE ORDER;

CREATE SYNONYM SIMPLE_LEDGER_APP.SQ_DATA FOR SIMPLE_LEDGER.SQ_DATA;

/* Table */
CREATE TABLE SIMPLE_LEDGER.TB_DATA(
    id NUMBER PRIMARY KEY
  , sender VARCHAR2(100) NOT NULL
  , receiver VARCHAR2(100) NOT NULL
  , amount NUMBER(38,8) NOT NULL
  , currency VARCHAR2(3) NOT NULL
  , business_time TIMESTAMP NOT NULL
) TABLESPACE SIMPLE_LEDGER_DATA;

CREATE TABLE SIMPLE_LEDGER.TB_USER(
    id NUMBER PRIMARY KEY
  , fullname VARCHAR2(100) NOT NULL
) TABLESPACE SIMPLE_LEDGER_DATA;

/* Constraints */
ALTER TABLE SIMPLE_LEDGER.TB_DATA
  ADD CONSTRAINT CHK_SENDER
  CHECK (LENGTH(sender) > 3 AND sender LIKE '% %');

ALTER TABLE SIMPLE_LEDGER.TB_DATA
  ADD CONSTRAINT CHK_RECEIVER
  CHECK (LENGTH(receiver) > 3 AND receiver LIKE '% %');

ALTER TABLE SIMPLE_LEDGER.TB_DATA
  ADD CONSTRAINT CHK_AMOUNT
  CHECK (amount > 0);

ALTER TABLE SIMPLE_LEDGER.TB_DATA
  ADD CONSTRAINT CHK_CURRENCY
  CHECK (LENGTH(currency) >= 3 AND LENGTH(currency) <= 4 AND currency = UPPER(currency));

ALTER TABLE SIMPLE_LEDGER.TB_USER
  ADD CONSTRAINT CHK_FULLNAME
  CHECK (LENGTH(fullname) > 3 AND fullname LIKE '% %');

/* Grant to access table */
GRANT SELECT, INSERT ON SIMPLE_LEDGER.TB_DATA TO SIMPLE_LEDGER_APP;
GRANT SELECT ON SIMPLE_LEDGER.TB_USER TO SIMPLE_LEDGER_APP;
GRANT SELECT ON SIMPLE_LEDGER.SQ_DATA TO SIMPLE_LEDGER_APP;

/* Users */
INSERT INTO SIMPLE_LEDGER.TB_USER(id, fullname)
  WITH names AS (
    SELECT  1 AS id, 'Demarcus Dibernardo' AS fullname FROM dual UNION ALL
    SELECT  2, 'Kiesha Kua' FROM dual UNION ALL
    SELECT  3, 'Nydia Newlon' FROM dual UNION ALL
    SELECT  4, 'Ava Aquino' FROM dual UNION ALL
    SELECT  5, 'Lauryn Lachowicz' FROM dual UNION ALL
    SELECT  6, 'Shoshana Shackelford' FROM dual UNION ALL
    SELECT  7, 'Velma Vawter' FROM dual UNION ALL
    SELECT  8, 'Katina Korte' FROM dual UNION ALL
    SELECT  9, 'Kacy Kruger' FROM dual UNION ALL
    SELECT 10, 'Tosha Turmelle' FROM dual UNION ALL
    SELECT 11, 'Catrice Corder' FROM dual UNION ALL
    SELECT 12, 'Eliseo Eccles' FROM dual UNION ALL
    SELECT 13, 'Carlena Coakley' FROM dual UNION ALL
    SELECT 14, 'Mallory Mcculler' FROM dual UNION ALL
    SELECT 15, 'Marilynn Manz' FROM dual UNION ALL
    SELECT 16, 'Gita Guo' FROM dual UNION ALL
    SELECT 17, 'Alfredia Arebalo' FROM dual UNION ALL
    SELECT 18, 'Liane Laguardia' FROM dual UNION ALL
    SELECT 19, 'Russell Rochell' FROM dual UNION ALL
    SELECT 20, 'Peter Perlmutter' FROM dual UNION ALL
    SELECT 21, 'Alita Abron' FROM dual UNION ALL
    SELECT 22, 'Adah Ausmus' FROM dual UNION ALL
    SELECT 23, 'Mitchell Mattingly' FROM dual UNION ALL
    SELECT 24, 'Tonette Toews' FROM dual UNION ALL
    SELECT 25, 'Brett Batt' FROM dual UNION ALL
    SELECT 26, 'Eugenia Eisenstein' FROM dual UNION ALL
    SELECT 27, 'Tiffanie Tackitt' FROM dual UNION ALL
    SELECT 28, 'Minh Marsala' FROM dual UNION ALL
    SELECT 29, 'Vaughn Vida' FROM dual UNION ALL
    SELECT 30, 'Terica Toms' FROM dual UNION ALL
    SELECT 31, 'Juana Jeremiah' FROM dual UNION ALL
    SELECT 32, 'Katherine Keefer' FROM dual UNION ALL
    SELECT 33, 'Myesha Macek' FROM dual UNION ALL
    SELECT 34, 'Bette Bribiesca' FROM dual UNION ALL
    SELECT 35, 'Dionne Durrett' FROM dual UNION ALL
    SELECT 36, 'Arvilla Almquist' FROM dual UNION ALL
    SELECT 37, 'Laci Lawver' FROM dual UNION ALL
    SELECT 38, 'Kip Kearney' FROM dual UNION ALL
    SELECT 39, 'Raguel Rising' FROM dual UNION ALL
    SELECT 40, 'Rich Ryland' FROM dual UNION ALL
    SELECT 41, 'Charis Claflin' FROM dual UNION ALL
    SELECT 42, 'Shaquita Soliz' FROM dual UNION ALL
    SELECT 43, 'Zula Zwick' FROM dual UNION ALL
    SELECT 44, 'Bill Bachmann' FROM dual UNION ALL
    SELECT 45, 'Jack Jeppesen' FROM dual UNION ALL
    SELECT 46, 'Lula Locicero' FROM dual UNION ALL
    SELECT 47, 'Christena Clausing' FROM dual UNION ALL
    SELECT 48, 'Estella Edenfield' FROM dual UNION ALL
    SELECT 49, 'Roseanna Rosa' FROM dual UNION ALL
    SELECT 50, 'Cassaundra Colclough' FROM dual
  )
  SELECT id, fullname FROM names;

COMMIT;