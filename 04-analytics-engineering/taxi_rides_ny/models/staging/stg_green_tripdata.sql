-- dbt --quiet run-operation generate_base_model --args '{"source_name": "staging", "table_name": "green_tripdata"}' > models/staging/stg_green_tripdata.sql

with source as (

    select * from {{ source('staging', 'green_tripdata') }}

),

renamed as (

    select

    from source

)

select * from renamed

