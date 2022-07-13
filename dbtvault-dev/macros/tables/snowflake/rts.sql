{%- macro rts(src_pk, src_ldts, src_source, source_model) -%}
    {{- adapter.dispatch('rts', 'dbtvault')(src_pk=src_pk,
                                            src_ldts=src_ldts,
                                            src_source=src_source,
                                            source_model=source_model) -}}
{%- endmacro -%}


{%- macro default__rts(src_pk, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_ldts=src_ldts,
                                       src_source=src_source,
                                       source_model=source_model) -}}

{%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_names(src_source) -%}
{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_ldts, src_source]) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif %}

{{ 'WITH ' }}

{%- for src in source_model %}

get_cols AS (
    SELECT DISTINCT
        {{ dbtvault.prefix([src_pk], 's') }},
        s.{{ src_ldts }},
        s.{{ src_source }}
    FROM {{ ref(src) }} as s
    WHERE {{ dbtvault.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}
),

{%- endfor %}

union_columns AS (
    SELECT
        {{ src_pk }},
        {{ src_source }},
        {{ src_ldts }}
    FROM get_cols

    UNION ALL

    SELECT
        {{ src_pk }},
        {{ src_source }},
        {{ src_ldts }}
    FROM get_cols
    WHERE {{ src_pk }} = NULL
    AND {{ src_source }} = NULL
    AND {{ src_ldts }} = NULL
),

records_to_insert AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM union_columns AS a
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN {{ this }} AS d
    ON  a.{{ src_ldts }} = d.{{ src_ldts }}
        AND a.{{ src_pk }} = d.{{ src_pk }}
        AND a.{{ src_source }} = d.{{ src_source }}
        AND a.{{ src_pk }} = NULL
    {% endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}