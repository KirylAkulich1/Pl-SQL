 CREATE OR REPLACE PROCEDURE insert_raw(insert_val IN NUMBER) IS
    rows_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO rows_count FROM MyTable;
        INSERT INTO MyTable(id,val) VALUES (rows_count+1,insert_val); 
          EXCEPTION
          WHEN others THEN
                dbms_output.put_line('UPDATE operation was cancalled.Error occured');
    END insert_raw;
    