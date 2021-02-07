CREATE OR REPLACE FUNCTION convert_id_to_query(row_id IN NUMBER) RETURN VARCHAR
IS
    insert_query VARCHAR(100);
    val_in_row NUMBER; 
    random_int pls_integer;
BEGIN 
    SELECT val INTO val_in_row FROM MyTable WHERE id=row_id;
    insert_query := 'INSERT INTO MYTABLE(id,val) VALUES ( ' || row_id || ','  || val_in_row || ');';
    RETURN insert_query;
     EXCEPTION
     WHEN no_data_found THEN 
        DBMS_OUTPUT.put_line('ID NOT FOUND.');
        SELECT dbms_random.random INTO random_int FROM dual;
        RETURN 'INSERT INTO MYTABLE(id,val) VALUES ( ' || row_id || ','  || random_int || ');';
   WHEN others THEN 
      dbms_output.put_line('Error!'); 
END;


