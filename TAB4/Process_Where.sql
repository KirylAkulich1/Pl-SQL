create or replace function process_where 
(
  xml_string in varchar2 
) return varchar2 as 
 where_filter xml_record := xml_record();
 where_clouse VARCHAR2(1000) := ' WHERE ';
 condition_body VARCHAR2(100);
 sub_query VARCHAR(1000);
 condition_operator VARCHAR(100);
begin
    where_filter := extract_with_subnodes(xml_string, 'Operation/Where/Conditions/Condition');
    
    for i in 1 .. where_filter.count LOOP
        SELECT EXTRACTVALUE(XMLTYPE(where_filter(i)), 'Condition/Body') INTO condition_body  FROM dual;
        SELECT extract(XMLTYPE(where_filter(i)), 'Condition/Operator').getStringVal() INTO sub_query  FROM dual;
         SELECT EXTRACTVALUE(XMLTYPE(where_filter(i)), 'Condition/ConditionOperator') INTO condition_operator  FROM dual;
         where_clouse := where_clouse || ' ' || TRIM(condition_body) || ' ' || process_operator(sub_query) || TRIM(condition_operator) || ' '; 
    END LOOP;
    
    IF where_filter.count =0 THEN
        return ' ';
    ELSE
        return where_clouse;
    END IF;
  return null;
end process_where;