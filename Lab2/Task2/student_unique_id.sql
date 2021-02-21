create or replace TRIGGER UNIQUE_ID 
BEFORE INSERT OR UPDATE 
ON STUDENTS
FOR EACH ROW
DECLARE
    unique_exception EXCEPTION;
    PRAGMA exception_init(unique_exception,-1);
    CURSOR students_id IS 
    SELECT id FROM STUDENTS;
BEGIN
    <<chek_loop>>
    FOR student_id IN students_id
    LOOP
        IF ( student_id.id = :NEW.id ) THEN
            RAISE unique_exception;
        END IF;
    END LOOP check_loop;
  
END;