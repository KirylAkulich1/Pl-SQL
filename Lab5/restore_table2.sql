create or replace procedure restore_table3(restore_until IN TIMESTAMP) as 
begin
  FOR  audit_row in (SELECT id,operation,column1,id_row,table2_fk,change_time FROM TABLE3_AUDIT 
                                                    WHERE change_time < restore_until AND is_reverted = 0 ) LOOP
            CASE audit_row.operation
             WHEN 'UPDATE' THEN
                        INSERT INTO audit_scripts(operation,script) VALUES ('UPDATE','UPDATE TABLE1 
                                                                                SET COLUUMN1 = ' || audit_row.column1 || ',' || ' TABLE2_FK=' || audit_row.table2_fk ||
                                                                                'WHERE ID = ' || audit_row.id_row);
            WHEN 'DELETE' THEN
                        INSERT INTO audit_scripts(operation,script) VALUES ('DELETE','INSERT INTO TABLE1(COLUMN1,TABLE2_FK) VALUES (' || audit_row.column1 || audit_row.table2_fk || ')');
                    restore_child('table3',audit_row.change_time);
            WHEN 'INSERT' THEN 
                        INSERT INTO  audit_scripts(operation,script) VALUES ('INSERT','DELETE FROM TABLE1 WHERE ID=' || audit_row.id_row  );
                         restore_child('table3',audit_row.change_time);
            END CASE;
            
  END LOOP;
  
  UPDATE TABLE1_AUDIT 
  SET is_reverted = 1
  WHERE change_time > restore_until;
end restore_table3;