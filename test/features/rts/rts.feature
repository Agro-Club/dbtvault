Feature: [RTS] Record Tracking Satellites

  @fixture.rts
  Scenario: [RTS-01] Load one stage of records into an empty single satellite RTS
    Given the RTS rts is empty
    | CUSTOMER_PK | LOAD_DATE | SOURCE | HASHDIFF |
    |             |           |        |          |

    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |

  @fixture.rts
  Scenario: [RTS-02] Load one stage of data into a non-existent single satellite RTS
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |

  @fixture.rts
  Scenario: [RTS-03] Load duplicated data in one stage into a non-existent single satellite RTS
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |


  @fixture.rts
  Scenario: [RTS-04] Load duplicated data in one stage into a non-existent single satellite RTS
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |


  @fixture.rts
  Scenario: [RTS-05] Null unique identifier values are not loaded into an empty existing RTS
    Given the RTS rts is empty
    | CUSTOMER_PK | LOAD_DATE | SOURCE | HASHDIFF |
    |             |           |        |          |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |


  @fixture.rts
  Scenario: [RTS-06] Null unique identifier values are not loaded into a non-existent RTS
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |


  @fixture.rts
  Scenario: [RTS-07] Load record into a pre-populated RTS
    Given the RTS rts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1992-12-31') |
      | md5('1002') | 1993-01-01 | *      | md5('1992-12-31') |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1992-12-31') |
      | md5('1002') | 1993-01-01 | *      | md5('1992-12-31') |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |



##############################ARE THESE RELEVANT?/


  Scenario: [RTS-18] load data with record deleted
    Given the RTS rts exists
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |


    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY     | LDTS       | RSRC | STATUS |
      | md5(1001) | 1993-01-01 | *    | I      |
      | md5(1002) | 1993-01-01 | *    | I      |
      | md5(1003) | 1993-01-01 | *    | I      |
      | md5(1004) | 1993-01-01 | *    | D      |
#
#
#  Scenario: [RTS-03] Load data from empty stage
#    Given the RTS rts exists
#    And the RAW_STAGE table contains no data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE | LOAD_DATE | SOURCE |
#      |             |               |              |                |           |        |
#      |             |               |              |                |           |        |
#      |             |               |              |                |           |        |
#      |             |               |              |                |           |        |
#      |             |               |              |                |           |        |
#      |             |               |              |                |           |        |
#      |             |               |              |                |           |        |
#
#    And I stage the STG_CUSTOMER data
#    When I load the RECORD TRACKING SATELLITE sat
#    Then the RECORD TRACKING SATELLITE table should contain expected data
#      | H_KEY     | LDTS       | RSRC | STATUS |
#      | md5(1001) | 1993-01-01 | *    | D      |
#      | md5(1002) | 1993-01-01 | *    | D      |
#      | md5(1003) | 1993-01-01 | *    | D      |
#      | md5(1004) | 1993-01-01 | *    | D      |
#
#  Scenario: [RTS-04] Load data with new record added
#    Given the RTS rts
#    And the RAW_STAGE table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
#      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
#      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#      | 1005        | Dave          | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#
#    And I stage the STG_CUSTOMER data
#    When I load the RECORD TRACKING SATELLITE sat
#    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one
#      | H_KEY     | LDTS       | RSRC | STATUS |
#      | md5(1001) | 1993-01-01 | *    | D      |
#      | md5(1002) | 1993-01-01 | *    | D      |
#      | md5(1003) | 1993-01-01 | *    | D      |
#      | md5(1004) | 1993-01-01 | *    | D      |
#      | md5(1005) | 1993-01-01 | *    | I      |
#
#
#  Scenario: [RTS-05] Load data with multiple records added
#    Given the RECORD TRACKING SATELLITE sat
#    And the RAW_STAGE table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
#      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
#      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#      | 1005        | Dave          | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#      | 1006        | Boris         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#      | 1007        | Sarah         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#
#    And I stage the STG_CUSTOMER data
#    When I load the RECORD TRACKING SATELLITE sat
#    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
#      | H_KEY     | LDTS       | RSRC | STATUS |
#      | md5(1001) | 1993-01-01 | *    | D      |
#      | md5(1002) | 1993-01-01 | *    | D      |
#      | md5(1003) | 1993-01-01 | *    | D      |
#      | md5(1004) | 1993-01-01 | *    | D      |
#      | md5(1005) | 1993-01-01 | *    | I      |
#      | md5(1006) | 1993-01-01 | *    | I      |
#      | md5(1007) | 1993-01-01 | *    | I      |
#
#
#  Scenario: [RTS-06] Load data with updated record
#    Given the RECORD TRACKING SATELLITE sat
#    And the RAW_STAGE table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
#      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
#      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
#      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#
#
#    And I stage the STG_CUSTOMER data
#    When I load the RECORD TRACKING SATELLITE sat
#    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
#      | H_KEY     | LDTS       | RSRC | STATUS |
#      | md5(1001) | 1993-01-01 | *    | I      |
#      | md5(1002) | 1993-01-01 | *    | I      |
#      | md5(1003) | 1993-01-01 | *    | I      |
#      | md5(1004) | 1993-01-01 | *    | U      |
#      | md5(1005) | 1993-01-01 | *    | I      |
#      | md5(1006) | 1993-01-01 | *    | I      |
#      | md5(1007) | 1993-01-01 | *    | I      |
#
#
#  Scenario: [RTS-07] Load data with multiple records updated
#    Given the RECORD TRACKING SATELLITE sat
#    And the RAW_STAGE table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
#      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1003        | Chad          | 2013-02-04   | 17-214-233-1296 | 1993-01-01 | *      |
#      | 1004        | Dom           | 2018-04-13   | 17-214-233-1234 | 1993-01-01 | *      |
#      | 1005        | Dave          | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#      | 1006        | Boris         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#      | 1007        | Sarah         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
#
#    And I stage the STG_CUSTOMER data
#    When I load the RECORD TRACKING SATELLITE sat
#    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
#      | H_KEY     | LDTS       | RSRC | STATUS |
#      | md5(1001) | 1993-01-01 | *    | I      |
#      | md5(1002) | 1993-01-01 | *    | I      |
#      | md5(1003) | 1993-01-01 | *    | U      |
#      | md5(1004) | 1993-01-01 | *    | U      |
#      | md5(1005) | 1993-01-01 | *    | I      |
#      | md5(1006) | 1993-01-01 | *    | I      |
#      | md5(1007) | 1993-01-01 | *    | I      |
#
#  Scenario: [RTS-08] Load data with records deleted and updated
#    Given the RECORD TRACKING SATELLITE sat
#    And the RAW_STAGE table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
#      | 1003        | Chad          | 2013-02-04   | 17-214-233-1296 | 1993-01-01 | *      |
#      | 1004        | Dom           | 2018-04-13   | 17-214-233-1234 | 1993-01-01 | *      |
#
#
#    And I stage the STG_CUSTOMER data
#    When I load the RECORD TRACKING SATELLITE sat
#    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
#      | H_KEY     | LDTS       | RSRC | STATUS |
#      | md5(1001) | 1993-01-01 | *    | 0      |
#      | md5(1002) | 1993-01-01 | *    | 1      |
#      | md5(1003) | 1993-01-01 | *    | 1      |
#      | md5(1004) | 1993-01-01 | *    | 1      |



