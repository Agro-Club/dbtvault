CONCAT_WS('||', "CUSTOMER_NAME", "CUSTOMER DOB", "PHONE", 'WEBSITE') AS "CUSTOMER_DETAILS",
'STG_BOOKING' AS "SOURCE",
LOAD_DATE AS "EFFECTIVE_FROM"