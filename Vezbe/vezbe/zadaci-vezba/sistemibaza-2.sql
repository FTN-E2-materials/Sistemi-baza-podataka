/*
 Napisati triger koji za svaku operaciju ažuriranja 
tabele Radnik, upisuje odgovaraju?e podatke u 
arhivsku (journal) tabelu Radnik_JN. Za 
operaciju INSERT, isti podaci se prenose i u 
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
);

CREATE OR REPLACE TRIGGER UPD_RAD
    BEFORE UPDATE OR DELETE OR INSERT
    ON RADNIK
    FOR EACH ROW
        
    BEGIN
        IF UPDATING then
            insert into Radnik_JN(Dat,Ope,Mbr,Ime,Prz,Plt) values(SYSDATE,'upd',:Old.mbr,:Old.ime,:Old.prz,:Old.plt);
        elsif INSERTING THEN
            insert into Radnik_JN(Dat,Ope,Mbr,Ime,Prz,Plt) values(SYSDATE,'ins',:New.mbr,:New.ime,:New.prz,:New.plt);
        elsif DELETING then
             insert into Radnik_JN(Dat,Ope,Mbr,Ime,Prz,Plt) values(SYSDATE,'del',:Old.mbr,:Old.ime,:Old.prz,:Old.plt);
        end if;
    END UPD_RAD;
insert into Radnik(mbr,ime,prz,sef,plt,pre,god) values(SEQUENCE1.NEXTVAL,'Limuncica','Limunovic',50,40000,1000,'01-JAN-98');
update Radnik
set ime='Pomorancica'
where mbr=310;
delete from Radnik
where mbr=310;
/*
    Kad se kreira novi radnik, podmetnuti nas mbr (preko sekvencera)
    odnosno, zanemariti onaj mbr koji je on zeleo da ubaci.
*/
CREATE OR REPLACE TRIGGER Ispis_Trigger
    BEFORE INSERT 
    ON Radnik
    FOR EACH ROW
    BEGIN
        dbms_output.put_line('Ja volim Vlada' || :New.Mbr); 
        :New.Mbr := SEQUENCE1.NEXTVAL;
        :New.Prz := 'Perisic-Maksimovic';
    END Ispis_Trigger;
    

INSERT 
INTO Radnik(mbr, ime, prz, sef, plt, pre, god)
VALUES (10, 'Ana', 'Maksimovic', 10, 10000, 1000, '12-SEP-98');