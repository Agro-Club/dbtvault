Feature: [RTS-INC] Record Tracking Satellites

  @fixture.rts
  Scenario: [RTS-INC-01] Load multiple subsequent stages into a single stage RTS with no timeline change
    Given the RTS rts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1001') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1002') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1003') | 1993-01-03 | *      | md5('1993-01-03') |


  @fixture.rts
  Scenario: [RTS-INC-02] Null unique identifier values are not loaded into an pre-populated RTS
    Given the RTS rts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1002') | 1992-12-31 | *      | md5('1992-12-31') |
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
      | md5('1001') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1002') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |

  @fixture.rts
  Scenario: [RTS-INC-03] Subsequent loads with no timeline change into a pre-populated RTS
    Given the RTS rts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1000') | 1992-12-31 | *      | md5('1992-12-31') |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1000        | Zak                | Zon               | 1992-12-25   | 17-214-233-1234 | Cambridgeshire  | Cambridge     | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1000        | Zak                | Zon               | 1992-12-25   | 17-214-233-1234 | Cambridgeshire  | Cambridge     | 1993-01-02 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |

    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-03 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-03 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |

    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1000') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1000') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1000') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1001') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1002') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1001') | 1993-01-03 | *      | md5('1993-01-03') |
      | md5('1002') | 1993-01-03 | *      | md5('1993-01-03') |
      | md5('1003') | 1993-01-03 | *      | md5('1993-01-03') |






  @fixture.rts
  Scenario: [RTS-INC-04] Load mixed stage + empty into non existent RTS - one cycle
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |

  @fixture.rts
  Scenario: [RTS-INC-05] Load mixed stages into non existent RTS - two cycles
    Given the RTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-02 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-03 | *      |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-03 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-03 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-03 | *      |
      | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-03 | *      |
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1003') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1004') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1005') | 1993-01-03 | *      | md5('1993-01-03') |
      | md5('1006') | 1993-01-03 | *      | md5('1993-01-03') |
      | md5('1007') | 1993-01-03 | *      | md5('1993-01-03') |
      | md5('1008') | 1993-01-03 | *      | md5('1993-01-03') |
      | md5('1009') | 1993-01-03 | *      | md5('1993-01-03') |



  @fixture.rts
  Scenario: [RTS-INC-06] Load mixed stage + empty stage into empty RTS - two cycles
    Given I have an empty RAW_STAGE raw stage
    And I have an empty STG_CUSTOMER primed stage
    And the RTS rts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1002') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |



#7 not passing just yet

  @fixture.rts
  Scenario: [RTS-INC-07] Load mixed stage + empty stage into a pre-populated RTS - two cycles
    Given the RTS rts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1002') | 1993-12-31 | *      | md5('1992-12-31') |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1218 | Hampshire       | Southampton   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-02 | *      |
      | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1002') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1005') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1006') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1007') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1008') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1009') | 1993-01-02 | *      | md5('1993-01-02') |


  @fixture.rts
  Scenario: [RTS-INC-08] (1 SAT) Load mixed stages into a pre-populated RTS - two cycles
    Given the RTS rts is already populated with data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1002') | 1993-12-31 | *      | md5('1992-12-31') |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1218 | Hampshire       | Southampton   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the RTS rts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-02 | *      |
      | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the RTS rts
    Then the RTS table should contain expected data
      | CUSTOMER_PK | LOAD_DATE  | SOURCE | HASHDIFF          |
      | md5('1001') | 1992-12-31 | *      | md5('1992-12-31') |
      | md5('1002') | 1993-12-31 | *      | md5('1992-12-31') |
      | md5('1003') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1004') | 1993-01-01 | *      | md5('1993-01-01') |
      | md5('1005') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1006') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1007') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1008') | 1993-01-02 | *      | md5('1993-01-02') |
      | md5('1009') | 1993-01-02 | *      | md5('1993-01-02') |




















