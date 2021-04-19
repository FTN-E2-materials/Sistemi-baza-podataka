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
declare
 V_br_projekata NUMBER := 0;
begin
    select count(*)
    into V_br_projekata
    from projekat;

    dbms_output.put_line('Broj projekata je: ' || to_char(V_br_projekata));
end;
