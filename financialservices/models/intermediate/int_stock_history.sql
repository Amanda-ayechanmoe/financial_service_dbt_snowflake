with stock_history as (
    select * from {{ref("stg_stock_price")}}
       where indicator_name in ('nasdaq_volume','all_day_high','all_day_low','pre_market_open','post_market_close')
),

pivoted as (
    select 
        ticker,
        asset_class,
        exchange_name,
        stock_date,
        {{dbt_utils.pivot(
            column = "indicator_name",
            values = dbt_utils.get_column_values(ref("stg_stock_price"),"indicator_name"),
            then_value = "stock_value"
        )}}
    from stock_history
    group by ticker, asset_class, exchange_name, stock_date

)

select * from pivoted