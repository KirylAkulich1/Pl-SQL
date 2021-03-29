create or replace package body xml_process_pkg as

  function process_operator (xml_string in varchar2 ) return varchar2 as
    i NUMBER := 1;
    tables_list xml_record := xml_record();
    in_columns xml_record := xml_record();
    concat_operations xml_record := xml_record();
    concat_operation_filter xml_record := xml_record();
    filters xml_record := xml_record();
    concat_operands xml_record := xml_record();
    join_operations xml_record := xml_record();
    
    join_condition VARCHAR2(100);
    join_type VARCHAR2(100);
    
    xml_record_iterator  VARCHAR2(50);
    select_query VARCHAR2(1000) :='SELECT ';
  begin
    -- Get table count;
    IF xml_string IS NULL THEN
        return NULL;
    END IF;
    tables_list := extract_values(xml_string,'Operation/Tables/Table');
    in_columns := extract_values(xml_string,'Operation/Columns/Column');

    
    
    select_query := select_query || ' ' || in_columns(1);
    
    FOR indx IN 2..in_columns.count LOOP
        select_query := select_query || ', ' ||  in_columns(indx);
    END LOOP;
    
    select_query := select_query || ' FROM '  || tables_list(1);
    
    FOR indx IN 2..tables_list.count LOOP
        
        
        --select_query := select_query || 'WHERE';
        --concat_operations := extract_values(xml_string,'Operation/Tables/Table[' || indx || ']' ||'/Filters/Filter');
        --concat_operands := extract_values(xml_string,'Operation/Tables/Table[' || indx || ']' ||'/Operators/Operator');
         SELECT EXTRACTVALUE(XMLTYPE(xml_string),'Operation/Joins/Join'  ||'[' || (indx - 1) || ']/Type') INTO join_type  FROM dual;
         SELECT EXTRACTVALUE(XMLTYPE(xml_string),'Operation/Joins/Join'  ||'[' || (indx - 1) || ']/Condition') INTO join_condition FROM dual;
        select_query := select_query || ' ' ||  join_type || tables_list(indx) || ' ON ' || join_condition;
        
    END LOOP;
    
    select_query := select_query || process_where(xml_string);
    
    
     dbms_output.put_line(select_query);
    return select_query;
  end process_operator;

  function process_where (xml_string in varchar2 ) return varchar2 as
   where_filter xml_record := xml_record();
   where_clouse VARCHAR2(1000) := ' WHERE ';
   condition_body VARCHAR2(100);
   sub_query VARCHAR(1000);
   sub_query1 VARCHAR(1000);
   condition_operator VARCHAR(100);
   i NUMBER := 1;
    filters xml_record := xml_record();
    concat_operands xml_record := xml_record();
    xml_record_iterator  VARCHAR2(50);
     select_query VARCHAR2(1000) :='SELECT ';
    begin
     where_filter := extract_with_subnodes(xml_string, 'Operation/Where/Conditions/Condition');
   -- DBMS_OUTPUT.put_line('CHECK:' || where_filter(1));
    for i in 1 .. where_filter.count LOOP
        --DBMS_OUTPUT.put_line('LOG:' || where_filter(i));
        SELECT EXTRACTVALUE(XMLTYPE(where_filter(i)), 'Condition/Body') INTO condition_body  FROM dual;
        SELECT extract(XMLTYPE(where_filter(i)), 'Condition/Operation').getStringVal() INTO sub_query  FROM dual;
        SELECT EXTRACTVALUE(XMLTYPE(where_filter(i)), 'Condition/ConditionOperator') INTO condition_operator  FROM dual;
        DBMS_OUTPUT.put_line('SUB:' || sub_query);
        sub_query1 := process_operator(sub_query);
        IF sub_query1 IS NOT NULL THEN
            sub_query1:= '('|| sub_query1 || ')';
        END IF;
        where_clouse := where_clouse || ' ' || TRIM(condition_body) || ' ' || sub_query1 || TRIM(condition_operator) || ' '; 
    END LOOP;
    
    IF where_filter.count =0 THEN
        return ' ';
    ELSE
        return where_clouse;
    END IF;
  return null;
  end process_where;
                
  function process_update(xml_string in varchar2) return varchar2 as
    set_collection xml_record := xml_record();
    where_clouse VARCHAR2(1000) := ' WHERE ';
    set_operations VARCHAR2(1000);
    sub_query VARCHAR(1000);
    condition_operator VARCHAR(100);
    update_query VARCHAR2(1000) := 'UPDATE';
    table_name VARCHAR(100);
  begin
    SELECT extract(XMLTYPE(xml_string), 'Operation/SetOperations').getStringVal() INTO  set_operations FROM dual;
   SELECT EXTRACTVALUE(XMLTYPE(xml_string), 'Operation/Table') INTO table_name  FROM dual;
   set_collection := extract_values(set_operations,'SetOperations/Set');
   
   update_query := update_query || table_name || 'SET' || set_collection(1);
   FOR i in 2..set_collection.count LOOP
        update_query := update_query || ',' || set_collection(i);
   END LOOP;
   
   update_query := update_query || process_where(xml_string);
   return update_query;
  end process_update;

 function process_insert 
(
  xml_string in varchar2 
) return varchar2 as 
    values_to_insert varchar2(1000);
    select_query_to_insert varchar(1000);
    xml_values xml_record := xml_record(); 
    insert_query VARCHAR2(1000);
    table_name VARCHAR(100);
    xml_columns VARCHAR2(200);
begin
   SELECT extract(XMLTYPE(xml_string), 'Operation/Values').getStringVal() INTO  values_to_insert  FROM dual;
   SELECT EXTRACTVALUE(XMLTYPE(xml_string), 'Operation/Table') INTO table_name  FROM dual;
    xml_columns:='(' || concat_string(extract_values(xml_string,'Operation/Columns/Column'),',') || ')';
   insert_query := 'INSERT INTO ' || table_name ||xml_columns;
   IF values_to_insert IS NOT NULL THEN
        xml_values:= extract_values(values_to_insert,'Values/Value');
        insert_query:=insert_query || 'VALUES' || '(' || xml_values(1) || ')' ;
        FOR i in 2 .. xml_values.count LOOP
            insert_query := insert_query || ',(' || xml_values(i) || ') ';
        END LOOP;
    ELSE
         SELECT extract(XMLTYPE(xml_string), 'Operation/Operation').getStringVal() INTO  select_query_to_insert  FROM dual;
         insert_query := insert_query || process_operator(select_query_to_insert);
   END IF;
  
  return insert_query;
end process_insert;

function process_delete 
(
  xml_string in varchar2 
) return varchar2 as 
where_clouse VARCHAR2(1000) := ' WHERE ';
 condition_operator VARCHAR(100);
  delete_query VARCHAR2(1000) := 'DELETE FROM';
 table_name VARCHAR(100);
begin
   SELECT EXTRACTVALUE(XMLTYPE(xml_string), 'Operation/Table') INTO table_name  FROM dual;
   delete_query := delete_query || process_where(xml_string);
   return delete_query;
end process_delete;


function process_drop(xml_string IN VARCHAR2) return varchar2 as 
    drop_query VARCHAR2(1000):='DROP TABLE ';
    table_name VARCHAR2(100);
begin
     SELECT EXTRACTVALUE(XMLTYPE(xml_string), 'Operation/Table') INTO table_name  FROM dual;
     drop_query := drop_query || table_name;
     return drop_query;
end process_drop;


 function process_create(xml_string IN VARCHAR2) return varchar2 as 
    table_columns xml_record := xml_record();
    table_name VARCHAR2(100);
    col_constraints xml_record := xml_record();
    table_constraints xml_record := xml_record();
    col_name VARCHAR2(100);
    col_type VARCHAR(100);
    parent_table VARCHAR2(100);
    create_query VARCHAR2(1000):= 'CREATE TABLE';
    primary_constraint VARCHAR2(1000);
    foreign_constraint VARCHAR2(1000);
    auto_increment_script VARCHAR(1000);
begin
    SELECT EXTRACTVALUE(XMLTYPE(xml_string), 'Operation/Table') INTO table_name  FROM dual;
    create_query := create_query || ' ' || table_name || '(';
    table_columns := extract_with_subnodes(xml_string,'Operation/Columns/Column');
    
    FOR i in 1..table_columns.count LOOP
        SELECT EXTRACTVALUE(XMLTYPE(table_columns(i)), 'Column/Name') INTO col_name  FROM dual;
        SELECT EXTRACTVALUE(XMLTYPE(table_columns(i)), 'Column/Type') INTO col_type  FROM dual;
        col_constraints := extract_values(table_columns(i),'Column/Constraints/Constraint');
        DBMS_OUTPUT.put_line(table_columns(i));
        create_query := create_query || ' ' || col_name || ' ' || col_type || concat_string(col_constraints,' ');
        
        IF i != table_columns.count THEN
            create_query := create_query || ' , ';
        END IF;
    END LOOP;
    
     SELECT extract(XMLTYPE(xml_string), 'Operation/TableConstraints/PrimaryKey').getStringVal() INTO  primary_constraint  FROM dual;
     
     IF primary_constraint IS NOT NULL THEN
        create_query := create_query || 'Constraint' || table_name || '_pk'|| 'PRIMARY KEY (' || concat_string(
                                                                                                                extract_values(primary_constraint,'PrimaryKey/Columns/Column'),',') || ')';
    ELSE
         auto_increment_script := Generate_auto_increment(table_name);
         create_query := create_query || ', ID NUMBER PRIMARY KEY';
    END IF;
   table_constraints := extract_with_subnodes(xml_string, 'Operation/TableConstraints/ForeignKey');
    
    FOR i in 1 .. table_constraints.count LOOP
    --insert comma
        SELECT EXTRACTVALUE(XMLTYPE(table_constraints(i)), 'ForeignKey/Parent') INTO parent_table  FROM dual;
        create_query:= create_query || ' , Constraint' || table_name || '_' || parent_table || '_fk ' ||
                                                    'Foreign Key' || '(' || concat_string(extract_values(table_constraints(i),'ForeignKey/ChildColumns/Column'),' , ') || ' ) ' ||
                                                    'REFERENCES' || parent_table || '(' || concat_string(extract_values(table_constraints(i),'ForeignKey/ChildColumns/Column'),' , ');
    END LOOP;
    create_query := create_query || ');' || auto_increment_script;
    DBMS_OUTPUT.put_line(create_query);
   return create_query;
end process_create;

function process_select(xml_string IN varchar2) return sys_refcursor
as
rf_cur   sys_refcursor;
BEGIN
    Open rf_cur for
        process_operator(xml_string);
    return rf_cur;
    
END process_select;
end xml_process_pkg;