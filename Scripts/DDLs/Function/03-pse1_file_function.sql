-- FUNCTION: report.pse1_file()

-- DROP FUNCTION report.pse1_file();

CREATE OR REPLACE FUNCTION report.pse1_file(
	)
    RETURNS TABLE(out_msg text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

 
   BEGIN   
		return query
			SELECT "PES1 < YESTERDAY".zz::text
			FROM report."PES1 < YESTERDAY";

END; 

$BODY$;

ALTER FUNCTION report.pse1_file()
    OWNER TO finadmin;
