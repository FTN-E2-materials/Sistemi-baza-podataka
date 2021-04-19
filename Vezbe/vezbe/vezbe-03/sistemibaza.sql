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
-- Ocevidno je da se ovo dosta lakse resava preko procedure, ali u ovom trenutku je nismo radili
-- te zbog toga krsimo DRY i ponavljamo se tri puta za istu stvar ali makar koristimo isti kursor
DECLARE
    V_tek_red Radnik%ROWTYPE;
    V_Je_sef BOOLEAN := FALSE;
    
    CURSOR radnici_sefa(V_sef_mbr Radnik.sef%TYPE) IS
    SELECT *
    FROM RADNIK
    WHERE Sef = V_sef_mbr;
    
BEGIN
    -- Savo Oroz sa MBR-om 70
    OPEN radnici_sefa(70); -- Savo Oroz, MBR mu je 70
    FETCH radnici_sefa INTO V_tek_red;
    V_Je_sef := radnici_sefa%found;
    CLOSE radnici_sefa;
    
    if V_Je_sef then
        OPEN radnici_sefa(70); -- Savo Oroz, MBR mu je 70
        dbms_output.put_line('Radnici kojima je sef Savo Oroz');
        LOOP
            FETCH radnici_sefa INTO V_tek_red;
            EXIT WHEN (radnici_sefa%NOTFOUND);
            dbms_output.put_line('Ime zaposlenog je ' || V_tek_red.Ime);
        END LOOP;
        CLOSE radnici_sefa;
    else
        dbms_output.put_line('Savo Oroz nije sef !');
    end if;
    
    -- Pera Peric sa MBR-om 10
    OPEN radnici_sefa(10); 
    FETCH radnici_sefa INTO V_tek_red;
    V_Je_sef := radnici_sefa%found;
    CLOSE radnici_sefa;
    
    if V_Je_sef then
        OPEN radnici_sefa(10);
        dbms_output.put_line('Radnici kojima je sef Pera Peric');
        LOOP
            FETCH radnici_sefa INTO V_tek_red;
            EXIT WHEN (radnici_sefa%NOTFOUND);
            dbms_output.put_line('Ime zaposlenog je ' || V_tek_red.Ime);
        END LOOP;
        CLOSE radnici_sefa;
    else
        dbms_output.put_line('Pera Peric nije sef !');
    end if;
    
     -- Djoka Djokic sa MBR-om 120
    OPEN radnici_sefa(120); 
    FETCH radnici_sefa INTO V_tek_red;
    V_Je_sef := radnici_sefa%found;
    CLOSE radnici_sefa;
    
    if V_Je_sef then
        OPEN radnici_sefa(120);
        dbms_output.put_line('Radnici kojima je sef Djoka Djokic');
        LOOP
            FETCH radnici_sefa INTO V_tek_red;
            EXIT WHEN (radnici_sefa%NOTFOUND);
            dbms_output.put_line('Ime zaposlenog je ' || V_tek_red.Ime);
        END LOOP;
        CLOSE radnici_sefa;
    else
        dbms_output.put_line('Djoka Djokic nije sef !');
    end if;
END;
























