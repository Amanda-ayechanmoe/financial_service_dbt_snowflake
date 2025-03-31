with unioned_book as (
    select * from {{ref('int_unioned_book')}}
),

daily_position as (
    select * from {{ref('int_daily_position')}}
),

unioned as (
    select 
        book,
        book_date,
        trader,
        instrument,
        book_action,
        cost,
        currency,
        volume,
        cost_per_share,
        stock_exchange_name,
        sum(unioned_book.volume)
            over(
                partition by
                    instrument,
                    stock_exchange_name,
                    trader
                order by
                    unioned_book.book_date rows unbounded preceding
            )as total_shares
    from unioned_book

    union all

    select 
        book,
        stock_date as book_date,
        trader,
        instrument,
        'HOLD' as book_action,
        0 as cost,
        currency,
        0 as volumne,
        0 as cost_per_share,
        stock_exchange_name,
        total_shares,
    from daily_position
    where (book_date,trader,instrument,book,stock_exchange_name)
        not in (
            select book_date, trader, instrument, book, stock_exchange_name
                from unioned_book
        )
)

select * from unioned