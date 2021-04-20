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





