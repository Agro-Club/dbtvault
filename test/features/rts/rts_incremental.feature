Feature: [RTS-INC] Record Tracking Satellites

  Scenario: [RTS-INC-01] Load multiple subsequent stages into a single stage XTS with no timeline change
    Given the RTS rts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1993-01-02  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-02  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-03  | SAT_CUSTOMER | *    |  1         |


  Scenario: [RTS-INC-02] Load duplicated data into a pre-populated XTS
    Given the RTS rts is already populated with data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1992-12-31 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |


  Scenario: [RTS-INC-03] Subsequent loads with no timeline change into a pre-populated RTS
    Given the RTS rts is already populated with data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1000') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | md5('1000') | Zack          | 1992-12-25   | 17-214-233-1234 | 1993-01-01 | *      |
      | md5('1001') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |

    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | md5('1000') | Zack          | 1992-12-25   | 17-214-233-1234 | 1993-01-02 | *      |
      | md5('1001') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | md5('1001') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | md5('1001') | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |

    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | md5('1002') | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | md5('1003') | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
      | md5('1003') | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |

    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the XTS table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1000') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1000') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1000') | 1993-01-02  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1993-01-02  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-02  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1993-01-03  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-03  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-03  | SAT_CUSTOMER | *    |  1         |



  Scenario: [XTS-INC-04] Loads from a single stage to multiple satellites and a pre-populated xts
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the RTS_2SAT rts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1997-04-24   | 17-214-233-1214 | 1992-12-31 | *      |
      | md5('1002') | Bob           | 2006-04-17   | 17-214-233-1215 | 1992-12-31 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the RTS_2SAT rts
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | md5('1002') | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | md5('1003') | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | md5('1004') | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | md5('1004') | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the RTS_2SAT rts
    Then the RTS_2SAT table should contain expected data
      | H_KEY       | LDTS        | SAT_NAME             | RSRC | APPEARANCE |
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER         | *    |  1         |
      | md5('1002') | 1992-12-31  | SAT_CUSTOMER         | *    |  1         |
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1002') | 1992-12-31  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER         | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER_DETAILS | *    |  1         |




  Scenario: [RTS-INC-05] Loads from numerous stages each containing feeds to one satellite and a pre-populated rts
    Given the RTS rts is already populated with data
      | H_KEY       | LDTS        | SAT_NAME     | RSRC | APPEARANCE |
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |

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
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1992-12-31  | SAT_CUSTOMER | *    |  1         |
      | md5('1001') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1002') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1003') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1004') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1005') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1006') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1007') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |
      | md5('1008') | 1993-01-01  | SAT_CUSTOMER | *    |  1         |




  Scenario: [RTS-INC-06] Loads from numerous stages each containing feeds to multiple satellites and a pre-populated rts
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the RTS_2SAT rts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1992-12-31 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the RTS_2SAT rts
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
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER         | *    |  1         |
      | md5('1001') | 1992-12-31  | SAT_CUSTOMER_DETAILS | *    |  1         |
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
