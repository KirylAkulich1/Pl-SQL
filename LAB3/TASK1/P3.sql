create or replace procedure order_table_appearence 
(
  schema_name in varchar2 
) as 

begin
    FOR schema_table IN (SELECT tables1.table_name name FROM 
                                dba_tables tables1 WHERE OWNER = schema_name) LOOP 
    INSERT INTO TABLES_FK_REF (CHILD_OBJ,PARENT_OBJ)
            SELECT DISTINCT  a.table_name, c_pk.table_name r_table_name
            FROM all_cons_columns a
            JOIN all_constraints c ON a.owner = c.owner
                        AND a.constraint_name = c.constraint_name
            JOIN all_constraints c_pk ON c.r_owner = c_pk.owner
                           AND c.r_constraint_name = c_pk.constraint_name
            WHERE c.constraint_type = 'R'
            AND a.table_name = schema_table.name   ;
        IF SQL%ROWCOUNT = 0 THEN
             dbms_output.put_line( schema_table.name);
        END IF;
            
    END LOOP;
    
    FOR fk_cur IN (
        SELECT   CHILD_OBJ,PARENT_obj,CONNECT_BY_ISCYCLE 
        FROM TABLES_FK_REF 
        CONNECT BY NOCYCLE PRIOR PARENT_OBJ = child_obj
        ORDER BY LEVEL
    ) LOOP  
        IF fk_cur.CONNECT_BY_ISCYCLE  = 0 THEN
         dbms_output.put_line(fk_cur.CHILD_OBJ);
        ELSE
           dbms_output.put_line('CYCLE IN TABLE' || fk_cur.CHILD_OBJ); 
        END IF;
    END LOOP;

    
end order_table_appearence;