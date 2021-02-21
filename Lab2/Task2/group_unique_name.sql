create or replace TRIGGER UNIQUE_NAME 
BEFORE INSERT OR UPDATE 
ON GROUPS
FOR EACH ROW
DECLARE 
    unique_exception EXCEPTION;
    PRAGMA exception_init(unique_exception,-1);
    CURSOR groups_cur IS 
        SELECT * FROM GROUPS;
BEGIN
    <<chek_loop>>
    FOR group_row in groups_cur LOOP
    IF ( group_row.NAME = :NEW.NAME ) THEN
            RAISE unique_exception;
        END IF;
  END LOOP  chek_loop;
  
END;