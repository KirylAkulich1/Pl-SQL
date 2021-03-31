create or replace trigger table2_audit_trigger 
before delete or insert or update on table2
FOR EACH ROW
begin
  CASE 
    WHEN INSERTING THEN
            INSERT INTO table2_audit(operation,change_time,is_reverted,column1,table1_fk,id_row)
                    VALUES ('INSERT',CURRENT_TIMESTAMP,0,:NEW.column1,:NEW.table1_fk,:NEW.id);
    WHEN DELETING THEN
            INSERT INTO table2_audit(operation,change_time,is_reverted,column1,table1_fk,id_row)
                    VALUES ('DELETE',CURRENT_TIMESTAMP,0,:OLD.column1,:OLD.table1_fk,:OLD.id);
    WHEN UPDATING THEN
            INSERT INTO table2_audit(operation,change_time,is_reverted,column1,table1_fk, id_row)
                    VALUES ('UPDATE',CURRENT_TIMESTAMP,0,:OLD.column1,:OLD.table1_fk,:OLD.id);
    END CASE;
end;