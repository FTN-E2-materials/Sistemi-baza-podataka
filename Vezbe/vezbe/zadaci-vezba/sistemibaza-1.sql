
/*
Ispisati radnike koji ima mbr veci od prosledjenog,
pored toga sacuvati i sve nazive projekata na kojima taj radnik radi.
Ako je radnik sef, pored toga ispisati i sve radnika kojima je sef.
*/

select p.nap
from radproj rp, projekat p
where rp.mbr=30 and rp.spr = p.spr;

select ime
from radnik
where sef=70;

DECLARE
    TYPE T_Projekti IS TABLE OF Projekat.Nap%TYPE
        INDEX BY BINARY_INTEGER;
        
    TYPE T_RadniciKojimaJeNekoSef IS TABLE OF Radnik.IME%TYPE
        INDEX BY BINARY_INTEGER;

    TYPE S_Radnik IS RECORD(
        SV_Radnik Radnik%rowtype,
        SV_Nap T_Projekti,
        SV_Tabela_Radnika_KojimaJeSef T_RadniciKojimaJeNekoSef
    );

    TYPE T_Radnici IS TABLE OF S_Radnik
        INDEX BY BINARY_INTEGER;
        
    CURSOR Radnici(pr_mbr Radnik.mbr%TYPE) IS
        select *
        from radnik
        where mbr > pr_mbr;
        
    CURSOR Radnikovi_Projekti(pr_mbr Radnik.mbr%type) IS
        select Nap
        from radproj rp, projekat p
        where rp.mbr=pr_mbr and rp.spr = p.spr;
        
    CURSOR Radnici_KojimaJeNekoSef(pr_sef Radnik.mbr%type) IS
        select ime
        from radnik
        where sef=pr_sef;
        
    idx_Radnika BINARY_INTEGER := 0;
    Tabela_Radnika T_Radnici;
    Tabela_Projekata T_Projekti;
    v_brojac BINARY_INTEGER:=0;
    idx_Projekta BINARY_INTEGER :=0;
    idx_Radnika_sefovi BINARY_INTEGER :=0;
    v_brojacProjekata BINARY_INTEGER :=0;
    v_brojacRadnika BINARY_INTEGER :=0;
BEGIN
    -- Punjenje tabele radnika, preko cursora
    FOR TC_Radnik in Radnici(&nebitan_Mbr) LOOP
        Tabela_Radnika(idx_Radnika).SV_Radnik := TC_Radnik;
        
        idx_projekta:=0;
        FOR TC_RadnikovProjekat in Radnikovi_Projekti(TC_Radnik.mbr) LOOP
            Tabela_Radnika(idx_Radnika).SV_Nap(idx_projekta):=TC_RadnikovProjekat.nap;
            idx_projekta:=idx_projekta+1;
        END LOOP;
        
        idx_Radnika_sefovi :=0;
        FOR TC_Radnici_KojimaJeNekoSef in Radnici_KojimaJeNekoSef(TC_Radnik.mbr)LOOP
            Tabela_Radnika(idx_Radnika).SV_Tabela_Radnika_KojimaJeSef(idx_Radnika_sefovi):=TC_Radnici_KojimaJeNekoSef.ime;
            idx_Radnika_sefovi:=idx_Radnika_sefovi+1;
        END LOOP;
        idx_Radnika := idx_Radnika + 1;
    END LOOP;
    
    -- indeks prvog clana tabel Tabela_Radnika.FIRST;
    -- indeks poslednjeg clana tabele Tabela_Radnika.LAST
    -- prelazak na sledeci indeks Tabela_Radnika.NEXT(trenutni_indeks)
    v_brojac := Tabela_Radnika.FIRST;
    WHILE v_brojac <= Tabela_Radnika.LAST LOOP
        dbms_output.put_line(Tabela_Radnika(v_brojac).SV_Radnik.mbr);
        
        v_brojacProjekata :=Tabela_Radnika(v_brojac).SV_NAP.FIRST;
        WHILE v_brojacProjekata<=Tabela_Radnika(v_brojac).SV_NAP.LAST   LOOP
            dbms_output.put_line(Tabela_Radnika(v_brojac).SV_NAP(v_brojacProjekata));
            v_brojacProjekata:=Tabela_Radnika(v_brojac).SV_NAP.NEXT(v_brojacProjekata);
        END LOOP;
        
        v_brojacRadnika:=Tabela_Radnika(v_brojac). SV_Tabela_Radnika_KojimaJeSef.FIRST;
        WHILE v_brojacRadnika<=Tabela_Radnika(v_brojac).SV_Tabela_Radnika_KojimaJeSef.LAST LOOP
            dbms_output.put_line(Tabela_Radnika(v_brojac).SV_Tabela_Radnika_KojimaJeSef(v_brojacRadnika));
            v_brojacRadnika:=Tabela_Radnika(v_brojac).SV_Tabela_Radnika_KojimaJeSef.NEXT(v_brojacRadnika);
        END LOOP;
        dbms_output.put_line(' ');
        v_brojac := Tabela_Radnika.NEXT(v_brojac);
    END LOOP;
END;