create or replace function get_dependent_tables 
(
  in_table_name in varchar2 
) return string_array as 
    dependent_tables string_array:=string_array();
    indx NUMBER;
begin
   FOR relation IN (SELECT p.table_name,ch.table_name child
        FROM user_cons_columns p 
        JOIN user_constraints ch ON p.constraint_name = ch.r_constraint_name
        WHERE p.table_name= in_table_name) LOOP
    dependent_tables.extend;
    indx := indx +1;
    dependent_tables(indx):=relation.child;
    END LOOP;
    return dependent_tables;
end get_dependent_tables;