DECLARE
    Anin_EXC EXCEPTION;
    v_test radnik%rowtype;
BEGIN
    INSERT
    INTO RADNIK(mbr, ime, prz, sef, plt, pre, god)
    VALUES (SEQUENCE1.NEXTVAL, 'Vlado', 'Doncic', 20, 10000, 100, '10-JAN-98');

    if &uneti_broj > 5 then
        dbms_output.put_line('uspesno');
        INSERT
        INTO RADNIK(mbr, ime, prz, sef, plt, pre, god)
        VALUES (SEQUENCE1.NEXTVAL, 'Jovo', 'Jovic', 20, 10000, 100, '10-JAN-98');
        commit;
    else
        Raise Anin_EXC;
    end if;
    
    SELECT *
    INTO v_test
    From radnik
    where mbr > 10;
    
EXCEPTION
    WHEN Anin_EXC THEN
        dbms_output.put_line('hey from exception handler');
        rollback;
    WHEN OTHERS then
        dbms_output.put_line('hey from exception handler for any ecx');
END;