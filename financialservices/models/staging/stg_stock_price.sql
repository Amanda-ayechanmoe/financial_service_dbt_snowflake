with source as (
    select * from {{source('finance','raw_stock_price')}}
),

renamed as (
    select 
        "TICKER" as ticker,
        "ASSET_CLASS" as asset_class,
        "PRIMARY_EXCHANGE_CODE" as exchange_code,
        "PRIMARY_EXCHANGE_NAME" as exchange_name,
        REPLACE("VARIABLE",'-','_') as indicator_name,
        "DATE" as stock_date,
        "VALUE" as stock_value
    from source
)

select * from renamed