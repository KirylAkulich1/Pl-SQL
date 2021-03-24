create or replace function extract_values(xml_string IN VARCHAR2, path_string IN VARCHAR2) return xml_record as 
    i NUMBER := 1;
    collection_length NUMBER :=0;
    current_node_value VARCHAR2(50) := ' ';
    xml_collection xml_record := xml_record();
begin
   SELECT EXTRACTVALUE(XMLTYPE(xml_string), path_string ||'[' || i || ']') INTO current_node_value  FROM dual;
   WHILE current_node_value IS NOT NULL LOOP
        i := i+1;
        dbms_output.put_line(path_string ||'[' || i || ']');
        collection_length := collection_length + 1;
        xml_collection.extend;
        xml_collection(collection_length) := TRIM(current_node_value);
        SELECT EXTRACTVALUE(XMLTYPE(xml_string), path_string ||'[' || i || ']') INTO current_node_value  FROM dual;
    END LOOP;
    return xml_collection;
end extract_values;