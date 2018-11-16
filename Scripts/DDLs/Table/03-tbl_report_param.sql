-- Table: report.tbl_report_param

-- DROP TABLE report.tbl_report_param;

CREATE TABLE report.tbl_report_param
(
    report_id integer NOT NULL DEFAULT nextval('report.tbl_report_param_report_id_seq'::regclass),
    function_name character varying(50) COLLATE pg_catalog."default",
    total_param integer,
    param_1 character varying(50) COLLATE pg_catalog."default",
    param_2 character varying(50) COLLATE pg_catalog."default",
    param_3 character varying(50) COLLATE pg_catalog."default",
    param_4 character varying(50) COLLATE pg_catalog."default",
    file_name character varying(100) COLLATE pg_catalog."default",
    file_ext character varying(10) COLLATE pg_catalog."default",
    has_date boolean
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE report.tbl_report_param
    OWNER to finadmin;

GRANT SELECT ON TABLE report.tbl_report_param TO billing_user;

GRANT ALL ON TABLE report.tbl_report_param TO finadmin;

GRANT SELECT ON TABLE report.tbl_report_param TO finance_readonly;

GRANT SELECT ON TABLE report.tbl_report_param TO finance_user;

GRANT SELECT, DELETE, TRUNCATE, UPDATE, INSERT ON TABLE report.tbl_report_param TO report_user;