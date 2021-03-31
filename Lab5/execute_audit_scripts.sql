create or replace procedure execute_audit_scripts(table_names in string_array) as 
begin
    FOR i in 1..table_names.count LOOP
        EXECUTE IMMEDIATE 'ALTER TRIGGER ' || table_names(i) || '_AUDIT_TRIGGER' || ' DISABLE';
    END LOOP;
  FOR audit_script_row IN (SELECT script FROM audit_scripts ORDER BY ID DESC) LOOP
    DBMS_OUTPUT.put_line('EXECUTING:' ||  audit_script_row.script);
    EXECUTE IMMEDIATE audit_script_row.script;
  END LOOP;
  DELETE FROM audit_scripts;
   FOR i in 1..table_names.count LOOP
        EXECUTE IMMEDIATE 'ALTER TRIGGER ' || table_names(i)|| '_AUDIT_TRIGGER' || ' ENABLE';
    END LOOP;
    DELETE FROM AUDIT_SCRIPTS;
end execute_audit_scripts;