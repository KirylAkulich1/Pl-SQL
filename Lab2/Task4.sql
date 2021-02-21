create or replace TRIGGER AUDIT_STUDENT 
BEFORE DELETE OR INSERT OR UPDATE ON STUDENTS 
FOR EACH ROW
BEGIN 
  IF INSERTING THEN
    INSERT INTO STUDENTS_AUDIT(new_id,new_name,new_group_id,operation,event_date) VALUES 
    (:NEW.id,:NEW.name,:NEW.group_id,'INSERTING',CURRENT_DATE);
  ELSIF UPDATING THEN
  
    INSERT INTO STUDENTS_AUDIT(new_id,new_name,new_group_id,old_id,old_name,old_group_id,operation,event_date)
    VALUES (:NEW.id,:NEW.name,:NEW.group_id,:OLD.id,:OLD.name,:OLD.group_id,'UPDATING',CURRENT_DATE);
  ELSIF DELETING THEN
  
    INSERT INTO STUDENTS_AUDIT(old_id,old_name,old_group_id,operation,event_date)
    VALUES (:OLD.id,:OLD.name,:OLD.group_id,'DELETING',CURRENT_DATE);
  END IF;
END;