/*
    U konzolu ispisati radnika(mbr, ime, prezime i platu)
    ciji je maticni broj jednak maticnom broju unetom preko promta
*/

undefine radnik_mbr;

DECLARE
    radnik_rec radnik%rowtype; 
BEGIN
    dbms_output.put_line('radnik mbr: ' || '&&radnik_mbr');

    SELECT * into radnik_rec 
    FROM radnik 
    WHERE mbr = &&radnik_mbr;  
    
    dbms_output.put_line('mbr: ' || radnik_rec.mbr || ' ime: ' || radnik_rec.ime || ' prezime: ' || radnik_rec.prz || ' plata: ' || radnik_rec.plt);
END;

