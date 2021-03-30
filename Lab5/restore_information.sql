create or replace procedure restore_information 
(
  input_tables in string_array ,
  input_ts in TIMESTAMP
) as 
begin
  FOR i in 1..input_tables.count LOOP
       EXECUTE IMMEDIATE '
        BEGIN 
              RESTORE_' || input_tables(i)|| '( TO_TIMESTAMP(''' || TO_CHAR(input_ts,'DD-MM-YYYY HH:MI:SS') || ''', ''DD-MM-YYYYHH:MI:SS''));       
        END;';
  END LOOP;
end restore_information;