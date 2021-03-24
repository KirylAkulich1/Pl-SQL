create or replace procedure convert_xml_to_query as 
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
    xml_string VARCHAR2(2000) :=  '<Operation>
    <Type>
        SELECT
    </Type>
    <Tables>
        <Table>
            XMLTEST1
        </Table>
        <Table>
            XMLTEST2
        </Table>
    </Tables>
    <Joins>
        <Join>
            <Type>
                LEFT JOIN
            </Type>
            <Condition>
                XMLTEST1.ID = XMLTEST2.ID
            </Condition>
        </Join>
    </Joins>
    <Columns>
        <Column>
            XMLTEST1.ID
        </Column>
        <Column>
            XMLTEST2.ID
        </Column>
    </Columns>
    <Where>
        <Conditions>
            <Condition>
                <Body>
                    XMLTEST1.ID =1
                </Body>
            `   <ConditionOperator>
                    AND
                </ConditionOperator>
            </Condition>
            
            <Condition>

                <Body>
                    EXISTS
                </Body>
                <Operation>
                    <Type>
                        SELECT
                    </Type>
                    <Table>
                        XMLTEST1
                    </Table>
                    <Columns>
                        ID
                    </Columns>
                    <WHERE>
                        ID = 1
                    </WHERE>
                </Operation>
            </Condition>
        </Conditions>
    </Where>
</Operation>';
BEGIN
    -- Get table count;
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

end convert_xml_to_query;