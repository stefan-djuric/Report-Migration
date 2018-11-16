-- FUNCTION: report.pse2_file()

-- DROP FUNCTION report.pse2_file();

CREATE OR REPLACE FUNCTION report.pse2_file(
	)
    RETURNS TABLE(out_msg text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	
BEGIN

 RETURN QUERY 
 
	SELECT zz.b
 
   FROM ( 
	   		WITH a AS (
						SELECT 
							sold_to_cust_id as customer_id, 
							description, 
							issuer_code, 
							order_date, 
							product_code, 
							qty_ordered
							FROM report."PES2 Issuance Control Report"
					) 
		    SELECT 
				0 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'0'::text AS sorter_4,
				
				repeat(' '::text, 94) as b
			
			union
		    SELECT 
				0 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'1'::text AS sorter_4,
				
				concat(
						'PROCESSING DATE:',
						repeat(' '::text, 4),
						(select to_date((select tbl_gen_params.param_value from report.tbl_gen_params where tbl_gen_params.param_class='GLOBAL' and tbl_gen_params.param_name='CURRENT_DAY_PERIOD'),'YYYYMMDD') -1)::character(10), 
						--('now'::text::date - 1)::character(10),
						repeat(' '::text, 64)) as b	
			union
			select
				0 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'2'::text AS sorter_4,
				concat(
						'ORDER START-DATE:',
						repeat(' '::text, 3),
						(select to_date((select tbl_gen_params.param_value from report.tbl_gen_params where tbl_gen_params.param_class='GLOBAL' and tbl_gen_params.param_name='CURRENT_DAY_PERIOD'),'YYYYMMDD') -1)::character(10), 
						--('now'::text::date - 1)::character(10),
						repeat(' '::text, 5),
						'ORDER END-DATE:',
						repeat(' '::text, 5),
						(select to_date((select tbl_gen_params.param_value from report.tbl_gen_params where tbl_gen_params.param_class='GLOBAL' and tbl_gen_params.param_name='CURRENT_DAY_PERIOD'),'YYYYMMDD') -1)::character(10), 
						--('now'::text::date - 1)::character(10),
						repeat(' '::text, 29)) as b	
			union
		    
			SELECT 
				0 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'3'::text AS sorter_4,
				repeat(' '::text, 94) as b
			
			union
		    
			SELECT 
				0 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'4'::text AS sorter_4,
				'CUSTOMER-ID        CUSTOMER-NAME                            PRODUCT-CODE        ORDER-AMOUNT  ' as b
			union
		    
			SELECT 
				0 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'5'::text AS sorter_4,
				'----------------   ------------------------                 ------------------  ------------  ' as b
			union
			
			select
				1 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'0'::text AS sorter_4,
				concat(
					lpad(a.customer_id::text,16,'0'),
					repeat(' '::text, 3),
					rpad(a.description,40,' ')::character(40),
					repeat(' '::text, 1),
					rpad(a.product_code,19,' '),
					repeat(' '::text, 1),
					lpad(to_char(sum(a.qty_ordered), '999,999,999'),13,' '),
					repeat(' '::text, 1)) as b
			from a
						   group by a.customer_id, a.description,a.product_code

			union
		    
			SELECT 
				1 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'1'::text AS sorter_4,
				
				repeat(' '::text, 94) as b			

			union
		    
			SELECT 
				2 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'0'::text AS sorter_4,
				concat(
					'TOTAL QUANTITY ORDERED=',
					lpad(to_char(sum(a.qty_ordered),'999,999,999'),26,' '),
					repeat(' '::text, 45)) as b			
				from a
			union
			SELECT 
				2 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'1'::text AS sorter_4,
				
				repeat(' '::text, 94) as b			
			union
			SELECT 
				2 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'2'::text AS sorter_4,
				concat(
					'TOTAL HEADERS INSERTED=',
					lpad(count(distinct(customer_id))::text,26,' '),
					repeat(' '::text, 45)) as b			
				from a
				--group by a.customer_id, a.issuer_code
			union			
			SELECT 
				2 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'3'::text AS sorter_4,
				concat(
					'TOTAL ORDER   LINES   =',
					lpad(count(distinct(customer_id,issuer_code))::text,26,' '),
					repeat(' '::text, 45)) as b			
				from a
			union			
			SELECT 
				2 AS sorter_1,
				'0'::text AS sorter_2,
				'0'::text AS sorter_3,
				'4'::text AS sorter_4,
				concat(
					'TOTAL ORDER   NOTES   =',
					lpad(count(distinct(customer_id,issuer_code))::text,26,' '),
					repeat(' '::text, 45)) as b			
				from a

				

				) zz 
		order by zz.sorter_1, zz.sorter_2, zz.sorter_3, zz.sorter_4;
					
						

END; 

$BODY$;

ALTER FUNCTION report.pse2_file()
    OWNER TO finadmin;
