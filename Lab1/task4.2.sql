  CREATE OR REPLACE   PROCEDURE delete_row(row_id IN NUMBER) IS
    BEGIN
        DELETE FROM MyTable WHERE row_id=id;
        EXCEPTION
          WHEN others THEN
                dbms_output.put_line('DELETE operation was cancalled.Error occured'); 
    END delete_row;