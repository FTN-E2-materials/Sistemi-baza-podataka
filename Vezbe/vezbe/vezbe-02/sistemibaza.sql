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






