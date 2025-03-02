with source as (
    select * from {{source('finance','raw_fx_rates')}}
),

renamed as (
    select 
        "VARIABLE" as indicator,
        "BASE_CURRENCY_ID" as base_currency_id,
        "QUOTE_CURRENCY_ID" as quote_currency_id,
        "BASE_CURRENCY_NAME" as base_currency_name,
        "QUOTE_CURRENCY_NAME" as quote_currency_name,
        "DATE" as exchange_date,
        "VALUE" as exchange_value
    from source
)

select * from renamed