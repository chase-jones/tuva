{{ config(
    enabled = var('claims_enabled', False)
) }}

with base as (
    select *
    from {{ ref('medical_claim')}}
    where claim_type = 'institutional'
),
unique_field as (
    select distinct claim_id
        ,cast(billing_npi as {{ dbt.type_string() }}) as field
        ,data_source
    from base
),
claim_grain as (
    select claim_id
        ,data_source
        ,count(*) as frequency
    from unique_field
    group by claim_id
        ,data_source
),
claim_agg as (
select
    claim_id,
    data_source,
    {{ dbt.listagg(measure="coalesce(field, 'null')", delimiter_text="', '", order_by_clause="order by field desc") }} as field_aggregated
from
    unique_field
group by
    claim_id,
    data_source
	)
select distinct -- to bring to claim_id grain
    m.data_source
    ,coalesce(cast(m.claim_start_date as {{ dbt.type_string() }}),cast('1900-01-01' as {{ dbt.type_string() }})) as source_date
    ,'MEDICAL_CLAIM' AS table_name
    ,'Claim ID' AS drill_down_key
    ,coalesce(m.claim_id, 'NULL') AS drill_down_value
    ,'institutional' AS claim_type
    ,'BILLING_NPI' AS field_name
    ,case when cg.frequency > 1                then 'multiple'
          when term.npi is not null            then 'valid'
          when m.billing_npi is not null      then 'invalid'
                                               else 'null' end as bucket_name
    ,case
        when cg.frequency = 1
            and m.billing_npi is not null
            and term.npi is null
            then 'NPI is not in Terminology Provider table'
        else null
    end as invalid_reason
    ,cast({{ substring('agg.field_aggregated', 1, 255) }} as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from base m
left join claim_grain cg on m.claim_id = cg.claim_id and m.data_source = cg.data_source
left join {{ ref('terminology__provider')}} as term on m.billing_npi = term.npi
left join claim_agg agg on m.claim_id = agg.claim_id and m.data_source = agg.data_source