


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
 {%- for src in source_model %}


--  SELECT DISTINCT
--     {{ dbtvault.prefix([src_pk], 's') }},
--      s.{{ src_ldts }},
--      s.{{ src_source }},
--     s.{{ src_hashdiff }} AS HASHDIFF
--     FROM {{ ref(src) }} as s
--
--
--
--     WHERE NOT EXISTS
--     (SELECT 1
--     FROM
--     (SELECT {{ src_pk }},
--             {{ 'HASHDIFF' }},
--             ROW_NUMBER() OVER
--     (PARTITION BY {{ src_pk }}
--     ORDER BY {{ src_ldts }}) AS DV_RNK
--
--         FROM {{ ref(src) }}
--         QUALIFY DV_RNK = 1) CUR
--          WHERE {{ src_pk }} = CUR.{{ src_pk }}
--         AND {{ 'HASHDIFF' }} = CUR.{{ 'HASHDIFF' }})
-- --         AND {{ dbtvault.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}



------------------



y AS (

    SELECT DISTINCT {{ dbtvault.prefix([src_pk], 's') }}, s.{{ src_ldts }}, s.{{ src_source }}, s.{{ src_hashdiff }} AS HASHDIFF




    FROM {{ ref(src) }} as s
        WHERE {{ dbtvault.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}


),

{%- endfor %}

x as (
    SELECT * FROM y
    --          {%- if dbtvault.is_vault_insert_by_period() or is_incremental() %}
    WHERE NOT EXISTS
    (SELECT 1
    FROM
    (SELECT {{ src_pk }},
            {{ 'HASHDIFF' }},
            ROW_NUMBER() OVER
    (PARTITION BY {{ src_pk }}
    ORDER BY {{ src_ldts }}) AS DV_RNK


    FROM DBTVAULT_DEV.TEST_CARL_BOYCE.RTS
    QUALIFY DV_RNK = 1) CUR
    WHERE {{ src_pk }} = CUR.{{ src_pk }}
    AND {{ 'HASHDIFF' }} = CUR.{{ 'HASHDIFF' }})
--     {% endif %}



),

records_to_insert AS (
    select distinct * from x AS a
    {%- if dbtvault.is_vault_insert_by_period() or is_incremental() %}
    LEFT JOIN {{ this }} AS d

        ON a.{{ src_pk }} = d.{{ src_pk }}
    AND (a.{{ 'HASHDIFF' }} = d.{{ 'HASHDIFF' }}

    )
    WHERE {{ dbtvault.prefix(['HASHDIFF'], 'd') }} IS NULL


     {%- endif %}



)



 SELECT * FROM records_to_insert

{%- endmacro -%}

