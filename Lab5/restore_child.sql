create or replace procedure restore_child 
(
  table_name in varchar2 ,
  restore_until TIMESTAMP
) as 
    child_array string_array;
begin
    child_array := get_dependent_tables(table_name);
    restore_information(child_array,restore_until);
end restore_child;