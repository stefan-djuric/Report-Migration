-- FUNCTION: report.fr3_file(text)

-- DROP FUNCTION report.fr3_file(text);

CREATE OR REPLACE FUNCTION report.fr3_file(
	in_file_type text)
    RETURNS TABLE(out_msg text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

begin

	IF IN_FILE_TYPE = 'OFFER'
		then
		return query

		
select zz.b

from 
(
			 WITH a AS (
							SELECT "FR3 Monthly Billing Details".lead_col,
								"FR3 Monthly Billing Details".posting_month,
								"FR3 Monthly Billing Details".customer_id,
								"FR3 Monthly Billing Details".positive_miles,
								"FR3 Monthly Billing Details".negative_miles,
								"FR3 Monthly Billing Details".prov_tape_num,
								"FR3 Monthly Billing Details".provider_name,
								"FR3 Monthly Billing Details".sponsor_code,
								"FR3 Monthly Billing Details".total_miles,
								"FR3 Monthly Billing Details".transac_count,
								"FR3 Monthly Billing Details".location_code,
								"FR3 Monthly Billing Details".location_desc,
								"FR3 Monthly Billing Details".offer_code,
								"FR3 Monthly Billing Details".offer_desc,
								"FR3 Monthly Billing Details".prod_desc
							FROM report."FR3 Monthly Billing Details"
							)
					SELECT 0 AS sorter_1,
						'0'::text AS sorter_2,
						'0'::text AS sorter_3,
						'0'::text AS sorter_4,
						
						concat(
								'1'::text, repeat(' '::text, 153)
								) as b

								UNION
					SELECT 0 AS sorter_1,
						'0'::text AS sorter_2,
						'0'::text AS sorter_3,
						'1'::text AS sorter_4,
						
						repeat(' '::text, 154) as b
						

						UNION
					SELECT 0 AS sorter_1,
						'0'::text AS sorter_2,
						'0'::text AS sorter_3,
						'2'::text AS sorter_4,
						
						concat(
							' '::text,lpad('CUSTOMER ID'::text,11,' '),repeat(' '::text, 2), 'SPON CODE'::character(10),repeat(' '::text, 2),
							'PRODUCT CODE'::character(18),repeat(' '::text, 2),'OFFER CD'::character(8),repeat(' '::text, 2),'OFFER DESCRIPTION'::character(30),
							repeat(' '::text, 2),lpad('TRANS COUNT'::text,12,' '),repeat(' '::text, 2),lpad('POSITIVE MILES'::text,16,' '),repeat(' '::text, 2),
							lpad('NEGATIVE MILES'::text,16,' '),repeat(' '::text, 2),lpad('TOTAL MILES'::text,16,' ')) as b
							

					UNION
					SELECT 1 AS sorter_1,
						'1'::text AS sorter_2,
						'1'::text AS sorter_3,
						'0'::text AS sorter_4,
						
						concat(' '::text,
						repeat('-'::text, 11),repeat(' '::text, 2),	repeat('-'::text, 10),repeat(' '::text, 2),repeat('-'::text, 18),repeat(' '::text, 2),
						repeat('-'::text, 8),repeat(' '::text, 2),	repeat('-'::text, 30),repeat(' '::text, 2),repeat('-'::text, 12),repeat(' '::text, 2),
						repeat('-'::text, 16),repeat(' '::text, 2),	repeat('-'::text, 16),repeat(' '::text, 2),	repeat('-'::text, 16) ) as b

						UNION
					SELECT 2 AS sorter_1,
						a.customer_id::text AS sorter_2,
						a.sponsor_code::text AS sorter_3,
						'0'::text AS sorter_4,
						
						concat(' '::text,
						lpad(a.customer_id::text,11,' '),repeat(' '::text, 2),a.sponsor_code::character(10),repeat(' '::text, 2),
						a.prod_desc::character(18),repeat(' '::text, 2),a.offer_code::character(8),repeat(' '::text, 2),a.offer_desc::character(30),
						repeat(' '::text, 2),lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12),repeat(' '::text, 2),
						lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) ,repeat(' '::text, 2),
						lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) ,repeat(' '::text, 2),
						lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
						
					FROM a
					GROUP BY a.customer_id, a.sponsor_code, a.prod_desc, a.offer_code, a.offer_desc
					
					
					UNION
					SELECT 2 AS sorter_1,
						a.customer_id::text AS sorter_2,
						a.sponsor_code::text AS sorter_3,
						'1'::text AS sorter_4,
						
						concat(repeat(' '::text, 88),repeat('-'::text, 12),repeat(' '::text, 2),repeat('-'::text, 16),repeat(' '::text, 2),	
						repeat('-'::text, 16),repeat(' '::text, 2),	repeat('-'::text, 16) ) as b

					FROM a
					GROUP BY a.customer_id, a.sponsor_code

					UNION

					SELECT 2 AS sorter_1,
						a.customer_id::text AS sorter_2,
						a.sponsor_code::text AS sorter_3,
						'2'::text AS sorter_4,
						
						concat(repeat(' '::text, 64),'TOTAL FOR SPONSOR '::text,a.sponsor_code::character(4),repeat(' '::text, 2),
						lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12),repeat(' '::text, 2),
						lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) ,repeat(' '::text, 2),
						lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) ,repeat(' '::text, 2),
						lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
					FROM a
					GROUP BY a.customer_id, a.sponsor_code
					
					
					UNION
					SELECT 2 AS sorter_1,
						a.customer_id::text AS sorter_2,
						a.sponsor_code::text AS sorter_3,
						'3'::text AS sorter_4,
						
						repeat(' '::text, 154) as b
					FROM a
					GROUP BY a.customer_id, a.sponsor_code
					
					
					UNION
					SELECT 2 AS sorter_1,
						a.customer_id::text AS sorter_2,
						'ZZZZZZZZZZZZ'::text AS sorter_3,
						'4'::text AS sorter_4,
						
						concat(repeat(' '::text, 88),repeat('-'::text, 12),repeat(' '::text, 2),repeat('-'::text, 16),repeat(' '::text, 2),	
						repeat('-'::text, 16),repeat(' '::text, 2),	repeat('-'::text, 16) ) as b

						FROM a
					GROUP BY a.customer_id
					
					UNION
					
					SELECT 2 AS sorter_1,
						a.customer_id::text AS sorter_2,
						'ZZZZZZZZZZZZ'::text AS sorter_3,
						'5'::text AS sorter_4,
						
						concat(repeat(' '::text, 52),'GRAND TOTAL FOR CUSTOMER ID '::text,a.customer_id::character(6),repeat(' '::text, 2),
						lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12),repeat(' '::text, 2),
						lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) ,repeat(' '::text, 2),
						lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) ,repeat(' '::text, 2),
						lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
					FROM a
					GROUP BY a.customer_id
					
					UNION
					
					SELECT 2 AS sorter_1,
						a.customer_id::text AS sorter_2,
						'ZZZZZZZZZZZZ'::text AS sorter_3,
						'6'::text AS sorter_4,
						
						repeat(' '::text, 154) as b
					FROM a
					GROUP BY a.customer_id
					
					UNION
					
					SELECT 3 AS sorter_1,
						'1'::text AS sorter_2,
						'1'::text AS sorter_3,
						'0'::text AS sorter_4,
						
						concat(repeat(' '::text, 88),repeat('='::text, 12),repeat(' '::text, 2),repeat('='::text, 16),repeat(' '::text, 2),	
						repeat('='::text, 16),repeat(' '::text, 2),	repeat('='::text, 16) ) as b

					UNION
					
					SELECT 3 AS sorter_1,
						'1'::text AS sorter_2,
						'1'::text AS sorter_3,
						'1'::text AS sorter_4,
						
						concat(repeat(' '::text, 88),
						lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12),repeat(' '::text, 2),
						lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) ,repeat(' '::text, 2),
						lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) ,repeat(' '::text, 2),
						lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
						
					FROM a) zz
			ORDER BY zz.sorter_1, zz.sorter_2, zz.sorter_3, zz.sorter_4;

			elsif IN_FILE_TYPE = 'LOCOFR'
		then
		return query

select zz.b

from 
(
 
		WITH a AS (
                 SELECT "FR3 Monthly Billing Details".lead_col,
                    "FR3 Monthly Billing Details".posting_month,
                    "FR3 Monthly Billing Details".customer_id,
                    "FR3 Monthly Billing Details".positive_miles,
                    "FR3 Monthly Billing Details".negative_miles,
                    "FR3 Monthly Billing Details".prov_tape_num,
                    "FR3 Monthly Billing Details".provider_name,
                    "FR3 Monthly Billing Details".sponsor_code,
                    "FR3 Monthly Billing Details".total_miles,
                    "FR3 Monthly Billing Details".transac_count,
                    "FR3 Monthly Billing Details".location_code,
                    "FR3 Monthly Billing Details".location_desc,
                    "FR3 Monthly Billing Details".offer_code,
                    "FR3 Monthly Billing Details".offer_desc,
                    "FR3 Monthly Billing Details".prod_desc
                   FROM report."FR3 Monthly Billing Details"
                )
         SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '0'::text AS sorter_4,
            '0'::text AS sorter_5,
			
			concat('1'::text,repeat(' '::text,111)) as b
        
		UNION
         
		 SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '0'::text AS sorter_4,
            '1'::text AS sorter_5,
			
			repeat(' '::text,112) as b
			
        UNION
         
		 SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '0'::text AS sorter_4,
            '2'::text AS sorter_5,
			
			concat(repeat(' '::text,14),'SPONSOR'::character(7),repeat(' '::text,26),'TRANSACTION'::text,repeat(' '::text,54)) as b
			
        UNION
         
		 SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '0'::text AS sorter_4,
            '3'::text AS sorter_5,
			
			 ' CUSTOMER ID    CODE    LOC CODE  OFFERE CD       COUNT       POSITIVE MILES    NEGATIVE MILES       TOTAL MILES'::text

		UNION
        
		
		
		SELECT 1 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '0'::text AS sorter_4,
            '0'::text AS sorter_5,
			
			concat(' '::text,repeat('-'::text, 11),repeat(' '::text,2), repeat('-'::text, 8),repeat(' '::text,2),repeat('-'::text, 8),repeat(' '::text,2),
			repeat('-'::text, 10),repeat(' '::text,2),repeat('-'::text, 12),repeat(' '::text,2),repeat('-'::text, 16),repeat(' '::text,2),
			repeat('-'::text, 16),repeat(' '::text,2),repeat('-'::text, 16)) as b
			
        UNION

		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            a.location_code::text AS sorter_4,
            '0'::text AS sorter_5,
			
			concat(
			' '::text,lpad(a.customer_id::text,11,' '::text),repeat(' '::text,2),a.sponsor_code::character(8),repeat(' '::text,2),a.location_code::character(8),repeat(' '::text,2),
			a.offer_code::character(10),repeat(' '::text, 2), 
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b

           FROM a
          GROUP BY a.customer_id, a.sponsor_code, a.location_code, a.offer_code
       

	   UNION
         
		 
		 SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            a.location_code::text AS sorter_4,
            '1'::text AS sorter_5,
			
			concat(repeat(' '::text, 46),repeat('-'::text, 12),repeat(' '::text, 2),repeat('-'::text, 16),repeat(' '::text, 2),
			repeat('-'::text, 16),repeat(' '::text, 2),repeat('-'::text, 16)) as b 
			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code, a.location_code
        
		
		UNION
         
		 
		 SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            a.location_code::text AS sorter_4,
            '2'::text AS sorter_5,
			
			concat( lpad(('TOTAL FOR LOCATION '::text||a.location_code::text),44, ' '::text),repeat(' '::text, 2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) ,repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b

			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code, a.location_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            a.location_code::text AS sorter_4,
            '3'::text AS sorter_5,
			
			repeat(' '::text,112) as b
			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code, a.location_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            'ZZZZZZZZZZZZ'::text AS sorter_4,
            '4'::text AS sorter_5,
			
			concat(repeat(' '::text, 46),repeat('-'::text, 12),repeat(' '::text, 2),repeat('-'::text, 16),repeat(' '::text, 2),
			repeat('-'::text, 16),repeat(' '::text, 2),repeat('-'::text, 16)) as b 
	
           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            'ZZZZZZZZZZZZ'::text AS sorter_4,
            '5'::text AS sorter_5,
			
			concat( lpad(('TOTAL FOR SPONSOR '::text||a.sponsor_code::text),44, ' '::text),repeat(' '::text, 2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) ,repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b

           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            'ZZZZZZZZZZZZ'::text AS sorter_4,
            '6'::text AS sorter_5,
			
			repeat(' '::text,112) as b
			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            'ZZZZZZZZZZZZ'::text AS sorter_4,
            '7'::text AS sorter_5,
			
			concat(repeat(' '::text, 46),repeat('-'::text, 12),repeat(' '::text, 2),repeat('-'::text, 16),repeat(' '::text, 2),
			repeat('-'::text, 16),repeat(' '::text, 2),repeat('-'::text, 16)) as b 
			
			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            'ZZZZZZZZZZZZ'::text AS sorter_3,
            'ZZZZZZZZZZZZ'::text AS sorter_4,
            '8'::text AS sorter_5,
			
			concat( lpad(('GRAND TOTAL FOR CUSTOMER ID '::text||'CUSTOMER ID'::text),44, ' '::text),repeat(' '::text, 2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) ,repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999') ,16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b

           FROM a
          GROUP BY a.customer_id
        
		
		UNION
         SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            'ZZZZZZZZZZZZ'::text AS sorter_3,
            'ZZZZZZZZZZZZ'::text AS sorter_4,
            '9'::text AS sorter_5,
			
			repeat(' '::text,112) as b
			
           FROM a
          GROUP BY a.customer_id
        
		UNION
        
		SELECT 3 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '0'::text AS sorter_4,
            '0'::text AS sorter_5,
			
			concat(repeat(' '::text, 46),repeat('='::text, 12),repeat(' '::text, 2),repeat('='::text, 16),repeat(' '::text, 2),
			repeat('='::text, 16),repeat(' '::text, 2),repeat('='::text, 16)) as b 

        UNION
        
		SELECT 3 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '1'::text AS sorter_4,
            '0'::text AS sorter_5,
			
			concat(repeat(' '::text, 46),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) ,repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b

           FROM a) zz
  ORDER BY zz.sorter_1, zz.sorter_2, zz.sorter_3, zz.sorter_4, zz.sorter_5;
	
	
	
	
	
	elsif IN_FILE_TYPE = 'LOCCD'
	then
	return query

  
  select zz.b

from 
 (
			WITH a AS (
                 SELECT "FR3 Monthly Billing Details".lead_col,
                    "FR3 Monthly Billing Details".posting_month,
                    "FR3 Monthly Billing Details".customer_id,
                    "FR3 Monthly Billing Details".positive_miles,
                    "FR3 Monthly Billing Details".negative_miles,
                    "FR3 Monthly Billing Details".prov_tape_num,
                    "FR3 Monthly Billing Details".provider_name,
                    "FR3 Monthly Billing Details".sponsor_code,
                    "FR3 Monthly Billing Details".total_miles,
                    "FR3 Monthly Billing Details".transac_count,
                    "FR3 Monthly Billing Details".location_code,
                    "FR3 Monthly Billing Details".location_desc,
                    "FR3 Monthly Billing Details".offer_code,
                    "FR3 Monthly Billing Details".offer_desc,
                    "FR3 Monthly Billing Details".prod_desc
                   FROM report."FR3 Monthly Billing Details"
                )
         SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '0'::text AS sorter_4,
			
			concat('1'::text, repeat(' '::text,131))as b 
			
        UNION
        
		SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '1'::text AS sorter_4,
			
			repeat(' '::text,132) as b 
			
        UNION
        
		SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '2'::text AS sorter_4,
			
			'              SPONSOR                                              TRANSACTION                                                      '::text as b 
			
        UNION
        
		SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '3'::text AS sorter_4,
			
			' CUSTOMER ID   CODE     LOC CODE  LOCATION DESC                       COUNT       POSITIVE MILES    NEGATIVE MILES       TOTAL MILES'::text as b 
			
        UNION
         
		SELECT 1 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '0'::text AS sorter_4,
			
			concat( ' '::text,repeat('-'::text, 11),repeat(' '::text,2),repeat('-'::text, 8),repeat(' '::text,2),
			repeat('-'::text, 8),repeat(' '::text,2),repeat('-'::text, 30),repeat(' '::text,2),
			repeat('-'::text, 12),repeat(' '::text,2),repeat('-'::text, 16),repeat(' '::text,2),
			repeat('-'::text, 16),repeat(' '::text,2),repeat('-'::text, 16)) as b 

			UNION
         
		 SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            '0'::text AS sorter_4,
			
			concat( ' '::text,lpad(a.customer_id::text,11,' '),repeat(' '::text,2),a.sponsor_code::character(8),repeat(' '::text,2),
			a.location_code::character(8),repeat(' '::text,2),a.location_desc::character(30),repeat(' '::text,2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b

			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code, a.location_code, a.location_desc
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            '1'::text AS sorter_4,
			
			concat(repeat(' '::text, 66),
			repeat('-'::text, 12),repeat(' '::text,2),repeat('-'::text, 16),repeat(' '::text,2),
			repeat('-'::text, 16),repeat(' '::text,2),repeat('-'::text, 16)) as b 

			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            '2'::text AS sorter_4,
			
			concat(lpad(('TOTAL FOR SPONSOR '::text || a.sponsor_code::text),64,' '::text),repeat(' '::text, 2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b

           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            '3'::text AS sorter_4,
			
			repeat(' '::text,132) as b 
			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            'ZZZZZZZZZZZZ'::text AS sorter_3,
            '4'::text AS sorter_4,
			
			concat(repeat(' '::text, 66),
			repeat('-'::text, 12),repeat(' '::text,2),repeat('-'::text, 16),repeat(' '::text,2),
			repeat('-'::text, 16),repeat(' '::text,2),repeat('-'::text, 16)) as b 
			
           FROM a
          GROUP BY a.customer_id
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            'ZZZZZZZZZZZZ'::text AS sorter_3,
            '5'::text AS sorter_4,
			
			concat( lpad(('GRAND TOTAL FOR CUSTOMER ID '::text || a.customer_id::text),64,' '::text),repeat(' '::text,2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
						
           FROM a
          GROUP BY a.customer_id
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            'ZZZZZZZZZZZZ'::text AS sorter_3,
            '6'::text AS sorter_4,
			
			repeat(' '::text,132) as b
			
           FROM a
          GROUP BY a.customer_id
        
		UNION
        
		SELECT 3 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '0'::text AS sorter_4,
			
			concat(repeat(' '::text, 66),
			repeat('='::text, 12),repeat(' '::text,2),repeat('='::text, 16),repeat(' '::text,2),
			repeat('='::text, 16),repeat(' '::text,2),repeat('='::text, 16)) as b 
			
        UNION
        
		SELECT 3 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '1'::text AS sorter_4,
			
			concat(repeat(' '::text,66),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
			
			
           FROM a) zz
  ORDER BY zz.sorter_1, zz.sorter_2, zz.sorter_3, zz.sorter_4;
  
  
  
	elsif IN_FILE_TYPE = 'TRNSL'
	then
	return query
 
   select zz.b

from 
 (
  
   WITH a AS (
                 SELECT "FR3 Monthly Billing Details".lead_col,
                    "FR3 Monthly Billing Details".posting_month,
                    "FR3 Monthly Billing Details".customer_id,
                    "FR3 Monthly Billing Details".positive_miles,
                    "FR3 Monthly Billing Details".negative_miles,
                    "FR3 Monthly Billing Details".prov_tape_num,
                    "FR3 Monthly Billing Details".provider_name,
                    "FR3 Monthly Billing Details".sponsor_code,
                    "FR3 Monthly Billing Details".total_miles,
                    "FR3 Monthly Billing Details".transac_count,
                    "FR3 Monthly Billing Details".location_code,
                    "FR3 Monthly Billing Details".location_desc,
                    "FR3 Monthly Billing Details".offer_code,
                    "FR3 Monthly Billing Details".offer_desc,
                    "FR3 Monthly Billing Details".prod_desc
                   FROM report."FR3 Monthly Billing Details"
                )
         SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '0'::text AS sorter_4,
			
			concat('1'::text, repeat(' '::text,147)) as b
			
        UNION
         SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '1'::text AS sorter_4,
			
			repeat(' '::text,148) as b 
			
        UNION
        
		SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '2'::text AS sorter_4,
			
			'              SPONSOR     PROVIDER                                    TRANS LOG    TRANSACTION                                                      '::text as b
			
			
			
        UNION
       
	   SELECT 0 AS sorter_1,
            '0'::text AS sorter_2,
            '0'::text AS sorter_3,
            '3'::text AS sorter_4,
			
			
			' CUSTOMER ID   CODE      TAPE NUMBER  PROVIDER NAME                    REF.NUM        COUNT       POSITIVE MILES    NEGATIVE MILES       TOTAL MILES'::text as b 
			

			UNION
        
		SELECT 1 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '0'::text AS sorter_4,
			
			concat(' '::text, repeat('-'::text, 11),repeat(' '::text,2),repeat('-'::text, 8),repeat(' '::text,2) ,repeat('-'::text, 12),repeat(' '::text,2),
			repeat('-'::text, 30),repeat(' '::text,2),repeat('-'::text, 10),repeat(' '::text,2),repeat('-'::text, 12),repeat(' '::text,2),repeat('-'::text, 16),repeat(' '::text,2),
			repeat('-'::text, 16),repeat(' '::text,2),repeat('-'::text, 16) ) AS b 
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            '0'::text AS sorter_4,
			
			concat(' '::text,lpad(a.customer_id::text,11,' '::text), repeat(' '::text,2),a.sponsor_code::character(8),repeat(' '::text,2),
			lpad(a.prov_tape_num::text,12,' '::text),repeat(' '::text,2),a.provider_name::character(30),repeat(' '::text,2),'000000'::character(10),repeat(' '::text,2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
			
			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code, a.prov_tape_num, a.provider_name
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            '1'::text AS sorter_4,
			
			concat( repeat(' '::text, 82),
			repeat('-'::text, 12),repeat(' '::text,2),repeat('-'::text, 16),repeat(' '::text,2),
			repeat('-'::text, 16),repeat(' '::text,2),repeat('-'::text, 16) ) AS b 
			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            '2'::text AS sorter_4,
			
			concat(lpad(('TOTAL FOR SPONSOR '::text || a.sponsor_code::text),80,' '::text),repeat(' '::text,2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
			
			
           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            a.sponsor_code::text AS sorter_3,
            '3'::text AS sorter_4,
			
			repeat(' '::text,148) as b
           FROM a
          GROUP BY a.customer_id, a.sponsor_code
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            'ZZZZZZZZZZZZ'::text AS sorter_3,
            '4'::text AS sorter_4,
			
			concat( repeat(' '::text, 82),
			repeat('-'::text, 12),repeat(' '::text,2),repeat('-'::text, 16),repeat(' '::text,2),
			repeat('-'::text, 16),repeat(' '::text,2),repeat('-'::text, 16) ) AS b 
			
			
           FROM a
          GROUP BY a.customer_id
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            'ZZZZZZZZZZZZ'::text AS sorter_3,
            '5'::text AS sorter_4,
			
			concat(lpad(('GRAND TOTAL FOR CUSTOMER ID '::text || a.customer_id::text),80,' '::text),repeat(' '::text,2),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
			

			FROM a
          GROUP BY a.customer_id
        
		UNION
        
		SELECT 2 AS sorter_1,
            a.customer_id::text AS sorter_2,
            'ZZZZZZZZZZZZ'::text AS sorter_3,
            '6'::text AS sorter_4,
			
			repeat(' '::text,148) as b
			
           FROM a
          GROUP BY a.customer_id
        
		UNION
        
		SELECT 3 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '0'::text AS sorter_4,
			
			concat( repeat(' '::text, 82),
			repeat('='::text, 12),repeat(' '::text,2),repeat('='::text, 16),repeat(' '::text,2),
			repeat('='::text, 16),repeat(' '::text,2),repeat('='::text, 16) ) AS b 

        UNION
        
		SELECT 3 AS sorter_1,
            '1'::text AS sorter_2,
            '1'::text AS sorter_3,
            '1'::text AS sorter_4,
			
			concat(repeat(' '::text,82),
			lpad(to_char(sum(a.transac_count),'999,999,999'),12,' ')::character(12) , repeat(' '::text, 2),
			lpad(to_char(sum(a.positive_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2),
			lpad(to_char(sum(a.negative_miles),'999,999,999'), 16, ' ')::character(16) , repeat(' '::text, 2), 
			lpad(to_char(sum(a.total_miles),'999,999,999'), 16, ' ')::character(16) ) as b
			
			
           FROM a) zz
  ORDER BY zz.sorter_1, zz.sorter_2, zz.sorter_3, zz.sorter_4;  
	
	
	
	else
	return query
	SELECT 'UNSUPPORTED FILE TYPE'::text as zz;
	
	end if;
	
	END; 

$BODY$;

ALTER FUNCTION report.fr3_file(text)
    OWNER TO finadmin;
