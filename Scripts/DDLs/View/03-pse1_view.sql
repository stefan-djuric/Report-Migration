-- View: report."PES1 < YESTERDAY"

-- DROP VIEW report."PES1 < YESTERDAY";

CREATE OR REPLACE VIEW report."PES1 < YESTERDAY" AS
 SELECT x.zz
   FROM ( WITH a AS (
                 WITH f AS (
                         SELECT issuance.customer_id::character(15) AS sold_to_cust_id,
                            to_char(date(issuance.posting_date)::timestamp with time zone, 'YYYY/MM/DD'::text) AS order_date,
                            issuance.dream_product_code::character(18) AS dream_product_code,
                            issuance.cash_product_code::character(18) AS cash_product_code,
                            issuance.issuer_code::character(254) AS issuer_code,
                            lpad(nextval('report.pse1'::regclass)::text, 10, '0'::text) AS order_no,
                                CASE
                                    WHEN (sum(issuance.dream_miles)::numeric / 1000::numeric) > 0::numeric THEN concat('+'::character(1), lpad((sum(issuance.dream_miles)::numeric / 1000::numeric)::numeric(11,4)::text, 15, '0'::text)::character(15))
                                    ELSE concat('-'::character(1), lpad((sum(issuance.dream_miles)::numeric / (- 1000::numeric))::numeric(11,4)::text, 15, '0'::text)::character(15))
                                END::character(16) AS dream_qty_ordered,
                                CASE
                                    WHEN (sum(issuance.cash_miles)::numeric / 1000::numeric) > 0::numeric THEN concat('+'::character(1), lpad((sum(issuance.cash_miles)::numeric / 1000::numeric)::numeric(11,4)::text, 15, '0'::text)::character(15))
                                    ELSE concat('-'::character(1), lpad((sum(issuance.cash_miles)::numeric / (- 1000::numeric))::numeric(11,4)::text, 15, '0'::text)::character(15))
                                END::character(16) AS cash_qty_ordered
                           FROM transaction.issuance
                          WHERE date(issuance.posting_date) = (( SELECT to_date((( SELECT tbl_gen_params.param_value
   FROM report.tbl_gen_params
  WHERE tbl_gen_params.param_class::text = 'GLOBAL'::text AND tbl_gen_params.param_name::text = 'CURRENT_DAY_PERIOD'::text))::text, 'YYYYMMDD'::text) - 1))
                          GROUP BY issuance.customer_id, (date(issuance.posting_date)), issuance.dream_product_code, issuance.cash_product_code, issuance.issuer_code
                        )
                 SELECT f.sold_to_cust_id,
                    f.order_date,
                    f.dream_product_code AS product_code,
                    f.issuer_code,
                    f.order_no,
                    f.dream_qty_ordered AS qty_ordered
                   FROM f
                UNION
                 SELECT f.sold_to_cust_id,
                    f.order_date,
                    f.cash_product_code AS product_code,
                    f.issuer_code,
                    f.order_no,
                    f.cash_qty_ordered AS qty_ordered
                   FROM f
                )
         SELECT concat('010ALYLT1'::character(10), repeat(' '::text, 62), a.sold_to_cust_id, repeat(' '::text, 62), a.order_date, repeat(' '::text, 106), 'ISSUED'::character(10), repeat(' '::text, 129), 'LOYISS'::character(6), repeat(' '::text, 118), 'EDI'::character(6), repeat(' '::text, 1), a.order_no, 'O'::character(3), repeat(' '::text, 6), 'SO'::character(3)) AS zz,
            a.order_no AS sorter,
            1 AS r_type
           FROM a
        UNION
         SELECT concat('050A'::character(4), repeat(' '::text, 108), a.qty_ordered, repeat(' '::text, 18), a.product_code, 'CPM'::character(3), a.order_date, ' 06:00:00'::character(9), repeat(' '::text, 12), a.order_date, ' 06:00:00'::character(9), repeat(' '::text, 12), repeat(' '::text, 41), 'LYLT1'::character(5), 'ISSUED'::character(10), repeat(' '::text, 77), 'LOYISS'::character(6), repeat(' '::text, 154), a.order_date, ' 06:00:00'::character(9), repeat(' '::text, 12), 'O'::character(1)) AS zz,
            a.order_no AS sorter,
            2 AS r_type
           FROM a
        UNION
         SELECT concat('070A'::character(4), 'SPONSOR'::character(10), repeat(' '::text, 10), a.issuer_code) AS zz,
            a.order_no AS sorter,
            3 AS r_type
           FROM a) x
  ORDER BY x.sorter, x.r_type;

ALTER TABLE report."PES1 < YESTERDAY"
    OWNER TO finadmin;

GRANT SELECT ON TABLE report."PES1 < YESTERDAY" TO finance_user;
GRANT ALL ON TABLE report."PES1 < YESTERDAY" TO finadmin;
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE ON TABLE report."PES1 < YESTERDAY" TO report_user;
GRANT SELECT ON TABLE report."PES1 < YESTERDAY" TO billing_user;
GRANT SELECT ON TABLE report."PES1 < YESTERDAY" TO finance_readonly;
