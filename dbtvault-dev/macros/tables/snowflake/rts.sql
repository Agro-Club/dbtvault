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
{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_ldts, src_source, src_hashdiff]) -%}


{{ dbtvault.prepend_generated_by() }}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif %}

{{ 'WITH ' }}
{%- for src in source_model %}

y AS (
    SELECT DISTINCT {{ dbtvault.prefix([src_pk], 's') }},
                    s.{{ src_ldts }},
                    s.{{ src_source }},
                    s.{{ src_hashdiff }}
    FROM {{ ref(src) }} as s
    WHERE {{ dbtvault.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}
),

{%- endfor %}

x as (
    SELECT * FROM y

    {%- if is_any_incremental() %}

    WHERE NOT EXISTS (
        SELECT 1
        FROM (
            SELECT {{ src_pk }}, {{ src_hashdiff }},
            ROW_NUMBER() OVER(
                PARTITION BY {{ src_pk }}
                ORDER BY {{ src_ldts }}
            ) AS DV_RNK
            FROM {{ this }}
            QUALIFY DV_RNK = 1
        ) AS cur
    WHERE {{ src_pk }} = cur.{{ src_pk }}
    AND {{ src_hashdiff }} = cur.{{ src_hashdiff }})

    {% endif %}
),

records_to_insert AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM y AS a

    {%- if is_any_incremental() %}

    LEFT JOIN {{ this }} AS d
    ON a.{{ src_pk }} = d.{{ src_pk }}
    AND a.{{ src_hashdiff }} = d.{{ src_hashdiff }}
    WHERE a.{{ src_pk }} = d.{{ src_pk }}
    AND a.{{ src_hashdiff }} = d.{{ src_hashdiff }}

    {% endif %}

)

SELECT * FROM x

{%- endmacro -%}

