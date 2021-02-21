CREATE OR REPLACE PROCEDURE restore_proc(start_ts IN TIMESTAMP,shift_in_hours IN NUMBER,shift_in_min IN NUMBER,shift_in_seconds IN NUMBER) IS
    end_ts TIMESTAMP;
BEGIN
    end_ts := start_ts +shift_in_hours/24+ shift_in_min/1440+ shift_in_seconds/24/60/6;
    FOR recover_row IN (SELECT * FROM STUDENTS_AUDIT 
    WHERE event_date < end_ts and event_date > start_ts
    ORDER BY event_date DESC) LOOP
    CASE recover_row.operation
    WHEN 'UPDATING' THEN 
    
    UPDATE STUDENTS SET
        id = recover_row.old_id,
        name = recover_row.old_name,
        group_id = recover_row.old_group_id
    WHERE id=recover_row.new_id;
    
    WHEN 'INSERTING' THEN
   
    DELETE FROM STUDENTS WHERE id = recover_row.new_id;
    
    WHEN 'DELETING' THEN
    INSERT INTO STUDENTS(id,name,group_id) VALUES(recover_row.old_id,recover_row.old_name,recover_row.old_group_id);
   
    END case;
    END LOOP;
    
END;