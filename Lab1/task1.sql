DECLARE 
    rows_count  CONSTANT NUMBER :=10000; 
    random_int pls_integer;
BEGIN
    FOR i in 1 .. rows_count
    LOOP
        SELECT dbms_random.random INTO random_int FROM dual;
        INSERT INTO MYTABLE (id,val) VALUES (i,random_int);
    END LOOP;
    dbms_output.put_line(random_int);
END;