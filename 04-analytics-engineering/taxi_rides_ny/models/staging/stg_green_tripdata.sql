-- dbt --quiet run-operation generate_base_model --args '{"source_name": "de_zoomcamp_nyc_taxi", "table_name": "green_tripdata"}' > models/staging/stg_green_tripdata.sql

with source as (

    select * from {{ source('de_zoomcamp_nyc_taxi', 'green_tripdata') }}

),

renamed as (

    select
        unique_row_id,
        filename,
        vendorid,
        lpep_pickup_datetime,
        lpep_dropoff_datetime,
        store_and_fwd_flag,
        ratecodeid,
        pulocationid,
        dolocationid,
        passenger_count,
        trip_distance,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        ehail_fee,
        improvement_surcharge,
        total_amount,
        payment_type,
        trip_type,
        congestion_surcharge

    from source

)

select * from renamed

