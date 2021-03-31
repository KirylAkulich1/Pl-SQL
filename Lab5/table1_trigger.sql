create or replace trigger table1_audit_trigger 
before delete or insert or update on table1
FOR EACH ROW
begin
  CASE 
    WHEN INSERTING THEN
            INSERT INTO table1_audit(operation,change_time,is_reverted,column1,id_row)
                    VALUES ('INSERT',CURRENT_TIMESTAMP,0,:NEW.column1,:NEW.id);
    WHEN DELETING THEN
            INSERT INTO table1_audit(operation,change_time,is_reverted,column1,id_row)
                    VALUES ('DELETE',CURRENT_TIMESTAMP,0,:OLD.column1,:OLD.id);
    WHEN UPDATING THEN
            INSERT INTO table1_audit(operation,change_time,is_reverted,column1,id_row)
                    VALUES ('UPDATE',CURRENT_TIMESTAMP,0,:OLD.column1,:OLD.id);
    END CASE;
end;