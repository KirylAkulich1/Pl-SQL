SELECT 
FROM all_cons_columns cc 
JOIN all_constraints c ON 
        cc.owner=c.owner AND 
        c.r_constraint_name = 
JOIN all_constraints c_pk ON
    cc.owner=c_pk.r_owner
    cc.
WHERE c.constraint_type = 'R'
    AND cc.table_name='PRODUCTS';


SELECT c.table_name,c_pk.table_name
FROM all_constraints c 
JOIN all_constraints c_pk ON
    c.r_owner=c_pk.owner AND
    c_pk.constraint_name = c.r_constraint_name
WHERE c.constraint_type='R'
    AND c.table_name = 'PRODUCTS';


    CREATE TABLE SOME_TABLE (
    empid_number    int ,   
    employee        varchar (100),
    manager_number  int  ,
     PRIMARY KEY  (empid_number),
     CONSTRAINT manager_references_employee
     FOREIGN KEY (manager_number) REFERENCES SOME_TABLE(empid_number)
)

SELECT COUNT(*)
FROM dba_tab_columns f_st_table
JOIN dba_tab_columns s_nd_table
ON f_st_table.table_name=s_nd_table.table_name
AND f_st_table.owner != s_nd_table.owner
AND f_st_table.column_name=s_nd_table.column_name
AND f_st_table.data_type = s_nd_table.data_type
WHERE f_st_table.column_name is NULL OR 
s_nd_table.column_name is NULL;

SELECT f_st_table.column_name,s_nd_table.column_name
FROM (SELECT column_name,data_type
FROM dba_tab_columns 
WHERE owner='DEV' AND table_name='PRODUCTS')
 f_st_table
FULL JOIN (SELECT column_name,data_type
    FROM dba_tab_columns 
    WHERE owner='PROD' AND table_name='CUSTOMERS') s_nd_table
ON f_st_table.column_name=s_nd_table.column_name
WHERE f_st_table.column_name is NULL OR s_nd_table.column_name is NULL;
