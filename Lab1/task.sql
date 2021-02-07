SET SERVEROUTPUT ON

BEGIN
	dbms_output.put_line(COUNT_YEAR_AWARD(100,50));
    dbms_output.put_line(COUNT_YEAR_AWARD(-50,50));
END;
