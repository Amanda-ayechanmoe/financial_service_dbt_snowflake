{{ 
config(
      materialized='incremental',
      unique_key= 'pk_key',
      tags = 'core'
      ) 
}}
 
 
with 
daily_positions as (
    select * from {{ ref('int_daily_position_with_trades' )}}
),
 
stock_history as (
    select * from {{ ref('int_stock_price_major_currency') }}
),
 
joined as (
    select 
        daily_positions.instrument,
        daily_positions.stock_exchange_name,
        daily_positions.book_date,
        daily_positions.trader, 
        daily_positions.volume,
        daily_positions.cost, 
        daily_positions.cost_per_share,
        daily_positions.currency,
        sum(cost) over(
                partition by 
                    daily_positions.instrument, 
                    daily_positions.stock_exchange_name, 
                    trader 
                order by
                    daily_positions.book_date rows unbounded preceding 
                    )
                as cash_cumulative,
       daily_positions.total_shares  * daily_positions.cost_per_share as market_value, 
       daily_positions.total_shares  * daily_positions.cost_per_share + cash_cumulative as PnL
   from daily_positions
   inner join stock_history 
      on daily_positions.instrument = stock_history.ticker
     and stock_history.stock_date = daily_positions.book_date 
),
 
primary_key as (
 
    select 
 
        {{ dbt_utils.generate.surrogate_key([
                'trader', 
                'instrument', 
                'book_date', 
                'stock_exchange_name',
                'PnL', 
            ]) }} as pk_key,
                *
 
    from joined 
)
 
select * from primary_key
 
{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
   where book_date > (select max(book_date) from {{ this }})
 
{% endif %}