create or replace procedure schema_minus_schema 
(
  schema1 in varchar2 
, schema2 in varchar2 
) as 
begin
    FOR not_in_schema IN (SELECT tables1.table_name  name FROM 
                                dba_tables tables1 WHERE OWNER = 'DEV'
                                MINUS
                                SELECT  tables2.table_name FROM dba_tables tables2 WHERE OWNER='PROD') LOOP
                dbms_output.put_line(not_in_schema.name);
    END LOOP;
end schema_minus_schema;