-- dbt --quiet run-operation generate_base_model --args '{"source_name": "staging", "table_name": "yellow_tripdata"}' > models/staging/stg_yellow_tripdata.sql

with source as (

    select * from {{ source('staging', 'yellow_tripdata') }}

),

renamed as (

    select

    from source

)

select * from renamed

