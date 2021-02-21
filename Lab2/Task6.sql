CREATE OR REPLACE TRIGGER C_VAL_UPDATE 
BEFORE DELETE OR INSERT OR UPDATE OF GROUP_ID ON STUDENTS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE groups SET c_val=c_val+1 
            WHERE id=:NEW.group_id;
    ELSIF UPDATING THEN
        UPDATE groups SET c_val=c_val-1
            WHERE id=:OLD.group_id;
        UPDATE groups SET c_val=c_val+1
            WHERE id=:NEW.group_id;
    ELSIF DELETING THEN 
        UPDATE groups SET c_val=c_val-1
            WHERE id=:OLD.group_id;
    END IF;
END;