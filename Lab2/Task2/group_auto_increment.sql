CREATE OR REPLACE TRIGGER GROUP_AUTO_INCREMENT 
BEFORE INSERT ON GROUPS 
FOR EACH ROW
DECLARE 
    max_id NUMBER(2) := 0;
BEGIN
  SELECT MAX(id) INTO max_id FROM groups;
  IF(max_id is null) THEN
        max_id :=0;
   END IF;
  :NEW.id :=max_id+1;
END;