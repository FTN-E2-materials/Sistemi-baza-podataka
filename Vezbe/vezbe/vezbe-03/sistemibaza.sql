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
    OPEN spisak_rad; -- otvoren kursor, izvršava se SELECT

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
    OPEN spisak_rad (01, 99); -- otvoren kursor, izvršava se SELECT
    
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
    – Ispisati sve radnike koji rade u sektorima kojima rukovode Pera 
    Peri?, Savo Oroz i ?oka ?oki?. Ukoliko neko od njih nije šef 
    obavestiti korisnika o tome.
    – Ispis rezultata treba da izgleda na slede?i na?in:

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
    radnik uopšte nema premiju dati mu premiju od 
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






















