create or replace procedure restore_table1(restore_until TIMESTAMP) as 
begin
  FOR  audit_row in (SELECT id,operation,column1,id_row,change_time FROM TABLE1_AUDIT 
                                                    WHERE change_time > restore_until
                                                    AND is_reverted = 0  ) LOOP
            CASE audit_row.operation
             WHEN 'UPDATE' THEN
                         DBMS_OUTPUT.put_line('UPDATE TABLE1 
                                                                                SET COLUUMN1 = ' || audit_row.column1 || 
                                                                                ' WHERE ID = ' || audit_row.id_row);
                        INSERT INTO audit_scripts(operation,script) VALUES ('UPDATE','UPDATE TABLE1 
                                                                                SET COLUUMN1 = ' || audit_row.column1 || 
                                                                                ' WHERE ID = ' || audit_row.id_row);
            WHEN 'DELETE' THEN
                         DBMS_OUTPUT.put_line('INSERT INTO TABLE1(COLUMN1) VALUES (' || audit_row.column1 || ')');
                        INSERT INTO audit_scripts(operation,script) VALUES 
                        ('DELETE','INSERT INTO TABLE1(COLUMN1) VALUES (' || audit_row.column1 || ')');
                    restore_child('table1',audit_row.change_time);
            WHEN 'INSERT' THEN 
                        DBMS_OUTPUT.put_line('DELETE FROM TABLE1 WHERE ID=' || audit_row.id_row );
                        INSERT INTO  audit_scripts(operation,script) VALUES
                         ('INSERT','DELETE FROM TABLE1 WHERE ID=' || audit_row.id_row  );
                    restore_child('table1',audit_row.change_time);
            END CASE;
            
  END LOOP;
  
  UPDATE TABLE1_AUDIT 
  SET is_reverted = 1
  WHERE change_time > restore_until;
end restore_table1;

