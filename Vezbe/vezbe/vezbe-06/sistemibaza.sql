/*
Napisati triger koji za svaku operaciju ažuriranja 
tabele Radnik, upisuje odgovarajuce podatke u 
arhivsku (journal) tabelu Radnik_JN. 
Za operaciju INSERT, isti podaci se prenose i u 
tabelu Radnik_JN. Za operaciju UPDATE ili 
DELETE, stare vrednosti torke se prenose u 
tabelu Radnik_JN.
*/
CREATE TABLE Radnik_JN
(
Dat DATE NOT NULL,
Ope varchar(3) NOT NULL,
Mbr integer NOT NULL,
Ime varchar(20),
Prz varchar(25),
Plt decimal(10, 2),
CONSTRAINT radnik_JN_PK 
PRIMARY KEY (Dat, Ope, Mbr)
)

CREATE OR REPLACE TRIGGER RADNIK_IN_IUD 
    BEFORE
    INSERT OR DELETE OR UPDATE 
    ON RADNIK
    FOR EACH ROW
    DECLARE
        i BINARY_INTEGER := 0;
    BEGIN
        IF INSERTING then
            INSERT 
            INTO radnik_jn( Dat, Ope, Mbr, Ime, Prz, Plt)
            VALUES (SYSDATE, 'INS', :new.Mbr, :new.Ime, :new.Prz, :new.Plt);
        elsif UPDATING then
            INSERT 
            INTO radnik_jn( Dat, Ope, Mbr, Ime, Prz, Plt)
            VALUES (SYSDATE, 'UPD', :old.Mbr, :old.Ime, :old.Prz, :old.Plt);
        elsif DELETING then
            INSERT 
            INTO radnik_jn( Dat, Ope, Mbr, Ime, Prz, Plt)
            VALUES (SYSDATE, 'DEL', :old.Mbr, :old.Ime, :old.Prz, :old.Plt);
        end if;
        
    END;
    
INSERT 
INTO radnik(Mbr, Ime, Prz, Sef, Plt, Pre, God) 
VALUES (SEQUENCE_1.NEXTVAL, 'Jovan', 'Jovanovi', 10, 1000, 100, '01-JAN-87');

UPDATE radnik
set Ime = 'Peraaa'
WHERE Mbr = 10;

/*
Formirati triger koji ?e, nad tabelom 
Radnik, zabraniti bilo koji pokušaj modifikacije 
vrednosti primarnog klju?a (mati?nog broja 
radnika).
*/
CREATE OR REPLACE TRIGGER STOP_MODIFY_MBR
    BEFORE
    UPDATE OF Mbr
    ON RADNIK
    FOR EACH ROW WHEN (New.Mbr != Old.Mbr)
    DECLARE
        Zabrana_Menjanja_Mbr_EXC Exception;
    BEGIN
        RAISE Zabrana_Menjanja_Mbr_EXC;
    EXCEPTION
        WHEN Zabrana_Menjanja_Mbr_EXC THEN
            Raise_Application_Error(-20000, 'Nije dozvoljeno menjanje obelezja MBR tabele radnik !');
    END STOP_MODIFY_MBR;
    
UPDATE radnik
set Mbr = 1000
WHERE Mbr = 10;

/*
Formirati triger koji ?e, nad tabelom 
Radnik, obezbediti da se prilikom unosa nove 
torke, uvek zada vrednost mati?nog broja kao 
prva slede?a vrednost iz kreiranog generatora 
sekvence, bez obzira na to šta je korisnik zadao 
za vrednost Mbr u klauzuli VALUES.
*/

CREATE OR REPLACE TRIGGER ZADAVANJE_NEXTVAL_MBRA
    BEFORE
    INSERT
    ON Radnik
    FOR EACH ROW
    DECLARE
        our_mbr Radnik.Mbr%TYPE := SEQUENCE_1.NEXTVAL;
    BEGIN
        :New.Mbr := our_mbr;
    END ZADAVANJE_NEXTVAL_MBRA;


INSERT 
INTO radnik(Mbr, Ime, Prz, Sef, Plt, Pre, God) 
VALUES (1000, 'Jovan', 'Jovanovi', 10, 1000, 100, '01-JAN-87');


























