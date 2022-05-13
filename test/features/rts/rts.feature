Feature: [RTS] Record Tracking Satellites

  Scenario: [RTS-01] Load data into a non-existent record tracking satellite
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RECORD TRACKING SATELLITE table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |



  Scenario: [RTS-02] Load one stage of records into an empty single satellite RTS
    Given the RTS rts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the XTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |


Scenario: [RTS-03] Load duplicated data in one stage into a non-existent single satellite RTS
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |


  Scenario: [RTS-04] Load duplicated data in one stage into a non-existent single satellite RTS
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |

  Scenario: [RTS-05] Loads records from a single stage to an RTS linked to two satellites.
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the RTS_2SAT rts is empty
    Given the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the   RTS_2SAT rts
    Then the RTS_2SAT table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |



  Scenario: [RTS-06] Loads from a single stage to an RTS linked to two satellites with repeating records in the first satellite
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the RTS_2SAT rts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the RTS_2SAT rts
    Then the XTS_2SAT table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |


  Scenario: [RTS-07] Loads data from a single stage to an RTS linked to two satellites with repeating records in the second satellite
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the RTS_2SAT rts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the RTS_2SAT rts
    Then the RTS_2SAT table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |


  Scenario: [RTS-08] Loads from a single stage to an RTS linked to two satellites with repeating records in the both satellites
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the RTS_2SAT rts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1002        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |

    And I stage the STG_CUSTOMER_2SAT data
    When I load the RTS_2SAT rts
    Then the XTS_2SAT table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |



  Scenario: [RTS-09] Loads records from a single stage to an RTS linked to three satellites
    Given I have an empty RAW_STAGE_3SAT raw stage
    And I have an empty STG_CUSTOMER_3SAT primed stage
    And the RTS_3SAT rts is empty
    And the RAW_STAGE_3SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_3SAT data
    When I load the XTS_3SAT xts
    Then the XTS_3SAT table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME              | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER          | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER          | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER          | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER          | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_DETAILS  | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER_DETAILS  | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER_DETAILS  | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER_DETAILS  | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_LOCATION | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER_LOCATION | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER_LOCATION | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER_LOCATION | *    |  1         |


  Scenario: [RTS-10] Loads data from two simultaneous stages in an RTS accepting feeds to a single satellite
  Given the RTS rts is empty
  And the RAW_STAGE_1 table contains data
    | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
    | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
    | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
    | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
  And I stage the STG_CUSTOMER_1 data
  And the RAW_STAGE_2 table contains data
    | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
    | 1005        | Edward        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    | 1006        | Fred          | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
    | 1007        | George        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
    | 1008        | Heather       | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
  And I stage the STG_CUSTOMER_2 data
  When I load the RTS rts
  Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1005') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1006') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1007') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1008') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |


  Scenario: [RTS-11] Loads from two stages each containing feeds to one satellite with repeats between stages
    Given the RTS rts is empty
    And the RAW_STAGE_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_1 data
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1006        | Fred          | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1008        | Heather       | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2 data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1006') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1008') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |

  Scenario: [RTS-12] Loads from two stages each containing feeds to one satellite with repeated records in the first stage
    Given the RTS rts is empty
    And the RAW_STAGE_1 table contains data
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_1 data
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1005        | Edward        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1006        | Fred          | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1007        | George        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1008        | Heather       | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2 data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1005') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1006') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1007') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1008') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |


  Scenario: [RTS-13] Loads from numerous stages each containing feeds to one satellite with repeated records in both stages
    Given the RTS rts is empty
    And the RAW_STAGE_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_1 data
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1006        | Fred          | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1007        | George        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2 data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1006') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1007') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |



  Scenario: [RTS-14] Loads from numerous stages each containing feeds to multiple satellites
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the RTS_2SAT rts is empty
    And the RAW_STAGE_2SAT_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT_1 data
    And the RAW_STAGE_2SAT_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1005        | Edward        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1006        | Fred          | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1007        | George        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1008        | Heather       | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT_2 data
    When I load the RTS_2SAT rts
    Then the RTS_2SAT table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1005') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1006') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1007') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1008') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1005') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1006') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1007') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1008') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |


  Scenario: [RTS-15] Null unique identifier values are not loaded into an empty existing RTS
    Given the RTS rts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | null        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |



  Scenario: [RTS-16] Null unique identifier values are not loaded into a non-existent RTS
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | null        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |


  Scenario: [RTS-17] Load record into a pre-populated XTS
    Given the RTS rts is already populated with data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |

##############################ARE THESE RELEVANT?/

  Scenario: [RTS-02] load data with record deleted
    Given the RECORD TRACKING SATELLITE sat exists
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |


    And I stage the STG_CUSTOMER data
    When I load the RECORD TRACKING SATELLITE sat
    Then the RECORD TRACKING SATELLITE table should contain expected data
      | H_KEY     | LDTS        | RSRC | STATUS |
      | md5(1001) |  1993-01-01 | *    | I      |
      | md5(1002) | 1993-01-01  | *    | I      |
      | md5(1003) | 1993-01-01  | *    | I      |
      | md5(1004) | 1993-01-01  | *    | D      |


Scenario: [RTS-03] Load data from empty stage
    Given the RTS sat exists
    And the RAW_STAGE table contains no data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      |             |               |              |                 |            |        |
      |             |               |              |                 |            |        |
      |             |               |              |                 |            |        |
      |             |               |              |                 |            |        |
      |             |               |              |                 |            |        |
      |             |               |              |                 |            |        |
      |             |               |              |                 |            |        |

    And I stage the STG_CUSTOMER data
    When I load the RECORD TRACKING SATELLITE sat
    Then the RECORD TRACKING SATELLITE table should contain expected data
      | H_KEY     | LDTS        | RSRC | STATUS |
      | md5(1001) |  1993-01-01 | *    | D      |
      | md5(1002) | 1993-01-01  | *    | D      |
      | md5(1003) | 1993-01-01  | *    | D      |
      | md5(1004) | 1993-01-01  | *    | D      |

Scenario: [RTS-04] Load data with new record added
    Given the RECORD TRACKING SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1005        | Dave          | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |

    And I stage the STG_CUSTOMER data
    When I load the RECORD TRACKING SATELLITE sat
    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one
      | H_KEY     | LDTS        | RSRC | STATUS |
      | md5(1001) |  1993-01-01 | *    | D      |
      | md5(1002) | 1993-01-01  | *    | D      |
      | md5(1003) | 1993-01-01  | *    | D      |
      | md5(1004) | 1993-01-01  | *    | D      |
      | md5(1005) | 1993-01-01  | *    | I      |


Scenario: [RTS-05] Load data with multiple records added
    Given the RECORD TRACKING SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1005        | Dave          | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1006        | Boris         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1007        | Sarah         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |

    And I stage the STG_CUSTOMER data
    When I load the RECORD TRACKING SATELLITE sat
    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
      | H_KEY     | LDTS        | RSRC | STATUS |
      | md5(1001) |  1993-01-01 | *    | D      |
      | md5(1002) | 1993-01-01  | *    | D      |
      | md5(1003) | 1993-01-01  | *    | D      |
      | md5(1004) | 1993-01-01  | *    | D      |
      | md5(1005) | 1993-01-01  | *    | I      |
      | md5(1006) | 1993-01-01  | *    | I      |
      | md5(1007) | 1993-01-01  | *    | I      |


Scenario: [RTS-06] Load data with updated record
    Given the RECORD TRACKING SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |


    And I stage the STG_CUSTOMER data
    When I load the RECORD TRACKING SATELLITE sat
    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
      | H_KEY     | LDTS        | RSRC | STATUS |
      | md5(1001) |  1993-01-01 | *    | I      |
      | md5(1002) | 1993-01-01  | *    | I      |
      | md5(1003) | 1993-01-01  | *    | I      |
      | md5(1004) | 1993-01-01  | *    | U      |
      | md5(1005) | 1993-01-01  | *    | I      |
      | md5(1006) | 1993-01-01  | *    | I      |
      | md5(1007) | 1993-01-01  | *    | I      |



Scenario: [RTS-07] Load data with multiple records updated
    Given the RECORD TRACKING SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1296 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1234 | 1993-01-01 | *      |
      | 1005        | Dave          | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1006        | Boris         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1007        | Sarah         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |

    And I stage the STG_CUSTOMER data
    When I load the RECORD TRACKING SATELLITE sat
    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
      | H_KEY     | LDTS        | RSRC | STATUS |
      | md5(1001) |  1993-01-01 | *    | I      |
      | md5(1002) | 1993-01-01  | *    | I      |
      | md5(1003) | 1993-01-01  | *    | U      |
      | md5(1004) | 1993-01-01  | *    | U      |
      | md5(1005) | 1993-01-01  | *    | I      |
      | md5(1006) | 1993-01-01  | *    | I      |
      | md5(1007) | 1993-01-01  | *    | I      |

Scenario: [RTS-08] Load data with records deleted and updated
    Given the RECORD TRACKING SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1296 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1234 | 1993-01-01 | *      |


    And I stage the STG_CUSTOMER data
    When I load the RECORD TRACKING SATELLITE sat
    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
      | H_KEY     | LDTS        | RSRC | STATUS |
      | md5(1001) |  1993-01-01 | *    | 0      |
      | md5(1002) | 1993-01-01  | *    | 1      |
      | md5(1003) | 1993-01-01  | *    | 1      |
      | md5(1004) | 1993-01-01  | *    | 1      |



