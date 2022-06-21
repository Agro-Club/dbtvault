Feature: [RTS] Record Tracking Satellites


    @fixture.rts
  Scenario: [RTS-01] Load one stage of records into an empty single satellite RTS
    Given the RTS rts is empty
    | CUSTOMER_PK | LOAD_DATE | SOURCE |
    |             |           |        |

    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      | md5('1001') | 1993-01-01 | *      |
      | md5('1002') | 1993-01-01 | *      |
      | md5('1003') | 1993-01-01 | *      |
      | md5('1004') | 1993-01-01 | *      |

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
      | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      | md5('1001') | 1993-01-01 | *      |
      | md5('1002') | 1993-01-01 | *      |
      | md5('1003') | 1993-01-01 | *      |
      | md5('1004') | 1993-01-01 | *      |

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
      | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      | md5('1001') | 1993-01-01 | *      |


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
      | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      | md5('1001') | 1993-01-01 | *      |
      | md5('1002') | 1993-01-01 | *      |
      | md5('1003') | 1993-01-01 | *      |
      | md5('1004') | 1993-01-01 | *      |


  @fixture.rts
  Scenario: [RTS-05] Null unique identifier values are not loaded into an empty existing RTS
    Given the RTS rts is empty
    | CUSTOMER_PK | LOAD_DATE | SOURCE |
    |             |           |        |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      | md5('1002') | 1993-01-01 | *      |
      | md5('1003') | 1993-01-01 | *      |
      | md5('1004') | 1993-01-01 | *      |


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
      | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      | md5('1002') | 1993-01-01 | *      |
      | md5('1003') | 1993-01-01 | *      |
      | md5('1004') | 1993-01-01 | *      |


  @fixture.rts
  Scenario: [RTS-07] Load record into a pre-populated RTS
    Given the RTS rts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      | md5('1001') | 1993-01-01 | *      |
      | md5('1002') | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      | md5('1001') | 1993-01-01 | *      |
      | md5('1002') | 1993-01-01 | *      |
      | md5('1001') | 1993-01-01 | *      |
      | md5('1002') | 1993-01-01 | *      |
      | md5('1003') | 1993-01-01 | *      |
      | md5('1004') | 1993-01-01 | *      |














