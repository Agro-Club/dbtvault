Feature: [RTS-COMPPK] Record Tracking Satellites with composite PK

  @fixture.rts
  Scenario: [RTS-COMPPK-01] Load one stage of records into an empty single satellite RTS
    Given the RTS_COMPPK rts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS_COMPPK rts
    Then the RTS_COMPPK table should contain expected data
      | CUSTOMER_PK                    | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001\|\|17-214-233-1214') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002\|\|17-214-233-1215') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003\|\|17-214-233-1216') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004\|\|17-214-233-1217') | 1993-01-01 | *      | md5('1993-01-01') |


  @fixture.rts
  Scenario: [RTS-COMPPK-02] Load record into a pre-populated RTS
    Given the RTS_COMPPK rts is already populated with data
      | CUSTOMER_PK | CUSTOMER_PHONE  | LOAD_DATE  | SATELLITE_NAME | RSRC | APPEARANCE |
      | md5('1001') | 17-214-233-1214 | 1992-31-12 | SAT_CUSTOMER   | *    |  1         |
      | md5('1002') | 17-214-233-1215 | 1992-31-12 | SAT_CUSTOMER   | *    |  1         |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS_COMPPK rts
    Then the RTS_COMPPK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_PHONE  | LOAD_DATE  | SATELLITE_NAME | RSRC | APPEARANCE |
      | md5('1001') | 17-214-233-1214 | 1992-12-31 | SAT_CUSTOMER   | *    |  1         |
      | md5('1002') | 17-214-233-1215 | 1992-12-31 | SAT_CUSTOMER   | *    |  1         |
      | md5('1001') | 17-214-233-1214 | 1993-01-01 | SAT_CUSTOMER   | *    |  1         |
      | md5('1002') | 17-214-233-1215 | 1993-01-01 | SAT_CUSTOMER   | *    |  1         |
      | md5('1003') | 17-214-233-1216 | 1993-01-01 | SAT_CUSTOMER   | *    |  1         |
      | md5('1004') | 17-214-233-1217 | 1993-01-01 | SAT_CUSTOMER   | *    |  1         |

  @fixture.rts
  Scenario: [RTS-COMPPK-03] Load record into a pre-populated RTS
    Given the RTS_COMPPK rts is already populated with data
      | CUSTOMER_PK | CUSTOMER_PHONE  | LOAD_DATE  | SATELLITE_NAME | RSRC | APPEARANCE |
      | md5('1001') | 17-214-233-1214 | 1992-12-31 | SAT_CUSTOMER   | *    |  1         |
      | md5('1002') | 17-214-233-1215 | 1992-12-31 | SAT_CUSTOMER   | *    |  1         |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS_COMPPK rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS_COMPPK rts
    Then the RTS_COMPPK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_PHONE  | LOAD_DATE  | SATELLITE_NAME | RSRC | APPEARANCE |
      | md5('1001') | 17-214-233-1214 | 1992-12-31 | SAT_CUSTOMER   | *    |  1         |
      | md5('1002') | 17-214-233-1215 | 1992-12-31 | SAT_CUSTOMER   | *    |  1         |
      | md5('1001') | 17-214-233-1214 | 1993-01-01 | SAT_CUSTOMER   | *    |  1         |
      | md5('1002') | 17-214-233-1215 | 1993-01-01 | SAT_CUSTOMER   | *    |  1         |
      | md5('1003') | 17-214-233-1216 | 1993-01-02 | SAT_CUSTOMER   | *    |  1         |
      | md5('1004') | 17-214-233-1217 | 1993-01-02 | SAT_CUSTOMER   | *    |  1         |