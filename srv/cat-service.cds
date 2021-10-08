using {my.bookshop as my, } from '../db/data-model';

service CatalogService {
    @readonly
    entity Books         as projection on my.Books;

    entity BooksEnhanced as
        select from my.Books as ciao
        left join my.Orders as Orders
            on Orders.book.ID = ciao.ID
        {
            key ciao.ID as book_ID,
                sum(
                    Orders.value
                )       as totalSales
        }
        group by
            $projection.book_ID
}
