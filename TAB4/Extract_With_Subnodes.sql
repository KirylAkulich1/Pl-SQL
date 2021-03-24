create or replace function extract_with_subnodes 
(
  xml_string in varchar2 
, path_string in varchar2 
) return xml_record as 
current_node_value VARCHAR2(1000);
 xml_collection xml_record := xml_record();
 i NUMBER := 1;
  collection_length NUMBER :=0;
begin
    
     SELECT extract(XMLTYPE(xml_string), path_string).getStringVal() INTO current_node_value  FROM dual;
   WHILE current_node_value IS NOT NULL LOOP
        i := i+1;
        dbms_output.put_line(path_string ||'[' || i || ']');
        collection_length := collection_length + 1;
        xml_collection.extend;
        xml_collection(collection_length) := TRIM(current_node_value);
        SELECT extract(XMLTYPE(xml_string), path_string ||'[' || i || ']').getStringVal() INTO current_node_value  FROM dual;
        dbms_output.put_line(current_node_value);
    END LOOP;
    return xml_collection; 
end extract_with_subnodes;