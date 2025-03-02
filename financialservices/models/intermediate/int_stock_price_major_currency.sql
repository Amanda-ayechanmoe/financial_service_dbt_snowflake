with 
stock_history as (
    select * from {{ref("int_stock_history")}}
),

fx_rates as (
    select * from {{ref("int_fx_rates")}}
),

fx_rates_gbp as (
    select * from fx_rates
        where indicator = 'usd_gbp'
),

fx_rates_eur as (
    select * from fx_rates
        where indicator = 'usd_eur'
),

fx_rates_sgd as (
    select * from fx_rates
        where indicator = 'usd_sgd'
),

joined as (
    select
        stock_history.*,
        fx_rates_gbp.exchange_value * stock_history."pre_market_open" as gbp_pre_market_open,
        fx_rates_gbp.exchange_value * stock_history."post_market_close" as gbp_post_market_close,
        fx_rates_gbp.exchange_value * stock_history."all_day_high" as gbp_all_day_high,
        fx_rates_gbp.exchange_value * stock_history."all_day_low" as gbp_all_day_low,
        fx_rates_eur.exchange_value * stock_history."pre_market_open" as eur_pre_market_open,
        fx_rates_eur.exchange_value * stock_history."post_market_close" as eur_post_market_close,
        fx_rates_eur.exchange_value * stock_history."all_day_high" as eur_all_day_high,
        fx_rates_eur.exchange_value * stock_history."all_day_low" as eur_all_day_low,
        fx_rates_sgd.exchange_value * stock_history."pre_market_open" as sgd_pre_market_open,
        fx_rates_sgd.exchange_value * stock_history."post_market_close" as sgd_post_market_close,
        fx_rates_sgd.exchange_value * stock_history."all_day_high" as sgd_all_day_high,
        fx_rates_sgd.exchange_value * stock_history."all_day_low" as sgd_all_day_low
    from stock_history
    left join fx_rates_gbp on stock_history.stock_date = fx_rates_gbp.exchange_date
    left join fx_rates_eur on stock_history.stock_date = fx_rates_eur.exchange_date
    left join fx_rates_sgd on stock_history.stock_date = fx_rates_sgd.exchange_date
)

select * from joined