{%- macro rts(src_pk, src_ldts, src_source, src_hashdiff, source_model) -%}
    {{- adapter.dispatch('rts', 'dbtvault')(src_pk=src_pk,
                                            src_ldts=src_ldts,
                                            src_source=src_source,
                                            src_hashdiff=src_hashdiff,
                                            source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__rts(src_pk, src_ldts, src_source, src_hashdiff, source_model) -%}

{%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_names(src_source) -%}
{%- set src_hashdiff = dbtvault.escape_column_names(src_hashdiff) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif %}

{{ 'WITH ' }}

records_to_insert AS (
    SELECT DISTINCT
    CUSTOMER_PK,
    LOAD_DATE,
    "SOURCE",
    MD5(LOAD_DATE) AS HASHDIFF
    FROM DBTVAULT_DEV.TEST_CARL_BOYCE.RTS_SEED       --this should be stg_customer

    {%- if dbtvault.is_vault_insert_by_period() or is_incremental() %}

    WHERE NOT EXISTS
    (SELECT 1
    FROM
    (SELECT CUSTOMER_PK,
            HASHDIFF,
            ROW_NUMBER() OVER
    (PARTITION BY CUSTOMER_PK
    ORDER BY LOAD_DATE) AS DV_RNK
    FROM  DBTVAULT_DEV.TEST_CARL_BOYCE.RTS
    QUALIFY DV_RNK = 1) CUR
    WHERE CUSTOMER_PK = CUR.CUSTOMER_PK
    AND HASHDIFF = CUR.HASHDIFF)

    {%- endif %}

)

SELECT * FROM records_to_insert

{%- endmacro -%}