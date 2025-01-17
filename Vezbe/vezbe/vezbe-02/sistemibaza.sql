-- Primer implicitnog kursora
BEGIN
    UPDATE Projekat 
    SET Nap = ''
    WHERE 1=2; -- namerno false 
    DBMS_OUTPUT.PUT_LINE('Jedan update sa WHERE USLOVOM 1=2');
    DBMS_OUTPUT.PUT_LINE(sql%rowcount || ' zapisa');
END;


/*
Preko tastature uneti podatke o radniku i upisati ga u 
bazu podataka. Za mati?ni broj uzeti narednu vrednost iz 
sekvencera.

Ukoliko je uspe�no uneta nova torka, na konzoli ispisati 
poruku o uspe�nom unosu torke. U 
*/
undefine V_Ime;
undefine V_Prz;
undefine V_Sef;
undefine V_Plt;
undefine V_Pre;
undefine V_God;
DECLARE
    V_Ime radnik.ime%TYPE;
    V_Prz radnik.prz%TYPE;
    V_Sef radnik.sef%TYPE;
    V_Plt radnik.plt%TYPE;
    V_Pre radnik.pre%type;
    V_God radnik.god%TYPE;
BEGIN
    INSERT
    INTO Radnik (Mbr, Ime, Prz, Sef, Plt, God)
    VALUES(SEQUENCE_1.nextval, '&&V_Ime', '&&V_Prz', '&&V_Sef', '&&V_Plt', to_date('&&V_God','DD.MM.YYYY'));
    -- Ako nemate sequencer, kreirajte ga: https://prnt.sc/11pdvhw
    
    if SQL%ROWCOUNT <> 0 then
        dbms_output.put_line('Uspesan upis torke');
    else
        dbms_output.put_line('Nije uspeo upis torke');
    end if;
    
END;

/*
Obrisati radnika ?iji mati?ni broj je unet preko tastature. 
Na konzoli prikazati koliko je radnika obrisano.
*/
undefine V_Mbr;
DECLARE
    V_Mbr Number := 10;
BEGIN
    
    DELETE
    FROM RADNIK
    WHERE Mbr = to_number('&&V_Mbr');
    
    dbms_output.put_line('Izbrisano je: ' || sql%rowcount || ' torki');
END;

-- Primer petlji
-- FOR REVERSE
BEGIN
    FOR i IN REVERSE 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE('Vrednost brojaca i je: ' || TO_CHAR(i));
    END LOOP;
END;

-- FOR
BEGIN
    FOR i IN 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE('Vrednost brojaca i je: ' || TO_CHAR(i));
    END LOOP;
END;

-- WHILE
DECLARE
    i NUMBER(1) := 1;
BEGIN
    WHILE i <= 3 LOOP
        DBMS_OUTPUT.PUT_LINE('Vrednost brojaca i je: ' || TO_CHAR(i));
        i := i + 1;
    END LOOP;
END;

-- LOOP
DECLARE
    i NUMBER(1) := 1;
BEGIN
    LOOP
        EXIT WHEN i > 3;
        DBMS_OUTPUT.PUT_LINE('Vrednost brojaca i je: ' || TO_CHAR(i));
        i := i + 1;
    END LOOP;
END;

/*
Ispisati posebno parne i posebno neparne brojeve od 1 
do broja unetog sa tastature.
*/
undefine V_Br;
DECLARE
    V_Br NUMBER := 0;
    i NUMBER := 1;
BEGIN
    WHILE i <= to_number('&&V_br') LOOP
        if mod(i,2) = 0 then
            dbms_output.put_line(i || ' je paran broj');
        else
            dbms_output.put_line(i || ' je neparan broj');
        end if;
        i := i + 1;
    END LOOP;
    
END;

/*
Napisati PL/SQL blok koji ?e: 
    � interaktivno prihvatiti vrednosti za Prz, Ime, Sef, Plt i 
    God, (za MBR koristiti sekvencer)
    � dodati novu torku u tabelu Radnik, s prethodno 
    preuzetim podacima i
    � anga�ovati novododatog radnika na projektu sa Spr 
    = 10 i 5 sati rada.
*/
undefine V_Ime;
undefine V_Prz;
undefine V_Sef;
undefine V_Plt;
undefine V_God;
DECLARE
BEGIN
    INSERT
    INTO Radnik (Mbr, Ime, Prz, Sef, Plt, God)
    VALUES(SEQUENCE_1.nextval, '&&V_Ime', '&&V_Prz', '&&V_Sef', '&&V_Plt', to_date('&&V_God','DD.MM.YYYY'));

    INSERT
    INTO Radproj (Spr, Mbr, Brc)
    VALUES(10, SEQUENCE_1.currval, 5);
END;

/*
Napisati PL/SQL blok koji ?e: 
    � izbrisati anga�ovanje prethodno dodatog radnika na 
    projektu sa �ifrom 10 i obavestiti porukom korisnika da li 
    je brisanje uspe�no obavljeno,
    � izbrisati prethodno dodatog radnika iz evidencije i 
    obavestiti porukom korisnika da li je brisanje uspe�no 
    obavljeno,
    � sa?uvati vrednost za Mbr izbrisanog radnika u lokalnoj 
    promenljivoj pod nazivom Del_Mb
*/
DECLARE
    Del_Mbr NUMBER := 10;
BEGIN
    Del_Mbr := SEQUENCE_1.currval; -- ovo radi ako prethodno zadatak prvo izvrsimo
    -- pa znamo da je vrednost sekvencera stala na tom mestu
    DELETE 
    FROM RADPROJ
    WHERE Spr = 10 and Mbr = Del_Mbr;
    if sql%rowcount <> 0 then
        dbms_output.put_line('Uspesno brisanje');
    else
        dbms_output.put_line('Neuspesno brisanje');
    end if;
    
    DELETE
    FROM RADNIK
    WHERE Mbr = Del_Mbr;
    if sql%rowcount <> 0 then
        dbms_output.put_line('Uspesno brisanje');
    else
        dbms_output.put_line('Neuspesno brisanje');
    end if;
    
--    Del_Mbr := SEQUENCE_1.currval;
    
END;

/*
Kreirati tabelu Spisak_zarada, kori�?enjem SQL komande:
    CREATE TABLE Spisak_zarada (Mbr NUMBER(3),
    Plt NUMBER(10, 2), Evri VARCHAR2(10),
      CONSTRAINT Sz_PK PRIMARY KEY (Mbr))
  
Napisati PL/SQL blok koji ?e:
    za svaku torku iz tabele Radnik, za koju je mati?ni broj u 
    intervalu od 10 do 100, izuzimaju?i radnika s mati?nim 
    brojem 90, preneti u tabelu Spisak_zarada mati?ni broj, 
    iznos plate, i inicijalizovati polje Evri sa vredno�?u plate 
    u evrima. Ukoliko radnik ve? postoji u tabeli izvr�iti 
    izmenu vrednosti obele�ja Plt i Evri. Kurs evra treba da 
    zadaje korisnik iz okru�enja.
*/

undefine V_Plt;
undefine V_Kurs_evra;
DECLARE
    V_Plt radnik.plt%TYPE;
    i NUMBER := 10;
    V_Kurs_evra NUMBER := 117;
    V_Br_nadjenih_radnika NUMBER := 0;
BEGIN
    WHILE i <= 100 LOOP
        if i <> 90 then
            SELECT Plt
            INTO V_Plt
            FROM RADNIK
            WHERE Mbr = i;
            
            SELECT Count(*)
            INTO V_Br_nadjenih_radnika
            FROM SPISAK_ZARADA
            WHERE Mbr = i;
            
            if V_Br_nadjenih_radnika > 0 then
                UPDATE SPISAK_ZARADA
                SET Plt = V_Plt, Evri = V_Plt * to_number('&&V_kurs_evra')
                WHERE Mbr = i;
            else
                INSERT 
                INTO SPISAK_ZARADA(Mbr, Plt, Evri) 
                VALUES (i, V_Plt, V_Plt * to_number('&&V_kurs_evra'));
            end if;
            
        end if;
        i := i + 10;
    END LOOP;
END;

















