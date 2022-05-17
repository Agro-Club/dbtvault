{%- macro rts(src_pk, src_satellite, src_ldts, src_source, source_model) -%}
    {{- adapter.dispatch('rts', 'dbtvault')(src_pk=src_pk,
                                            src_satellite=src_satellite,
                                            src_ldts=src_ldts,
                                            src_source=src_source,
                                            source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__rts(src_pk, src_satellite, src_ldts, src_source, source_model) -%}

{%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_names(src_source) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif %}

{{ 'WITH ' }}


records_to_insert AS (
       SELECT DISTINCT * FROM DBTVAULT_DEV.TEST_CARL_BOYCE.RTS_SEED
--     SELECT
--     SATELLITE_NAME,
--     CUSTOMER_PK,
--     LOAD_DATE,
--     "SOURCE"
-- --
-- --
--       FROM DBTVAULT_DEV.TEST_CARL_BOYCE.RTS_SEED t1
-- --     LEFT outer JOIN DBTVAULT_DEV.TEST_CARL_BOYCE.RTS t2
-- --     ON (
-- --         t1."LOAD_DATE" = t2."LOAD_DATE"
-- --         AND t1.SATELLITE_NAME = t2.SATELLITE_NAME
-- --
-- --     )
-- --       {%- if dbtvault.is_vault_insert_by_period() or is_incremental() %}
--   LEFT outer JOIN DBTVAULT_DEV.TEST_CARL_BOYCE.RTS t2
--     ON (
--         t1."LOAD_DATE" = t2."LOAD_DATE"
--         AND t1.SATELLITE_NAME = t2.SATELLITE_NAME
--
--     )


    {%- endif %}
)



SELECT * FROM records_to_insert

{%- endmacro -%}