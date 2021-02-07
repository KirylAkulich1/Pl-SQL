CREATE OR REPLACE FUNCTION odd_check RETURN VARCHAR IS
        odd_count NUMBER;
        n_odd_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO odd_count  FROM MyTable WHERE mod(val,2)=0 ;
        SELECT COUNT(*) INTO n_odd_count  FROM MyTable WHERE mod(val,2)=1 ;
        IF odd_count  > n_odd_count
        THEN
            RETURN 'TRUE';
        ELSIF odd_count < n_odd_count 
        THEN
            RETURN 'FALSE';
        ELSE
            RETURN ' EQUAL';
        END IF;
    END;