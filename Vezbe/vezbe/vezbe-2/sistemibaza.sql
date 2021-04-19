-- Jednostavan ispist vrednosti promenljive
DECLARE
    v_a BOOLEAN := TRUE;
    v_b NUMBER NOT NULL := '0'; -- implicitna konverzija
BEGIN
    v_a := 5 > 3;
    v_b := v_b + 1;
    dbms_output.put_line('Vrednost v_b je: ' || to_char(v_b)); -- eksplicitna konverzija
END;

/*
U konzolu ispisati trenutni datum, datum ro?enja, dan u 
sedmici kada ste ro?eni kao i broj dana koje ste proživeli 
do sada. Datum ro?enja uneti kroz interaktivni prompt.
*/
undefine V_datum_rodjenja;
DECLARE
    V_datum_rodjenja varchar2(40) := 'prazno';
BEGIN
    dbms_output.put_line('Trenutni datum: ' || to_char(sysdate)); -- moze i bez to_char, implicitna konverzija (ovo je eksplicitna sto smo mi napisali)
    dbms_output.put_line('Uneti datum rodjenja u formatu DD.MM.YYYY: ' || to_date('&&V_datum_rodjenja','DD.MM.YYYY'));
    dbms_output.put_line('Datum je: ' || '&&V_datum_rodjenja');
    
    DBMS_OUTPUT.PUT_LINE('Bio je: ' || TO_CHAR(TO_DATE('&&V_datum_rodjenja', 'DD.MM.YYYY'), 'DAY'));
    DBMS_OUTPUT.PUT_LINE('Sada sam stariji ' || TO_CHAR(ROUND(SYSDATE - TO_DATE('&&V_datum_rodjenja', 'DD.MM.YYYY'),0)) || ' dana');
END;

/*
Prebrojati projekte. Rezultat smestiti u definisanu 
varijablu i prikazati ga u konzoli.
*/
DECLARE
 V_br_projekata NUMBER := 0;
BEGIN
    select count(*)
    into V_br_projekata
    from projekat;

    dbms_output.put_line('Broj projekata je: ' || to_char(V_br_projekata));
END;

/*
Sa tastature uneti broj projekta. Za uneseni broj preuzeti 
njegove podatke u posebne promenjive i prikazati ih u 
konzoli.
*/
undefine V_broj_projekta;
DECLARE
    V_broj_projekta VARCHAR2(10) := '10';
    
    V_Spr projekat.spr%TYPE := 10; -- ne moze biti null/prazno
    V_Ruk projekat.ruk%TYPE;
    V_Nap projekat.nap%TYPE;
    V_Nar projekat.nar%TYPE;
BEGIN
    dbms_output.put_line('Sifra projekta: ' || '&&V_broj_projekta');
    if to_number('&&V_broj_projekta') = 0 then
        raise NO_DATA_FOUND;
    end if;
        
    SELECT Spr, Ruk, Nap, Nar
    INTO V_Spr, V_Ruk, V_Nap, V_Nar
    FROM Projekat
    WHERE Spr = to_number('&&V_broj_projekta');
    
    dbms_output.put_line('***************************');
    dbms_output.put_line('Sifra projekta: ' || to_char(V_Spr));
    dbms_output.put_line('Sifra rukovodioca projekta: ' || to_char(V_Ruk));
    dbms_output.put_line('Naziv projekta: ' || to_char(V_Nap));
    dbms_output.put_line('Narucila projekta: ' || to_char(V_Nar));
    dbms_output.put_line('***************************');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        Raise_application_error(-20000, 'Za sifru ' || '&&V_broj_projekta' || ' ne postoji projekat u nasoj bazi podataka');

END;
















