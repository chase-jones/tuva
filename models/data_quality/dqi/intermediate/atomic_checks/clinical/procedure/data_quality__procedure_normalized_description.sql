{{ config(
    enabled = var('clinical_enabled', False)
) }}


SELECT
      m.data_source
    , coalesce(m.procedure_date,cast('1900-01-01' as date)) as source_date
    , 'PROCEDURE' AS table_name
    , 'Procedure ID' as drill_down_key
    , coalesce(procedure_id, 'NULL') AS drill_down_value
    , 'NORMALIZED_DESCRIPTION' AS field_name
    , case when m.normalized_description is not null then 'valid' else 'null' end as bucket_name
    , cast(null as {{ dbt.type_string() }}) as invalid_reason
    , cast(substring(normalized_description, 1, 255) as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('procedure')}} m