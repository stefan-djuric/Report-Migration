-- View: report."PES2 Issuance Control Report"

-- DROP VIEW report."PES2 Issuance Control Report";

CREATE OR REPLACE VIEW report."PES2 Issuance Control Report" AS
 WITH a AS (
         SELECT issuance.customer_id AS sold_to_cust_id,
            customer.description::text AS description,
            issuance.issuer_code,
            date(issuance.posting_date) AS order_date,
            issuance.dream_product_code,
            issuance.cash_product_code,
            sum(issuance.dream_miles)::numeric(18,3) AS dream_miles,
            sum(issuance.cash_miles)::numeric(18,3) AS cash_miles
           FROM transaction.issuance
             LEFT JOIN billing.customer ON issuance.customer_id = customer.customer_id
          WHERE date(issuance.posting_date) = (( SELECT to_date((( SELECT tbl_gen_params.param_value
                           FROM report.tbl_gen_params
                          WHERE tbl_gen_params.param_class::text = 'GLOBAL'::text AND tbl_gen_params.param_name::text = 'CURRENT_DAY_PERIOD'::text))::text, 'YYYYMMDD'::text) - 1))
          GROUP BY issuance.customer_id, customer.description, issuance.issuer_code, (date(issuance.posting_date)), issuance.dream_product_code, issuance.cash_product_code
        )
 SELECT a.sold_to_cust_id,
    a.description,
    a.issuer_code,
    a.order_date,
    a.dream_product_code AS product_code,
    a.dream_miles AS qty_ordered
   FROM a
UNION
 SELECT a.sold_to_cust_id,
    a.description,
    a.issuer_code,
    a.order_date,
    a.cash_product_code AS product_code,
    a.cash_miles AS qty_ordered
   FROM a;

ALTER TABLE report."PES2 Issuance Control Report"
    OWNER TO finadmin;

GRANT SELECT ON TABLE report."PES2 Issuance Control Report" TO finance_user;
GRANT ALL ON TABLE report."PES2 Issuance Control Report" TO finadmin;
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE ON TABLE report."PES2 Issuance Control Report" TO report_user;
GRANT SELECT ON TABLE report."PES2 Issuance Control Report" TO billing_user;
GRANT SELECT ON TABLE report."PES2 Issuance Control Report" TO finance_readonly;
