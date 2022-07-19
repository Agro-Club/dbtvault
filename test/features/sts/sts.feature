Feature: [STS] Status Tracking Satellites

  @fixture.sts
  Scenario: [STS-01] Load data into a non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |

  @fixture.sts
  Scenario: [STS-02] Load duplicated data into a non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |

  @fixture.sts
  Scenario: [STS-03] Load data with NULLs into a non-existent status tracking satellite
    Given the STS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | <null>      | <null>        | <null>     | *      |
      | <null>      | <null>        | 1993-01-01 | *      |
      | 1004        | <null>        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1004') | 1993-01-01 | *      | I      | md5('I')        |

  @fixture.sts
  Scenario: [STS-04] Load data into an empty status tracking satellite
    Given the STS sts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |

  @fixture.sts
  Scenario: [STS-05] Load duplicated data into an empty status tracking satellite
    Given the STS sts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |

  @fixture.sts
  Scenario: [STS-06] Load data with NULLs into an empty status tracking satellite
    Given the STS sts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | *      |
      | 1002        | Bob           | 1993-01-01 | *      |
      | 1003        | Chad          | 1993-01-01 | *      |
      | <null>      | <null>        | <null>     | *      |
      | <null>      | <null>        | 1993-01-01 | *      |
      | 1004        | <null>        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1004') | 1993-01-01 | *      | I      | md5('I')        |

  @fixture.sts
  Scenario: [STS-07] Load data into a populated status tracking satellite
    Given the STS sts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1002        | Bob           | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1001') | 1993-01-03 | *      | D      | md5('D')        |
      | md5('1002') | 1993-01-03 | *      | U      | md5('U')        |
      | md5('1003') | 1993-01-03 | *      | U      | md5('U')        |

  @fixture.sts
  Scenario: [STS-08] Load duplicated data into a populated status tracking satellite
    Given the STS sts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1002        | Bob           | 1993-01-03 | *      |
      | 1002        | Bob           | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1001') | 1993-01-03 | *      | D      | md5('D')        |
      | md5('1002') | 1993-01-03 | *      | U      | md5('U')        |
      | md5('1003') | 1993-01-03 | *      | U      | md5('U')        |

  @fixture.sts
  Scenario: [STS-09] Load data with NULLs into a populated status tracking satellite
    Given the STS sts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS |
      | md5('1001') | 1993-01-01 | *      | I      |
      | md5('1002') | 1993-01-01 | *      | I      |
      | md5('1003') | 1993-01-01 | *      | I      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1002        | Bob           | 1993-01-03 | *      |
      | 1002        | Bob           | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
      | 1003        | Chaz          | 1993-01-03 | *      |
      | <null>      | <null>        | <null>     | *      |
      | <null>      | <null>        | 1993-01-03 | *      |
      | 1004        | <null>        | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the STS sts
    Then the STS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | STATUS | STATUS_HASHDIFF |
      | md5('1001') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1002') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1003') | 1993-01-01 | *      | I      | md5('I')        |
      | md5('1001') | 1993-01-03 | *      | D      | md5('D')        |
      | md5('1002') | 1993-01-03 | *      | U      | md5('U')        |
      | md5('1003') | 1993-01-03 | *      | U      | md5('U')        |
      | md5('1004') | 1993-01-03 | *      | I      | md5('I')        |
