CREATE OR REPLACE FUNCTION count_year_award(year_salary IN REAL, extra_percent IN INTEGER) RETURN FLOAT IS
    total_award FLOAT := 0;
    float_percent FLOAT :=0;
    BEGIN
        IF year_salary <0 OR extra_percent>100 OR extra_percent<0 THEN
            dbms_output.put_line('INCORRECT INPUT'); 
            RETURN -1;
        END IF;
        float_percent := extra_percent/100;
        RETURN (1+float_percent)*12*year_salary;
        EXCEPTION WHEN others THEN
        dbms_output.put_line('INCORRECT INPUT'); 
        RETURN -1;
        
    END count_year_award ;