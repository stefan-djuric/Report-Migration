-- Table: report.tbl_gen_params

-- DROP TABLE report.tbl_gen_params;

CREATE TABLE report.tbl_gen_params
(
    param_id integer NOT NULL DEFAULT nextval('report.tbl_gen_params_param_id_seq'::regclass),
    param_class character varying(50) COLLATE pg_catalog."default",
    param_name character varying(50) COLLATE pg_catalog."default",
    param_value character varying(50) COLLATE pg_catalog."default",
    value_context date
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE report.tbl_gen_params
    OWNER to finadmin;

GRANT SELECT ON TABLE report.tbl_gen_params TO billing_user;

GRANT ALL ON TABLE report.tbl_gen_params TO finadmin;

GRANT SELECT ON TABLE report.tbl_gen_params TO finance_readonly;

GRANT SELECT ON TABLE report.tbl_gen_params TO finance_user;

GRANT SELECT, DELETE, TRUNCATE, UPDATE, INSERT ON TABLE report.tbl_gen_params TO report_user;