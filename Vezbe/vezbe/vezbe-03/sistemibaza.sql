-- Primer: Eksplicitno deklarisanje kursora
DECLARE
    Ukup_plt NUMBER;
    L_Mbr radnik.Mbr%TYPE;
    L_Plt radnik.Plt%TYPE;

    CURSOR spisak_rad IS -- eksplicitno deklarisani kursor
    SELECT Mbr, Plt
    FROM radnik
    WHERE Mbr BETWEEN 01 AND 99;

BEGIN
    Ukup_Plt := 0;
    OPEN spisak_rad; -- otvoren kursor, izvr�ava se SELECT

    LOOP
        FETCH spisak_rad INTO L_Mbr, L_Plt; -- dobavljanje naredne torke iz kursora
        EXIT WHEN spisak_rad%NOTFOUND; -- uslov izlaska iz petlje
        Ukup_Plt := Ukup_Plt + L_Plt;
    END LOOP;

    CLOSE spisak_rad; -- zatvoren kursor
    DBMS_OUTPUT.PUT_LINE('Plata je: ' || Ukup_Plt);
END;

-- Primer: Eksplicitno deklarisanje kursora s parametrima i funkcijom %rowcount
DECLARE
    Ukup_plt NUMBER;
    L_tek_red Radnik%ROWTYPE;
    
    -- kursor, deklarisan s parametrima
    CURSOR spisak_rad (D_gran Radnik.Mbr%TYPE, G_gran Radnik.Mbr%TYPE) IS
    SELECT *
    FROM radnik
    WHERE Mbr BETWEEN D_gran AND G_gran;

BEGIN
    Ukup_Plt := 0;
    OPEN spisak_rad (01, 99); -- otvoren kursor, izvr�ava se SELECT
    
    LOOP
        FETCH spisak_rad INTO L_tek_red;
        EXIT WHEN (spisak_rad%NOTFOUND) OR (spisak_rad%ROWCOUNT > 5);
        Ukup_Plt := Ukup_Plt + L_tek_red.Plt;
    END LOOP;

    CLOSE spisak_rad; -- zatvoren kursor
    DBMS_OUTPUT.PUT_LINE('Plata je: ' || Ukup_Plt); 
END; 


/*
Napisati PL/SQL blok koji ?e:
    � Ispisati sve radnike koji rade u sektorima kojima rukovode Pera 
    Peri?, Savo Oroz i ?oka ?oki?. Ukoliko neko od njih nije �ef 
    obavestiti korisnika o tome.
    � Ispis rezultata treba da izgleda na slede?i na?in:

        Radnici kojima je sef ...
        Ime zaposlenog je ...
        Ime zaposlenog je ...
        Radnici kojima je sef ...
        Ime zaposlenog je ...
*/

undefine sef_ime;
undefine sef_prz;
DECLARE
    V_Je_sef BOOLEAN := FALSE;
    V_temp_ime Radnik.ime%TYPE;
    V_temp_prz Radnik.prz%TYPE;
    
    CURSOR radnici_sefa(V_sef_ime Radnik.ime%TYPE, V_sef_prz Radnik.prz%TYPE) IS
    SELECT r1.Ime, r1.Prz
    FROM RADNIK r1, RADNIK r2
    WHERE r1.sef = r2.mbr and r2.Ime = V_sef_ime and r2.Prz = V_sef_prz;
    
BEGIN

    OPEN radnici_sefa('&&sef_ime','&&sef_prz'); 
    FETCH radnici_sefa INTO V_temp_ime, V_temp_prz;
    V_Je_sef := radnici_sefa%found;
    CLOSE radnici_sefa;
    
    if V_Je_sef then
        OPEN radnici_sefa('&&sef_ime','&&sef_prz'); 
        dbms_output.put_line('Radnici kojima je sef ' || '&&sef_ime' || ' ' || '&&sef_prz');
        LOOP
            FETCH radnici_sefa INTO V_temp_ime, V_temp_prz;
            EXIT WHEN (radnici_sefa%NOTFOUND);
            dbms_output.put_line('Ime zaposlenog je ' || V_temp_ime || ' ' || V_temp_prz);
        END LOOP;
        CLOSE radnici_sefa;
    else
            dbms_output.put_line('Imamo situaciju da nije sef: ' || '&&sef_ime' || ' ' || '&&sef_prz');
    end if;
   
END;

/*
Napisati PL/SQL blok koji ?e:
    za zadati naziv projekta, za svakog radnika koji 
    radi na tom projektu i ima broj ?asova rada ve?i 
    od jedan pove?ati premiju za 10 posto. Ako 
    radnik uop�te nema premiju dati mu premiju od 
    1000.
*/

DECLARE
    V_temp_radnik radnik%rowtype;
    
    CURSOR radnici(V_Nap projekat.nap%TYPE, V_brc radproj.brc%type) IS
    SELECT r.mbr, r.ime, r.prz, r.sef, r.plt, r.pre, r.god
    FROM projekat p, radproj rp, radnik r
    WHERE p.nap = V_Nap and rp.spr = p.spr and rp.mbr = r.mbr and rp.brc > V_brc;

BEGIN
    OPEN radnici('&V_in_nap',to_number('&V_in_brc'));
    
    LOOP
        FETCH radnici INTO V_temp_radnik;
        EXIT WHEN radnici%notfound;
        
        if V_temp_radnik.Pre is null then
            UPDATE Radnik
            SET Pre = 1000
            WHERE mbr = V_temp_radnik.Mbr;
        else
            UPDATE Radnik
            SET Pre = Pre + (0.1*Pre)
            WHERE mbr = V_temp_radnik.Mbr;
        end if;
        
        dbms_output.put_line(V_temp_radnik.Ime || ' ' || V_temp_radnik.Prz);
    END LOOP;
    
    CLOSE radnici;
END;

-- Primeri upotrebe promenljivih tipa tabele
DECLARE
    TYPE T_Tab IS TABLE OF VARCHAR2(20) 
        INDEX BY BINARY_INTEGER;
    Tab T_Tab;
    i BINARY_INTEGER;
BEGIN
    Tab(1) := 'DEJAN';
    Tab(3) := 'NENAD';
    Tab(-1) := 'MARKO';
    Tab(5) := 'ACA';
    Tab.DELETE(1);
    i := Tab.FIRST;
    WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || Tab(i));
        i := Tab.NEXT(i);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(i), 'i ima NULL vrednost.'));
END;

-- Primer 2 [Zadaci ovog tipa dolaze na kolokvijum]
DECLARE
    TYPE T_Slog IS RECORD(
        Naziv VARCHAR2(50),
        BrojStudenata NUMBER := 0);
    TYPE T_Tab IS TABLE OF T_Slog 
        INDEX BY BINARY_INTEGER;
    Tabela T_Tab; 
    i BINARY_INTEGER;
BEGIN
    Tabela(1).Naziv := 'Napredno serversko programiranje';
    Tabela(1).BrojStudenata := 12;
    Tabela(2).Naziv := 'Informacioni sistemi';
    Tabela(2).BrojStudenata := 8;
    i := Tabela.FIRST; 
    WHILE i <= Tabela.LAST LOOP
        DBMS_OUTPUT.PUT('Broj studenata koji slusa predmet ');
        DBMS_OUTPUT.PUT('"' ||Tabela(i).Naziv || '" je ');
        DBMS_OUTPUT.PUT_LINE(Tabela(i).BrojStudenata);
        i := Tabela.NEXT(i);
    END LOOP; 
END;

-- Pimer 3
DECLARE
    TYPE T_Tab IS TABLE OF VARCHAR2(20);
    Tab1 T_Tab := T_Tab();
    Tab2 T_Tab := T_Tab('Janko', 'Jana');
    i BINARY_INTEGER;
BEGIN
    Tab1.EXTEND(5);
    Tab1(1) := 'Ana';
    Tab1(3) := 'Bora';
    -- Tab(-1) := 'Cane�; NIJE MOGU?E! Indeks ugne�denih tabela mo�e i?i samo od 1!
    Tab1(5) := 'Darko';
    
    i := Tab1.FIRST;
    WHILE i <= Tab1.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || Tab1(i));
        i := Tab1.NEXT(i);
    END LOOP;

    i:= Tab2.FIRST;
    WHILE i <= Tab2.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || Tab2(i));
        i := Tab2.NEXT(i);
    END LOOP;
END;

-- Primer eksplicitno deklarisanog kursora s 
-- parametrima i upotrebe kursorske FOR petlje.
DECLARE
    Ukup_Plt NUMBER;
    CURSOR spisak_rad (D_gran radnik.Mbr%TYPE, G_gran radnik.Mbr%TYPE) IS
    SELECT *
    FROM radnik
    WHERE Mbr BETWEEN D_gran AND G_gran;
BEGIN
    Ukup_Plt := 0;
    FOR p_tek_red IN spisak_rad (01, 99) LOOP
        Ukup_Plt := Ukup_Plt + p_tek_red.Plt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Plata je: ' || Ukup_Plt);
END;


/*
Napisati PL/SQL blok koji ?e preuzeti sve torke 
iz tabele Projekat i prebaciti ih u PL/SQL 
tabelarnu kolekciju. Zatim ?e, redom, od�tampati 
sve elemente tako dobijene tabelarne kolekcije.
*/

DECLARE
    CURSOR projekti IS
    SELECT *
    FROM Projekat;
    
    TYPE T_Tab is TABLE OF projekti%rowtype
        INDEX BY BINARY_INTEGER;
        
    TabelarnaKolekcija T_Tab;
    i BINARY_INTEGER := 1;
BEGIN
    
    FOR P_tek_red IN projekti LOOP
        TabelarnaKolekcija(i) := P_tek_red;
        i := i + 1;
    END LOOP;
    
    i := TabelarnaKolekcija.FIRST;
    while i <= TabelarnaKolekcija.LAST LOOP
        dbms_output.put_line(TabelarnaKolekcija(i).Spr || ' ' || TabelarnaKolekcija(i).Ruk || ' ' || TabelarnaKolekcija(i).Nap || ' ' || TabelarnaKolekcija(i).Nar);
        i := TabelarnaKolekcija.NEXT(i);
    END LOOP;
END;