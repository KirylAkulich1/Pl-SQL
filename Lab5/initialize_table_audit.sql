create or replace procedure initialize_table_audit(table_names IN string_array) as 
    create_query VARCHAR2(1000);
    audit_table VARCHAR2(20);
    data_type VARCHAR2(100);
begin
  DBMS_OUTPUT.put_line('fsdfdsfsdfds');
  FOR i in 1.. table_names.count LOOP
    
    drop_if_exists( table_names(i) || '_AUDIT','TABLE');
    create_query :='CREATE  TABLE ' || table_names(i) 
        || '_AUDIT ( ID NUMBER PRIMARY KEY , CHANGE_TIME TIMESTAMP ,IS_REVERTED NUMBER ,OPERATION VARCHAR(20) , ID_ROW NUMBER , ';
        FOR table_column in (SELECT column_name, data_type, data_length
                        FROM USER_TAB_COLUMNS
                        WHERE table_name = table_names(i) AND column_name != 'ID') LOOP
                        
                        IF INSTR(table_column.data_type,'CHAR')<> 0 THEN
                            data_type := table_column.data_type || '(' || table_column.data_length || ') ';
                        ELSE
                             data_type := table_column.data_type ;
                        END IF;
                        create_query := create_query || table_column.column_name || ' '  || data_type || ',';
        END LOOP;
        create_query:=SUBSTR(create_query, 0, length(create_query)-1) || ')' ;
        DBMS_OUTPUT.put_line(create_query);
        EXECUTE IMMEDIATE  create_query;
        EXECUTE IMMEDIATE generate_auto_increment( table_names(i) || '_AUDIT');
  END LOOP;
end initialize_table_audit;