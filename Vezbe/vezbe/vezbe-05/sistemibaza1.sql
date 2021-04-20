/*
Napisati lokalnu proceduru koja ?e, u okviru 
jedne transakcije, putem kursora, preuzimati, 
redom, sve torke iz tabele Radnik i prebacivati 
ih, jednu po jednu, u PL/SQL tabelarnu kolekciju. 

Takva tabelarna kolekcija treba da predstavlja 
izlazni parametar procedure. 

• Proveriti ispravnost rada procedure pozivima na 
konkretnim primerima
*/  
DECLARE
    
    TYPE T_Radnici IS TABLE of Radnik%rowtype
        INDEX BY BINARY_INTEGER;
        
    T_KolekcijaRadnika T_Radnici;
    j BINARY_INTEGER;
    
    CURSOR radnici IS
    SELECT *
    FROM Radnik;
    
    PROCEDURE prebaci(P_KolekcijaRadnika OUT T_Radnici) IS
        i BINARY_INTEGER;
    BEGIN        
        i := 0;
        FOR T_radnik in radnici LOOP
            P_KolekcijaRadnika(i) := T_radnik;
            i := i + 1;
        END LOOP;
    
    END;

BEGIN
    prebaci(T_KolekcijaRadnika);
    
    j := T_KolekcijaRadnika.FIRST;
    WHILE j <= T_KolekcijaRadnika.LAST LOOP
        dbms_output.put_line(T_KolekcijaRadnika(j).Mbr);
        j := T_KolekcijaRadnika.NEXT(j);
    END LOOP;
END;

/* TIP KOLOKVIJUMSKOG ZADATKA
Napisati funkciju koja ?e, u okviru jedne transakcije, putem kursora,
preuzimati, redom, sve torke iz tabele Radnik, ure?ene u
opadaju?em redosledu mati?nog broja, i prebacivati ih u PL/SQL
tabelarnu kolekciju.

Uz svaku preuzetu torku iz tabele Radnik, treba
u okviru elementa te kolekcije, inicijalizovati novu kolekciju koja ?e
sadržati skup svih naziva projekata na kojima ti radnici rade.
Tako?e, treba za svakog radnika prikazati i nazive projekata kojima
rukovodi.

Nazive projekata na kojima radnik radi i kojima rukovodi,
treba selektovati putem posebnih kursora.

• Tabelarna kolekcija selektovanih radnika treba da predstavlja izlazni
podatak funkcije.

• Proveriti ispravnost rada funkcije pozivima na konkretnim primerima
*/



DECLARE
    TYPE T_Projekti IS TABLE OF Projekat.Nap%type
        INDEX BY BINARY_INTEGER;

    TYPE R_RadNap is RECORD(
        R_Radnik Radnik%rowtype,
        R_Projekti T_Projekti,
        R_Rukovodi T_Projekti
    );
    
    TYPE T_Radnici IS TABLE OF R_RadNap
        INDEX BY BINARY_INTEGER;
        
    V_TabRadnika T_Radnici;
    j BINARY_INTEGER;
    o BINARY_INTEGER;
    n BINARY_INTEGER;
    
    CURSOR radnici IS
    SELECT *
    FROM Radnik
    ORDER BY Mbr DESC;
    
    CURSOR projekti(P_Mbr in Radnik.Mbr%type) IS
    SELECT p.Nap
    FROM Radproj rp, Projekat p
    WHERE rp.mbr = P_Mbr and rp.spr = p.spr;
    
    CURSOR rukovodi(P_Mbr in Radnik.Mbr%type) IS
    SELECT Nap
    FROM PROJEKAT
    WHERE Ruk = P_Mbr;
    
    
    PROCEDURE prebaci(P_TabRadnika OUT T_Radnici) IS
        i BINARY_INTEGER;
        k BINARY_INTEGER;
        m BINARY_INTEGER;
    BEGIN
        i := 0;
        FOR T_Radnik in radnici LOOP
            P_TabRadnika(i).R_Radnik := T_Radnik;
            k := 0;
            FOR T_Projekat in projekti(P_TabRadnika(i).R_Radnik.Mbr) LOOP
                P_TabRadnika(i).R_Projekti(k) := T_Projekat.Nap;
                k := k + 1;
            END LOOP;
            
            m := 0;
            FOR T_Projekat in rukovodi(P_TabRadnika(i).R_Radnik.Mbr) LOOP
                P_TabRadnika(i).R_Rukovodi(m) := T_Projekat.Nap;
                m := m + 1;
            END LOOP;
            
            i := i + 1;
        END LOOP;
        
    END;
BEGIN
    prebaci(V_TabRadnika);
    
    j := V_TabRadnika.FIRST;
    WHILE j <= V_TabRadnika.LAST LOOP
        dbms_output.put_line(' '); -- novi red samo u ispisu
        dbms_output.put_line('Radnik sa mbr-om ' || V_TabRadnika(j).R_Radnik.Mbr || ' radi na sledecim projektima');
        o := V_TabRadnika(j).R_Projekti.FIRST;
        WHILE o <= V_TabRadnika(j).R_Projekti.LAST LOOP
            dbms_output.put_line(V_TabRadnika(j).R_Projekti(o));
            o := V_TabRadnika(j).R_Projekti.NEXT(o);
        END LOOP;
        dbms_output.put_line('Radnik sa mbr-om ' || V_TabRadnika(j).R_Radnik.Mbr || ' rukovodi na sledecim projektima');
        n := V_TabRadnika(j).R_Rukovodi.FIRST;
        WHILE n <= V_TabRadnika(j).R_Rukovodi.LAST LOOP
            dbms_output.put_line(V_TabRadnika(j).R_Rukovodi(n));
            n := V_TabRadnika(j).R_Rukovodi.NEXT(n);
        END LOOP;
        dbms_output.put_line(' '); -- novi red samo u ispisu
        
        j := V_TabRadnika.NEXT(j);
    END LOOP;
END;