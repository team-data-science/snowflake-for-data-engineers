CREATE STORAGE INTEGRATION s3_storage_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::429105704208:role/snowflake_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://my-snowflake-store/staging/');

-- to see the commando worked
DESC INTEGRATION s3_storage_integration;


create or replace stage s3stage
  url = 's3://my-snowflake-store/staging/'
  file_format = ECOMMERCECSVFORMAT
  storage_integration = s3_storage_integration;


create or replace TABLE TESTDB.ECOMMERCE.S3TABLE (
	INVOICENO VARCHAR(38),
	STOCKCODE VARCHAR(38),
	DESCRIPTION VARCHAR(60),
	QUANTITY NUMBER(38,0),
	INVOICEDATE TIMESTAMP,
	UNITPRICE NUMBER(38,0),
	CUSTOMERID VARCHAR(10),
	COUNTRY VARCHAR(20)
);


copy into s3table
  from @s3stage;


show tables;
