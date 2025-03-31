with 
stock_history as (
    select * from {{ref('int_stock_price_major_currency')}}
),

unioned_book as (
    select * from {{ref('int_unioned_book')}}
),

cst_market_days as (
    select distinct stock_date
    from stock_history
    where stock_history.stock_date >= (select min(book_date) as min_dt from unioned_book)
),

joined as (
    select 
        cst_market_days.stock_date,
        unioned_book.trader,
        unioned_book.stock_exchange_name,
        unioned_book.instrument,
        unioned_book.book,
        unioned_book.currency,
        sum(unioned_book.volume) as total_shares
    from cst_market_days
    inner join unioned_book on unioned_book.book_date = cst_market_days.stock_date
    where unioned_book.book_date <= cst_market_days.stock_date
    {{dbt_utils.group_by(6)}}

)

select * from joined