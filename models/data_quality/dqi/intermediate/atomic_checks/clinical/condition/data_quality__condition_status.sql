{{ config(
    enabled = var('clinical_enabled', False)
) }}

SELECT
      m.data_source
    , coalesce(m.recorded_date,cast('1900-01-01' as date)) as source_date
    , 'CONDITION' AS table_name
    , 'Condition ID' as drill_down_key
    , coalesce(condition_id, 'NULL') AS drill_down_value
    , 'STATUS' AS field_name
    , case when m.status is not null then 'valid' else 'null' end as bucket_name
    , cast(null as {{ dbt.type_string() }}) as invalid_reason
    , cast(status as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('condition')}} m