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
    s.{{ src_pk }},
    s.{{ src_ldts }},
    s.{{ src_source }},
    s.{{ src_hashdiff }} as HASHDIFF
    FROM {{ ref('STG_CUSTOMER') }} as s       --this should be stg_customer?       DBTVAULT_DEV.TEST_CARL_BOYCE.STG_CUSTOMER

    {%- if dbtvault.is_vault_insert_by_period() or is_incremental() %}

    WHERE NOT EXISTS
    (SELECT 1
    FROM
    (SELECT {{ src_pk }},
            {{ 'HASHDIFF' }},
            ROW_NUMBER() OVER
    (PARTITION BY {{ src_pk }}
    ORDER BY {{ src_ldts }}) AS DV_RNK
    FROM  {{ ref('RTS') }}
    QUALIFY DV_RNK = 1) CUR
    WHERE s.{{ src_pk }} = CUR.{{ src_pk }}
    AND s.{{ 'HASHDIFF' }} = CUR.{{ 'HASHDIFF' }})

    {%- endif %}

)

SELECT * FROM records_to_insert

{%- endmacro -%}