create or replace procedure print_table_difference 
(
  schema1 in varchar2 
, schema2 in varchar2 
) as 
diff_count NUMBER :=0;
begin
   FOR common_table IN (SELECT table_name FROM 
                                dba_tables tables1 WHERE OWNER = schema1
                                INTERSECT
                                SELECT  tables2.table_name FROM dba_tables tables2 WHERE OWNER=schema2) LOOP
        SELECT COUNT(*) INTO diff_count  FROM 
        (SELECT table1.COLUMN_NAME name,table1.DATA_TYPE FROM 
        dba_tab_columns table1 WHERE OWNER=schema1 AND TABLE_NAME= common_table.table_name) sel1
        FULL JOIN 
        (SELECT table2.COLUMN_NAME name,table2.DATA_TYPE 
        FROM dba_tab_columns table2  WHERE OWNER=schema2 AND TABLE_NAME = common_table.table_name) sel2
        ON sel1.name = sel2.name
        WHERE sel1.name IS NULL OR sel2.name IS NULL;
        
        IF diff_count > 0 THEN
            dbms_output.put_line('Tables '  || common_table.table_name || ' DIFFERS');
        ELSE
            dbms_output.put_line('Tables '  || common_table.table_name || ' the same');
        END IF;
    END LOOP;
end print_table_difference;

