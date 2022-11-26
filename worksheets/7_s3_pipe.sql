create or replace TABLE ECOMMERCEDATA.ECOMMERCE.S3TABLE (
	INVOICENO VARCHAR(38),
	STOCKCODE VARCHAR(38),
	DESCRIPTION VARCHAR(60),
	QUANTITY NUMBER(38,0),
	INVOICEDATE TIMESTAMP,
	UNITPRICE NUMBER(38,0),
	CUSTOMERID VARCHAR(10),
	COUNTRY VARCHAR(20)
);

show TABLES;

create or replace pipe ECOMMERCEDATA.ECOMMERCE.S3_pipe auto_ingest=true 
as copy into ECOMMERCEDATA.ECOMMERCE.S3table   
from @s3stage;

show pipes

select system$pipe_status('ecommercedata.ecommerce.s3_pipe');