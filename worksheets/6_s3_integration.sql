
-- AWS IAM policy template:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject",
              "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::my-storage/staging/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "arn:aws:s3:::my-storage"
        }
    ]
}

-- AWS IAM role template:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "<STORAGE_AWS_IAM_USE_ARN>"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<STORAGE_AWS_EXTERNAL_ID>"
        }
      }
    }
  ]
}


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

list @s3stage;

copy into s3table
  from @s3stage;

remove @s3stage;

show tables;
