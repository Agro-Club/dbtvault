Feature: [RTS] Record Tracking Satellites

Scenario: [RTS-01] Load data into a non-existent record tracking satellite
    Given the RECORD TRACKING SATELLITE table does not exist
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
    When I load the RECORD TRACKING SATELLITE sat
    Then the RECORD TRACKING SATELLITE table should contain expected data
      | H_KEY     | LDTS        | RSRC | STATUS |
      | md5(1001) |  1993-01-01 | *    | I ??     |
      | md5(1002) | 1993-01-01  | *    | I      |
      | md5(1003) | 1993-01-01  | *    | I      |
      | md5(1004) | 1993-01-01  | *    | I      |


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


Scenario: [RTS-03] Load data with all records deleted
    Given the RECORD TRACKING SATELLITE sat
    And the RAW_STAGE table contains data
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
    Then the RECORD TRACKING SATELLITE table should contain the expected existing records and the new one(s)
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
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1234 | 1993-01-01 | *      |
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
      | md5(1004) | 1993-01-01  | *    | U      |
      | md5(1005) | 1993-01-01  | *    | I      |
      | md5(1006) | 1993-01-01  | *    | I      |
      | md5(1007) | 1993-01-01  | *    | I      |



Scenario: [RTS-07] Load data with multiple records deleted
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
      | md5(1001) |  1993-01-01 | *    | D      |
      | md5(1002) | 1993-01-01  | *    | D      |
      | md5(1003) | 1993-01-01  | *    | U      |
      | md5(1004) | 1993-01-01  | *    | U      |
      | md5(1005) | 1993-01-01  | *    | I      |
      | md5(1006) | 1993-01-01  | *    | I      |
      | md5(1007) | 1993-01-01  | *    | I      |





