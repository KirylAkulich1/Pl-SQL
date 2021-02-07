 CREATE OR REPLACE PROCEDURE update_row(row_id IN NUMBER,update_val IN NUMBER) IS
    BEGIN
            UPDATE MyTable SET val=update_val WHERE id=row_id;
            EXCEPTION
            WHEN others THEN
                dbms_output.put_line('Update operation was cancalled.Error occured'); 
    END  update_row;