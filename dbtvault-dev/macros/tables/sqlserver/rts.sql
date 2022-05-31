{%- macro biquery__rts(src_pk, src_ldts, src_source, src_hashdiff, source_model) -%}

{{ dbtvault.default__rts(src_pk=src_pk,
                         src_ldts=src_ldts,
                         src_source=src_source,
                         src_hashdiff=src_hashdiff,
                         source_model=source_model) }}

{%- endmacro -%}