create or replace procedure restore_table2 (restore_until IN TIMESTAMP) as 
begin
   FOR  audit_row in (SELECT id,operation,column1,id_row,table1_fk,change_time FROM TABLE2_AUDIT 
                                                    WHERE change_time > restore_until AND is_reverted = 0 ) LOOP
            CASE audit_row.operation
             WHEN 'UPDATE' THEN
                        INSERT INTO audit_scripts(operation,script) VALUES ('UPDATE','UPDATE TABLE2 
                                                                                SET COLUUMN1 = ' || audit_row.column1 || ', TABLE1_fk =' || audit_row.table1_fk ||
                                                                                ' WHERE ID = ' || audit_row.id_row);
            WHEN 'DELETE' THEN
                        INSERT INTO audit_scripts(operation,script) VALUES ('DELETE','INSERT INTO TABLE2(COLUMN1,TABLE1_FK) VALUES (' || audit_row.column1 || ',' ||  audit_row.table1_fk ||')');
                    restore_child('table2',audit_row.change_time);
            WHEN 'INSERT' THEN 
                        DBMS_OUTPUT.put_line('DELETE FROM TABLE2 WHERE ID=' || audit_row.id_row );
                        INSERT INTO  audit_scripts(operation,script) VALUES ('INSERT','DELETE FROM TABLE2 WHERE ID=' || audit_row.id_row  );
                   restore_child('table2',audit_row.change_time);
            END CASE;
            
  END LOOP;
  
  UPDATE TABLE2_AUDIT 
  SET is_reverted = 1
  WHERE change_time > restore_until;
end restore_table2;