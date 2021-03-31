create or replace function html_report(table_names IN string_array,ts IN TIMESTAMP) return varchar2 as 
html_document VARCHAR2(500):='<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>
</head>
<body>
';
operation_count NUMBER;
sys_ref_c SYS_REFCURSOR;
operation_name VARCHAR(20);
begin
  FOR i in 1..table_names.count LOOP
  html_document := html_document || '<h6>' || table_names(i) || '</h6>';
    OPEN sys_ref_c FOR 'SELECT operation,COUNT(*) FROM ' || table_names(i) || '_AUDIT ' ||
                                'WHERE  is_reverted=0 
                                AND change_time > TO_TIMESTAMP(''' || TO_CHAR(ts,'DD-MM-YYYY HH:MI:SS') || ''', ''DD-MM-YYYYHH:MI:SS'')
                                GROUP BY operation';
        LOOP
            FETCH sys_ref_c INTO operation_name,operation_count;
            EXIT WHEN sys_ref_c%NOTFOUND;
            html_document := html_document || operation_name || ':' || operation_count || '<p>';
        END LOOP;
    CLOSE sys_ref_c;
  END LOOP;
  html_document := html_document || '</body></html>';
  return html_document;
end html_report;

