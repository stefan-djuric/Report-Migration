-- View: report."FR4 Total Miles of Issuer Offers"

-- DROP VIEW report."FR4 Total Miles of Issuer Offers";

CREATE OR REPLACE VIEW report."FR4 Total Miles of Issuer Offers" AS
 SELECT date_trunc('month'::text, issuance.posting_date) AS posting_month,
    date(issuance.posting_date) AS posting_date,
    issuance.offer_code,
    COALESCE(lkp_issuer_offer.offer_desc_en, 'UNKNOWN'::character varying(100)) AS offer_descr,
    issuance.customer_id,
    COALESCE(customer.description, 'UNKNOWN'::character varying(40)) AS description,
    issuance.dream_product_code,
    issuance.cash_product_code,
    issuance.issuer_code,
    COALESCE(lkp_issuer.issuer_name, 'UNKNOWN'::character varying(100)) AS issuer_name,
    sum(issuance.cash_miles) AS cash_miles,
    sum(issuance.dream_miles) AS dream_miles,
    sum(issuance.cash_miles + issuance.dream_miles) AS total_miles
   FROM transaction.issuance
     LEFT JOIN billing.customer ON issuance.customer_id = customer.customer_id
     LEFT JOIN report.lkp_issuer_offer ON lkp_issuer_offer.issuer_code::text = issuance.issuer_code::text AND issuance.offer_code::text = lkp_issuer_offer.offer_code::text
     LEFT JOIN report.lkp_issuer ON issuance.issuer_code::text = lkp_issuer.issuer_code::text
  GROUP BY (date_trunc('month'::text, issuance.posting_date)), (date(issuance.posting_date)), issuance.offer_code, issuance.customer_id, customer.description, issuance.dream_product_code, issuance.cash_product_code, issuance.issuer_code, lkp_issuer.issuer_name, lkp_issuer_offer.offer_desc_en;

ALTER TABLE report."FR4 Total Miles of Issuer Offers"
    OWNER TO finadmin;

GRANT SELECT ON TABLE report."FR4 Total Miles of Issuer Offers" TO finance_user;
GRANT ALL ON TABLE report."FR4 Total Miles of Issuer Offers" TO finadmin;
GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE ON TABLE report."FR4 Total Miles of Issuer Offers" TO report_user;
GRANT SELECT ON TABLE report."FR4 Total Miles of Issuer Offers" TO billing_user;
GRANT SELECT ON TABLE report."FR4 Total Miles of Issuer Offers" TO finance_readonly;
