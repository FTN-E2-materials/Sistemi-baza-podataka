/* ZADATAK OVOG TIPA NA KOLOKVIJUMU
Napisati PL/SQL blok koji ?e preuzeti sve torke 
iz tabele Projekat, ure?ene u opadaju?em 
redosledu šifri projekata, i prebaciti ih u PL/SQL 
tabelarnu kolekciju.

Uz svaku preuzetu torku iz 
tabele Projekat, treba inicijalizovati novu 
kolekciju koja ?e sadržati skup svih mati?nih 
brojeva radnika, koji su angažovani na datom 
projektu.

Zatim treba, redom, odštampati sve 
torke iz kolekcije projekata, a uz svaku torku iz 
kolekcije projekata treba prikazati mati?ne 
brojeve svih radnika koji su angažovani na tom 
projektu.
*/
DECLARE 
    -- dobavljam sve projekte
    CURSOR projekti IS
    SELECT *
    FROM Projekat
    ORDER BY SPR DESC;
    
    -- dobavljam radnike na prosledjenom projektu
    CURSOR radnici(V_Radnici_Spr Radproj.Spr%type) IS
    SELECT *
    FROM Radproj
    WHERE Spr = V_Radnici_Spr;
    
    -- kolekcija mbr-ova radnika
    TYPE T_TabRadnici is TABLE of NUMBER
        INDEX BY BINARY_INTEGER;
    
    -- struktura projekat: radnici
    TYPE T_Slog is RECORD(
        S_Projekat projekti%rowtype,
        S_Tab_Radnici T_TabRadnici
    );
    
    -- kolekcija struktura projekat: radnici
    TYPE T_TabProjeti is TABLE of T_Slog
        INDEX BY BINARY_INTEGER;
    
    Tab_Projekti T_TabProjeti;
    i_proj BINARY_INTEGER := 0;
    i_rad BINARY_INTEGER := 0;

BEGIN

    -- inicijalizacija projekat: radnici(mbr)
    FOR P_tek_red IN projekti LOOP
        Tab_Projekti(i_proj).S_Projekat := P_tek_red;
        
        i_rad := 0;
        FOR P_tek_red_2 IN radnici(Tab_Projekti(i_proj).S_Projekat.Spr) LOOP
            Tab_Projekti(i_proj).S_Tab_Radnici(i_rad) := P_tek_red_2.Mbr;
            i_rad := i_rad + 1;
        END LOOP;
        
        i_proj := i_proj + 1;
    END LOOP;
    
    -- ispis
    i_proj := Tab_Projekti.FIRST;
    WHILE i_proj<=Tab_Projekti.LAST LOOP
    
        i_rad := Tab_Projekti(i_proj).S_Tab_Radnici.First;
        if i_rad > -1 then   -- predpostavio sam da cemo indeksirati od 0 (First vraca prvi index,0)
            dbms_output.put_line('Projekat sa sifrom ' || Tab_Projekti(i_proj).S_Projekat.Spr || ' ima angazovane sledece radnike ');    
            WHILE i_rad <= Tab_Projekti(i_proj).S_Tab_Radnici.LAST LOOP
                dbms_output.put_line(Tab_Projekti(i_proj).S_Tab_Radnici(i_rad));
                i_rad := Tab_Projekti(i_proj).S_Tab_Radnici.Next(i_rad);
            END LOOP;
        else
            dbms_output.put_line('Projekat sa sifrom ' || Tab_Projekti(i_proj).S_Projekat.Spr || ' trenutno nema angazovanih radnika');    
        end if;
        
        i_proj := Tab_Projekti.NEXT(i_proj);
    END LOOP;
    
END;


/*
Napisati PL/SQL blok koji ?e prikazati koliko 
radnika nema ni najmanju ni najve?u platu
*/

DECLARE
    V_Max_plt NUMBER := 0;
    V_Min_plt NUMBER := 0;
    V_Br_radnika NUMBER := 0;
BEGIN
    SELECT MAX(plt), MIN(plt)
    INTO V_Max_plt, V_Min_Plt
    FROM RADNIK;
    
    SELECT Count(*)
    INTO V_Br_radnika
    From Radnik
    WHERE Plt > V_Min_plt and Plt < V_Max_plt;
    
    dbms_output.put_line(V_Br_radnika || ' radnika nema ni najmanju ni najvecu platu');
END;

/*
Sve radnike ?iji je mati?ni broj izme?u 1 i 99
ozna?iti za otpuštanje dodavanjem slova X na
kraj njihovog prezimena. Ažuriranje obaviti
pomo?u kursorske UPDATE naredbe. Tako?e
Izra?unati ukupnu svotu novca koja ?e biti na
raspolaganju kompaniji na mese?nom nivou kao
posledica njihovog otpuštanja.

• Ukoliko ne postoje radnici u tom opsegu
mati?nih brojeva, poništiti transakciju.

• Testirati program i sa unosom opsega mati?nih
brojeva sa tastature.
*/

DECLARE
    
    CURSOR radnici(P_Dgran Radnik.mbr%type, P_Ggran Radnik.mbr%type) IS
    SELECT *
    FROM Radnik
    WHERE mbr BETWEEN P_Dgran and P_Ggran
    FOR UPDATE of Ime NOWAIT;
    
    V_Usteda NUMBER := 0;
BEGIN
    
    FOR T_radnik in radnici(&A_Dgran,&A_Ggran) LOOP
        if V_Usteda = 0 then
            V_Usteda := 0;
        end if;
        
        UPDATE Radnik
        SET Ime = Ime || 'X'
        WHERE CURRENT of radnici;
        
        V_Usteda := V_Usteda + nvl(T_radnik.plt,0) + nvl(T_radnik.pre,0);
        
    END LOOP;
    
    if V_Usteda <> 0 then
        dbms_output.put_line('Ako firma otpusti radnike iz datog opseda, ustedice ' || V_usteda || 'din na plate i premije');
        COMMIT;
    else
        dbms_output.put_line('Ne postoje radnici u tom opsegu maticnih brojeva');
        ROLLBACK;
    end if;
END;