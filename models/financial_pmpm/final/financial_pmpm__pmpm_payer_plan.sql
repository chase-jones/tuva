{{ config(
   enabled = var('financial_pmpm_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
)}}

select
    year_month
  , payer
  , {{ quote_column('plan') }}
  , data_source
  , count(1) as member_months
  , sum(total_paid) / count(1) as total_paid
  , sum(medical_paid) / count(1) as medical_paid
  , sum(inpatient_paid) / count(1) as inpatient_paid
  , sum(outpatient_paid) / count(1) as outpatient_paid
  , sum(office_visit_paid) / count(1) as office_visit_paid
  , sum(ancillary_paid) / count(1) as ancillary_paid
  , sum(pharmacy_paid) / count(1) as pharmacy_paid
  , sum(other_paid) / count(1) as other_paid
  , sum(acute_inpatient_paid) / count(1) as acute_inpatient_paid
  , sum(ambulance_paid) / count(1) as ambulance_paid
  , sum(ambulatory_surgery_paid) / count(1) as ambulatory_surgery_paid
  , sum(dialysis_paid) / count(1) as dialysis_paid
  , sum(durable_medical_equipment_paid) / count(1) as durable_medical_equipment_paid
  , sum(emergency_department_paid) / count(1) as emergency_department_paid
  , sum(home_health_paid) / count(1) as home_health_paid
  , sum(hospice_paid) / count(1) as hospice_paid
  , sum(inpatient_psychiatric_paid) / count(1) as inpatient_psychiatric_paid
  , sum(inpatient_rehabilitation_paid) / count(1) as inpatient_rehabilitation_paid
  , sum(lab_paid) / count(1) as lab_paid
  , sum(office_visit_paid_2) / count(1) as office_visit_paid_2
  , sum(outpatient_hospital_or_clinic_paid) / count(1) as outpatient_hospital_or_clinic_paid
  , sum(outpatient_psychiatric_paid) / count(1) as outpatient_psychiatric_paid
  , sum(outpatient_rehabilitation_paid) / count(1) as outpatient_rehabilitation_paid
  , sum(skilled_nursing_paid) / count(1) as skilled_nursing_paid
  , sum(urgent_care_paid) / count(1) as urgent_care_paid
  , sum(total_allowed) / count(1) as total_allowed
  , sum(medical_allowed) / count(1) as medical_allowed
  , sum(inpatient_allowed) / count(1) as inpatient_allowed
  , sum(outpatient_allowed) / count(1) as outpatient_allowed
  , sum(office_visit_allowed) / count(1) as office_visit_allowed
  , sum(ancillary_allowed) / count(1) as ancillary_allowed
  , sum(pharmacy_allowed) / count(1) as pharmacy_allowed
  , sum(other_allowed) / count(1) as other_allowed
  , sum(acute_inpatient_allowed) / count(1) as acute_inpatient_allowed
  , sum(ambulance_allowed) / count(1) as ambulance_allowed
  , sum(ambulatory_surgery_allowed) / count(1) as ambulatory_surgery_allowed
  , sum(dialysis_allowed) / count(1) as dialysis_allowed
  , sum(durable_medical_equipment_allowed) / count(1) as durable_medical_equipment_allowed
  , sum(emergency_department_allowed) / count(1) as emergency_department_allowed
  , sum(home_health_allowed) / count(1) as home_health_allowed
  , sum(hospice_allowed) / count(1) as hospice_allowed
  , sum(inpatient_psychiatric_allowed) / count(1) as inpatient_psychiatric_allowed
  , sum(inpatient_rehabilitation_allowed) / count(1) as inpatient_rehabilitation_allowed
  , sum(lab_allowed) / count(1) as lab_allowed
  , sum(office_visit_allowed_2) / count(1) as office_visit_allowed_2
  , sum(outpatient_hospital_or_clinic_allowed) / count(1) as outpatient_hospital_or_clinic_allowed
  , sum(outpatient_psychiatric_allowed) / count(1) as outpatient_psychiatric_allowed
  , sum(outpatient_rehabilitation_allowed) / count(1) as outpatient_rehabilitation_allowed
  , sum(skilled_nursing_allowed) / count(1) as skilled_nursing_allowed
  , sum(urgent_care_allowed) / count(1) as urgent_care_allowed
  , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('financial_pmpm__pmpm_prep') }} a
group by
    year_month
  , payer
  , {{ quote_column('plan') }}
  , data_source
