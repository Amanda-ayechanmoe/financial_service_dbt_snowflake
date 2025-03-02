{{
    config(
        materialized = 'view',
        tags = ["hourly"]
    )
}}

select * from {{ref("stg_fx_rates")}}
    where exchange_date > '2016-01-01'