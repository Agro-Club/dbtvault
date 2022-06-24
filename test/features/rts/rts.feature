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
  Scenario: [RTS-04] Load duplicated data in one stage into a non-existent single satellite RTS with multiple records
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

  # TODO: Check, do we track NULLS or not? Case for hashdiff?
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

  # TODO: Check, do we track NULLS or not? Case for hashdiff?
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



    @fixture.rts
    Scenario: [RTS-08] load duplicate records over consecutive days
      Given the RTS rts is already populated with data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | *      |
        | md5('1002') | 1992-12-31 | *      |
      And the RAW_STAGE table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
        | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
        | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
        | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |

      And I stage the STG_CUSTOMER data
      And I load the RTS rts
      And the RAW_STAGE table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
        | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
        | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-02 | *      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-02 | *      |
      And I stage the STG_CUSTOMER data
      When I load the RTS rts
      Then the RTS table should contain expected data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | *      |
        | md5('1002') | 1992-12-31 | *      |
        | md5('1001') | 1993-01-01 | *      |
        | md5('1002') | 1993-01-01 | *      |
        | md5('1003') | 1993-01-01 | *      |
        | md5('1004') | 1993-01-01 | *      |
        | md5('1001') | 1993-01-02 | *      |
        | md5('1002') | 1993-01-02 | *      |
        | md5('1003') | 1993-01-02 | *      |
        | md5('1004') | 1993-01-02 | *      |

  @fixture.rts
    Scenario: [RTS-09] load RTS with record removed from the stage
      Given the RTS rts is already populated with data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | *      |
        | md5('1002') | 1992-12-31 | *      |
      And the RAW_STAGE table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |


      And I stage the STG_CUSTOMER data
      And I load the RTS rts
      And the RAW_STAGE table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |

      And I stage the STG_CUSTOMER data
      When I load the RTS rts
      Then the RTS table should contain expected data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | *      |
        | md5('1002') | 1992-12-31 | *      |
        | md5('1002') | 1993-01-01 | *      |
        | md5('1003') | 1993-01-02 | *      |

    @fixture.rts
    Scenario: [RTS-10] load empty RTS from multiple stages
      Given the RTS rts is empty
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      And the RAW_STAGE table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1992-12-31 | A      |
        | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1992-12-31 | A      |
        | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1992-12-31 | A      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1992-12-31 | A      |
      And I stage the STG_CUSTOMER data
      And I load the RTS rts
      And the RAW_STAGE_1 table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-01 | B      |
        | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-01 | B      |
        | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-01 | B      |
        | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-01 | B      |
      And I stage the STG_CUSTOMER_1 data
      And I load the RTS rts
      And the RAW_STAGE_2 table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | C      |
      And I stage the STG_CUSTOMER_2 data
      When I load the RTS rts
      Then the RTS table should contain expected data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | A      |
        | md5('1002') | 1992-12-31 | A      |
        | md5('1003') | 1992-12-31 | A      |
        | md5('1004') | 1992-12-31 | A      |
        | md5('1005') | 1993-01-01 | B      |
        | md5('1006') | 1993-01-01 | B      |
        | md5('1007') | 1993-01-01 | B      |
        | md5('1008') | 1993-01-01 | B      |
        | md5('1009') | 1993-01-02 | C      |

    @fixture.rts
    Scenario: [RTS-11] load non-empty RTS from multiple stages
      Given the RTS rts is already populated with data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | A      |
        | md5('1002') | 1992-12-31 | A      |
      And the RAW_STAGE table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1992-12-31 | A      |
        | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1992-12-31 | A      |
        | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1992-12-31 | A      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1992-12-31 | A      |
      And I stage the STG_CUSTOMER data
      And I load the RTS rts
      And the RAW_STAGE_1 table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-01 | B      |
        | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-01 | B      |
        | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-01 | B      |
        | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-01 | B      |
      And I stage the STG_CUSTOMER_1 data
      And I load the RTS rts
      And the RAW_STAGE_2 table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | C      |
      And I stage the STG_CUSTOMER_2 data
      When I load the RTS rts
      Then the RTS table should contain expected data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | A      |
        | md5('1002') | 1992-12-31 | A      |
        | md5('1001') | 1992-12-31 | A      |
        | md5('1002') | 1992-12-31 | A      |
        | md5('1003') | 1992-12-31 | A      |
        | md5('1004') | 1992-12-31 | A      |
        | md5('1005') | 1993-01-01 | B      |
        | md5('1006') | 1993-01-01 | B      |
        | md5('1007') | 1993-01-01 | B      |
        | md5('1008') | 1993-01-01 | B      |
        | md5('1009') | 1993-01-02 | C      |


  @fixture.rts
    Scenario: [RTS-12] load empty RTS from multiple stages with dupes and null values
      Given the RTS rts is already populated with data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
      And the RAW_STAGE table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1992-12-31 | A      |
        | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1992-12-31 | A      |
        | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1992-12-31 | A      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1992-12-31 | A      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1992-12-31 | A      |
      And I stage the STG_CUSTOMER data
      And I load the RTS rts
      And the RAW_STAGE_1 table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | <null>      | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-01 | B      |
        | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-01 | B      |
        | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-01 | B      |
        | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-01 | B      |

      And I stage the STG_CUSTOMER_1 data
      And I load the RTS rts
      And the RAW_STAGE_2 table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | C      |
      And I stage the STG_CUSTOMER_2 data
      When I load the RTS rts
      Then the RTS table should contain expected data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | A      |
        | md5('1002') | 1992-12-31 | A      |
        | md5('1003') | 1992-12-31 | A      |
        | md5('1004') | 1992-12-31 | A      |
        | md5('1006') | 1993-01-01 | B      |
        | md5('1007') | 1993-01-01 | B      |
        | md5('1008') | 1993-01-01 | B      |
        | md5('1009') | 1993-01-02 | C      |

    @fixture.rts
    Scenario: [RTS-13] Load non-empty RTS from multiple stages with dupes and null values
      Given the RTS rts is already populated with data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | A      |
        | md5('1002') | 1992-12-31 | A      |
      And the RAW_STAGE table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1992-12-31 | A      |
        | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1992-12-31 | A      |
        | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1992-12-31 | A      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1992-12-31 | A      |
        | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1992-12-31 | A      |
      And I stage the STG_CUSTOMER data
      And I load the RTS rts
      And the RAW_STAGE_1 table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | <null>      | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-01 | B      |
        | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-01 | B      |
        | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-01 | B      |
        | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-01 | B      |

      And I stage the STG_CUSTOMER_1 data
      And I load the RTS rts
      And the RAW_STAGE_2 table contains data
        | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
        | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | C      |
      And I stage the STG_CUSTOMER_2 data
      When I load the RTS rts
      Then the RTS table should contain expected data
        | CUSTOMER_PK | LOAD_DATE  | SOURCE |
        | md5('1001') | 1992-12-31 | A      |
        | md5('1002') | 1992-12-31 | A      |
        | md5('1001') | 1992-12-31 | A      |
        | md5('1002') | 1992-12-31 | A      |
        | md5('1003') | 1992-12-31 | A      |
        | md5('1004') | 1992-12-31 | A      |
        | md5('1006') | 1993-01-01 | B      |
        | md5('1007') | 1993-01-01 | B      |
        | md5('1008') | 1993-01-01 | B      |
        | md5('1009') | 1993-01-02 | C      |


