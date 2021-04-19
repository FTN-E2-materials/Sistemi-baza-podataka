-- Jednostavan ispist vrednosti promenljive
DECLARE
    v_a BOOLEAN := TRUE;
    v_b NUMBER NOT NULL := 0;
BEGIN
    v_a := 5 > 3;
    v_b := v_b + 1;
    dbms_output.put_line('Vrednost v_b je: ' || v_b);
END;

