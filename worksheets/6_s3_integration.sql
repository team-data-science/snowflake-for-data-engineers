
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

-- AWS IAM role trust relationship policy template:
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

-- create the storage integration for s3
CREATE STORAGE INTEGRATION s3_storage_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::429105704208:role/snowflake_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://my-snowflake-store/staging/');

-- to see the commando worked
DESC INTEGRATION s3_storage_integration;

-- create the s3 stage
create or replace stage s3stage
  url = 's3://my-snowflake-store/staging/'
  file_format = ECOMMERCECSVFORMAT
  storage_integration = s3_storage_integration;

-- create the new internal table
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

--list all files in the s3 stage
list @s3stage;

-- before you copy data into the table you can also read directly from the stage with the following select statement
-- I didn't include this in the video, but it's super nice to have. This way you don't have to copy data into Snowflake first
SELECT t.$1 as INVOICENO, t.$2 as STOCKCODE, t.$3 as DESCRIPTION
from @S3STAGE (file_format => 'ECOMMERCECSVFORMAT') t;


-- copy staged data into table
copy into s3table
  from @s3stage;


-- this is how you can remove a stage
remove @s3stage;

show tables;
