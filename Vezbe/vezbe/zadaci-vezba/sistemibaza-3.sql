/*
Napisati funkciju koja ?e, u okviru jedne transakcije, putem kursora,
preuzimati, redom, sve torke iz tabele Radnik, ure?ene u
opadaju?em redosledu mati?nog broja, i prebacivati ih u PL/SQL
tabelarnu kolekciju. Uz svaku preuzetu torku iz tabele Radnik, treba
u okviru elementa te kolekcije, inicijalizovati novu kolekciju koja ?e
sadržati skup svih naziva projekata na kojima ti radnici rade.

Tako?e, treba za svakog radnika prikazati i nazive projekata kojima
rukovodi. Nazive projekata na kojima radnik radi i kojima rukovodi,
treba selektovati putem posebnih kursora.

*/
CREATE OR REPLACE PACKAGE Kolokvijum_API 
    IS
        TYPE T_Radnici IS TABLE OF Radnik%ROWTYPE 
               INDEX BY BINARY_INTEGER;
               
        PROCEDURE PreuzmiRadnike;
        PROCEDURE IspisiTabeluRadnika;
        FUNCTION GetTabelaRadnika return T_Radnici;
        
    END Kolokvijum_API;
    
CREATE OR REPLACE PACKAGE BODY Kolokvijum_API 
    IS
        Tabela_Radnika T_Radnici;
        
        CURSOR C_Radnici IS
        SELECT *
        FROM Radnik
        order by mbr desc;
           
        PROCEDURE PreuzmiRadnike 
        IS
            v_index_radnika BINARY_INTEGER :=0;
            
        BEGIN
            FOR Temp_Radnik IN C_Radnici LOOP
                Tabela_Radnika(v_index_radnika):=Temp_Radnik;
                v_index_radnika:=v_index_radnika+1;
            END LOOP;
        END PreuzmiRadnike;
        
        PROCEDURE IspisiTabeluRadnika
        IS
            v_brojac BINARY_INTEGER :=0;
        BEGIN
            v_brojac:=Tabela_Radnika.FIRST;
            WHILE v_brojac<=Tabela_Radnika.LAST LOOP
                dbms_output.put_line(Tabela_Radnika(v_brojac).ime || ' '|| Tabela_Radnika(v_brojac).prz);
                v_brojac:=Tabela_Radnika.NEXT(v_brojac);
            END LOOP;
        END IspisiTabeluRadnika;
        
        FUNCTION GetTabelaRadnika return T_Radnici
        IS
        BEGIN
            return Tabela_Radnika;
        END;
        
        
    END Kolokvijum_API;
    
    
DECLARE
    Moja_Tabela Kolokvijum_API.T_Radnici;
BEGIN
    
    Kolokvijum_API.PreuzmiRadnike;
    Kolokvijum_API.IspisiTabeluRadnika;
    moja_tabela := Kolokvijum_API.GetTabelaRadnika;
    dbms_output.put_line(moja_tabela(0).Mbr);
END;