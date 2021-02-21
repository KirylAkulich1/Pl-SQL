create or replace TRIGGER UNIQUE_GROUP_ID 
BEFORE INSERT OR UPDATE OF ID ON GROUPS 
FOR EACH ROW
DECLARE
    unique_exception EXCEPTION;
    PRAGMA exception_init(unique_exception,-1);
    CURSOR groups_id IS 
    SELECT id FROM groups;
BEGIN
    <<chek_loop>>
    FOR group_id IN groups_id
    LOOP
        IF ( group_id.id = :NEW.id ) THEN
            RAISE unique_exception;
        END IF;
    END LOOP check_loop;
  
END;