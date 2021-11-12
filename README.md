[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=0.20.x&color=orange)

# Tuva

This dbt package contains logic necessary to power many different types of healthcare analytics use cases.  See below table for currently supported and planned use cases.  The package is designed to run using a minimum set of commonly available healthcare data fields (currently 4 tables and 18 total fields).  This minimizes the amount of upfront configuration (e.g. source-to-target mapping).

| **use case** | **description** | **status** |
| --------------- | -------------------- | ------------------- |
| [chronic_conditions](#chronic-conditions) | Each patient is flagged for having any of 69 chronic conditions within 9 clinical areas (definitions based on CMS Chronic Condition Warehouse). | Available |
| clinical_classification_software | Diagnosis grouper (over 70,000 ICD-10-CM are grouped into 530 clinical categories across 21 clinical domains) and procedure grouper (over 80,000 ICD-10-PCS codes are grouped into 320 procedure categories across 31 clinical domains). | Planned Release: Nov 2021 |
| readmissions | All 7 CMS readmission measures, LACE index, and pre-processed tables ready to train ML readmission models. | Planned: Nov 2021 |
| cms_and_hhs_hccs | Condition categories, hierarchies, and risk scores at the patient-level. | Planned Release: Dec 2021 |

## Pre-requisites
1. Healthcare data in a data warehouse
2. [dbt](https://www.getdbt.com/)

## Configuration

These steps assume you already have dbt setup and running against your data warehouse.  If this is not the case, please install and configure dbt as a first step.

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repo to your local machine
2. Configure dbt_profile.yml
3. Create staging tables

This package requires you to configure 4 staging models.  These 4 staging models are all that is needed to run all the logic in this repo.

To configure each staging model, directly modify each [staging file](models/staging) so that they run on your data.  The sql provided in these files shows you the target schema but you must map your data to this schema by modifying the files/

| **staging table** | **description** |
| --------------- | -------------------- |
| [patients](models/stage/patients.sql) | One record per patient with basic demographic information. |
| [encounters](models/stage/encounters.sql) | One record per encounter with basic administrative information and links to stg_patients. |
| [diagnoses](models/stage/diagnoses.sql) | One record per diagnosis which links back to stg_encounters. |
| [procedures](models/stage/procedures.sql) | One record per procedure which links back to stg_encounters. |

## Use Cases 

### Chronic Conditions

| **model** | **description** |
| --------------- | -------------------- |
| [condition_logic_simple](models/chronic_conditions/condition_logic_simple.sql) | Joins diagnosis and procedure codes from stg_diagnoses and stg_procedures to the proper codes in [chronic_conditions](data/chronic_conditions.csv). |
| [condition_logic](models/chronic_conditions/condition_logic.sql) | Joins diagnosis and procedure codes from stg_diagnoses and stg_procedures to the proper codes in [chronic_conditions](data/chronic_conditions.csv).  Conditions identified using this logic require additional criteria (e.g. only consider primary diagnosis). |
| [stroke_transient_ischemic_attack](models/chronic_conditions/stroke_transient_ischemic_attack.sql) | This logic specifically identifies patients who have experienced a stroke or TIA (mini-stroke) by joining diagnosis codes to [chronic_conditions](data/chronic_conditions.csv). |
| [benign_prostatic_hyperplasia](models/chronic_conditions/benign_prostatic_hyperplasia.sql) | This logic specifically identifies patients who have experience benign prostatic hyperplasia (also known as prostate gland enlargement) by joining to diagnosis codes in [chronic_conditions](data/chronic_conditions.csv). |
| [union_calculations](models/chronic_conditions/union_calculations.sql) | Unions the four condition logic models together and calculates measures (i.e. date of onset, most recent diagnosis date, and number of distinct encounters with the diagnosis). |
| [condition_pivot](models/chronic_conditions/condition_pivot.sql) | Pivots union_calculations to create a 'wide' table, i.e. one record per patient with 69 columns, one for each chronic condition (the values of these columns are either 1 if the patient has the condition or 0 otherwise). |

## Contributions
Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `master`. See [the Discourse post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) for information on how to contribute to a package.

## Database Support
This package has been tested on Snowflake.  We are planning to expand testing to BigQuery and Redshift in the near future.
