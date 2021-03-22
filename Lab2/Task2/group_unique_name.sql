create or replace TRIGGER UNIQUE_NAME 
BEFORE INSERT OR UPDATE 
ON GROUPS
FOR EACH ROW
DECLARE 
    unique_exception EXCEPTION;
    PRAGMA exception_init(unique_exception,-1);
    CURSOR groups_cur IS 
        SELECT * FROM GROUPS;
BEGIN
    <<chek_loop>>
    FOR group_row in groups_cur LOOP
    IF ( group_row.NAME = :NEW.NAME ) THEN
            RAISE unique_exception;
        END IF;
  END LOOP  chek_loop;
  
END;


SELECT obj1.OBJECT_NAME as name1 obj2.OBJECT_NAME FROM ALL_OBJECTS obj1
    FULL  JOIN ALL_OBJECTS obj2
    ON obj1.OBJECT_NAME=obj2.OBJECT_NAME
    WHERE
    obj1.OBJECT_TYPE='PROCEDURE' AND obj1.OWNER='DEV'
    AND obj2.OBJECT_TYPE='PROCEDURE' AND obj2.OWNER='PROD';

SELECT obj1.OBJECT_NAME FROM all_objects obj1
        WHERE OBJECT_TYPE= 'PROCEDURE' AND OWNER= 'DEV';


         SELECT obj1.OBJECT_NAME as name1,obj2.OBJECT_NAME as name2 FROM ALL_OBJECTS obj1
    FULL  JOIN ALL_OBJECTS obj2
    ON obj1.OBJECT_NAME=obj2.OBJECT_NAME
    WHERE obj1.OBJECT_TYPE= 'PROCEDURE' AND obj2.OBJECT_TYPE = 'PROCEDURE'
    AND obj1.OWNER= 'DEV' AND obj2.OWNER='PROD';


SELECT src1.line,src1.text
            FROM all_source src1
            FULL JOIN all_source src2
            ON   src1.name = src2.name
            WHERE
            src1.name='PROC1' AND 
            src1.line = src2.line
            AND NOT src1.text = src2.text
            AND src1.OWNER='DEV' AND src2.OWNER = 'PROD';
SELECT tables1.table_name FROM 
    dba_tables tables1 WHERE OWNER = 'DEV'
    MINUS
    SELECT  tables2.table_name FROM dba_tables tables2 WHERE OWNER='PROD';

    SELECT tables1.table_name FROM 
                                dba_tables tables1 WHERE OWNER = schema1
                                UNION
                                SELECT  tables2.table_name FROM dba_tables tables2 WHERE OWNER=schema2

SELECT sel1.name,sel2.name INTO  FROM 
        (SELECT table1.COLUMN_NAME name,table1.DATA_TYPE FROM 
        dba_tab_columns table1 WHERE OWNER='system' AND TABLE_NAME='dba_tables') sel1
        JOIN 
        (SELECT table2.COLUMN_NAME name,table2.DATA_TYPE t 
        FROM dba_tab_columns table2  WHERE OWNER='DEV' AND TABLE_NAME = 'TABLE1') sel2
        ON sel1.name = sel2.name
        WHERE sel1.name IS NULL AND sel2.name IS NULL;


SELECT a.table_name, a.column_name, a.constraint_name, c.owner, 
       c.r_owner, c_pk.table_name r_table_name, c_pk.constraint_name r_pk
  FROM all_cons_columns a
  JOIN all_constraints c ON a.owner = c.owner
                        AND a.constraint_name = c.constraint_name
  JOIN all_constraints c_pk ON c.r_owner = c_pk.owner
                           AND c.r_constraint_name = c_pk.constraint_name
 WHERE c.constraint_type = 'R'
   AND a.table_name = :TableName


CREATE TABLE DEV.TABLE2(
    ID NUMBER PRIMARY KEY,
    TABLE1_id NUMBER,
    CONSTRAINT fk_table1 FOREIGN KEY (TABLE1_id)
    REFERENCES DEV.TABLE1(ID)
    );



create or replace PROCEDURE "COMPARE_AND_REPLACE_SOURCE" 
(
  schema1 in varchar2 
, schema2 in varchar2
, obj_type in varchar2
) as 
    different_lines NUMBER :=0;
CURSOR schemas_intersect IS
    SELECT obj1.OBJECT_NAME as name1,obj2.OBJECT_NAME as name2 FROM ALL_OBJECTS obj1
    FULL  JOIN ALL_OBJECTS obj2
    ON obj1.OBJECT_NAME=obj2.OBJECT_NAME
    WHERE obj1.OBJECT_TYPE= obj_type AND obj2.OBJECT_TYPE = obj_TYPE
    AND obj1.OWNER= schema1 AND obj2.OWNER=schema2;
begin

    FOR object_name_pair IN ( SELECT obj1.OBJECT_NAME as name1,obj2.OBJECT_NAME as name2 FROM ALL_OBJECTS obj1
                                    FULL  JOIN ALL_OBJECTS obj2
                                    ON obj1.OBJECT_NAME=obj2.OBJECT_NAME
                                    WHERE 
                                    obj1.OBJECT_TYPE= obj_type AND obj2.OBJECT_TYPE = obj_TYPE
                                    AND obj1.OWNER= schema1 AND obj2.OWNER=schema2) LOOP 

        IF object_name_pair.name1 IS NULL THEN
            delete_object(schema2,obj_type,object_name_pair.name2);
        ELSIF object_name_pair.name2 IS NULL THEN
            create_object(schema2,obj_type,object_name_pair.name1);
        ELSE
            SELECT COUNT(*) INTO different_lines
            FROM all_source src1
            FULL JOIN all_source src2
            ON   src1.name = src2.name
            WHERE
            src1.name= object_name_pair.name1 AND 
            src1.line = src2.line
            AND NOT src1.text = src2.text
            AND src1.OWNER=schema1 AND src2.OWNER = schema2;

            IF different_lines > 0 THEN
                replace_object(schema1,schema2,object_name_pair.name1);
            END IF;
        END IF;
    END LOOP;

end compare_and_replace_source;


/*
 SELECT obj1.OBJECT_NAME as name1,obj2.OBJECT_NAME as name2 FROM ALL_OBJECTS obj1
                                    FULL  JOIN ALL_OBJECTS obj2
                                    ON obj1.OBJECT_NAME=obj2.OBJECT_NAME
                                    WHERE 
                                    obj1.OBJECT_TYPE= 'PROCEDURE' AND obj2.OBJECT_TYPE = 'PROCEDURE'
                                    AND obj1.OWNER= 'DEV' obj2.OWNER='PROD';
                                    */
SELECT obj1.name as name1,obj2.name
    FROM 
    (SELECT obj_table1.OBJECT_NAME name
    FROM  ALL_OBJECTS  obj_table1
    WHERE obj_table1.OBJECT_TYPE = 'PROCEDURE' AND obj_table1.OWNER='DEV') obj1
    FULL JOIN
     (SELECT obj_table2.OBJECT_NAME name 
    FROM  ALL_OBJECTS  obj_table2
    WHERE obj_table2.OBJECT_TYPE = 'PROCEDURE' AND obj_table2.OWNER='PROD') obj2
    ON obj1.name = obj2.name ;