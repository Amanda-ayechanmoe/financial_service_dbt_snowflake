with
unioned as (
    {{dbt_utils.union_relations(
        relations=[
            ref('manual_book1'),ref('manual_book2')
        ]
    )}}
),

renamed as (
    select
        Book,
        Date as book_date,
        Trader,
        Instrument,
        Action as book_action,
        Cost,
        Currency,
        Volume,
        Cost_Per_Share,
        Stock_exchange_name
    from unioned
)

select * from renamed