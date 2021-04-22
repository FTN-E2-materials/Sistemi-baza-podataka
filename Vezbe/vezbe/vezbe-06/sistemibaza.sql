/*
Napisati triger koji za svaku operaciju ažuriranja 
tabele Radnik, upisuje odgovarajuce podatke u 
arhivsku (journal) tabelu Radnik_JN. 
Za operaciju INSERT, isti podaci se prenose i u 
tabelu Radnik_JN. Za operaciju UPDATE ili 
DELETE, stare vrednosti torke se prenose u 
tabelu Radnik_JN.
*/

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