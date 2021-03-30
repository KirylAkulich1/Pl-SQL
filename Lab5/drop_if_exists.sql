create or replace procedure drop_if_exists 
(
  input_object_name in varchar2 ,
  input_object_type in varchar2
) as 
    exist_object VARCHAR2(20);
begin
    select object_name INTO  exist_object from user_objects where object_name= UPPER(input_object_name) and object_type=UPPER(input_object_type);
     --DBMS_OUTPUT.put_line('VALUE:' || exist_object);
    IF  sql%ROWCOUNT <> 0 THEN
         DBMS_OUTPUT.put_line('QUERY:' || 'DROP ' || input_object_type || ' '  || exist_object);
        EXECUTE IMMEDIATE 'DROP ' || input_object_type || ' '  || exist_object;
    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.put_line('Object doesnt exists');
        
end drop_if_exists;