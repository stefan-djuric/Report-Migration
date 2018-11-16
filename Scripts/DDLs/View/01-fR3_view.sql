-- View: report."FR3 Monthly Billing Details"

-- DROP VIEW report."FR3 Monthly Billing Details";

CREATE OR REPLACE VIEW report."FR3 Monthly Billing Details" AS
 SELECT (z.customer_id || '_'::text) || to_char(now(), 'YYYY:MM:DD'::text) AS lead_col,
    z.posting_month,
    z.customer_id,
    sum(z.positive_miles) AS positive_miles,
    sum(z.negative_miles) AS negative_miles,
    z.prov_tape_num,
    COALESCE(lkp_provider.provider_name, ''::character varying)::text AS provider_name,
    z.sponsor_code,
    sum(z.total_miles) AS total_miles,
    count(z.id) AS transac_count,
    z.location_code,
    z.location_desc,
    z.offer_code,
    z.offer_desc,
    z.prod_desc
   FROM ( SELECT issuance.id,
            date_trunc('month'::text, issuance.posting_date) AS posting_month,
            issuance.customer_id,
                CASE
                    WHEN issuance.miles_issued > 0 THEN issuance.miles_issued
                    ELSE 0
                END AS positive_miles,
                CASE
                    WHEN issuance.miles_issued < 0 THEN issuance.miles_issued
                    ELSE 0
                END AS negative_miles,
                CASE
                    WHEN lower(issuance.client_type::text) = 'batch'::text THEN "substring"(issuance.client_id::text, 5)
                    ELSE '0'::text
                END AS prov_tape_num,
                CASE
                    WHEN lower(issuance.client_type::text) = 'batch'::text THEN "substring"(issuance.client_id::text, 1, 4)
                    ELSE ''::text
                END AS provider_code,
            issuance.issuer_code AS sponsor_code,
            issuance.miles_issued AS total_miles,
            COALESCE(issuance.location_code, 'ALL'::character varying)::character varying(10) AS location_code,
            COALESCE(lkp_location.location_desc, 'ALL Locations'::character varying)::character varying(15)::text AS location_desc,
            issuance.offer_code,
            COALESCE(lkp_issuer_offer.offer_desc_en, 'UNKNOWN'::character varying)::text AS offer_desc,
            COALESCE(COALESCE(issuance.dream_product_code, issuance.cash_product_code), 'UNKNOWN'::character varying(20)) AS prod_desc
           FROM transaction.issuance
             LEFT JOIN report.lkp_location ON lkp_location.issuer_code::text = issuance.issuer_code::text AND issuance.location_code::text = lkp_location.location_code::text
             LEFT JOIN report.lkp_issuer_offer ON issuance.issuer_code::text = lkp_issuer_offer.issuer_code::text AND issuance.offer_code::text = lkp_issuer_offer.offer_code::text
          WHERE issuance.billable = true AND date_trunc('month'::text, issuance.posting_date) = (( SELECT date_trunc('month'::text, (( SELECT to_date((( SELECT tbl_gen_params.param_value
                                   FROM report.tbl_gen_params
                                  WHERE tbl_gen_params.param_class::text = 'GLOBAL'::text AND tbl_gen_params.param_name::text = 'CURRENT_DAY_PERIOD'::text))::text, 'YYYYMMDD'::text) AS to_date))::timestamp with time zone) - '1 mon'::interval))) z
     LEFT JOIN report.lkp_provider ON lkp_provider.provider_code::text = z.provider_code
  GROUP BY z.posting_month, z.customer_id, z.prov_tape_num, z.provider_code, lkp_provider.provider_name, z.sponsor_code, z.location_code, z.offer_code, z.prod_desc, z.location_desc, z.offer_desc;

ALTER TABLE report."FR3 Monthly Billing Details"
    OWNER TO finadmin;

GRANT SELECT ON TABLE report."FR3 Monthly Billing Details" TO finance_user;
GRANT ALL ON TABLE report."FR3 Monthly Billing Details" TO finadmin;
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE ON TABLE report."FR3 Monthly Billing Details" TO report_user;
GRANT SELECT ON TABLE report."FR3 Monthly Billing Details" TO billing_user;
GRANT SELECT ON TABLE report."FR3 Monthly Billing Details" TO finance_readonly;
