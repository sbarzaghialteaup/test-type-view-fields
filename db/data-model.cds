namespace my.bookshop;

entity Books {
    key ID    : Integer;
        title : String;
        stock : Integer;
}

entity Orders {
    key ID    : Integer;
        book  : Association to one Books;
        value : Integer
}

entity BooksTotalSales as
    select from Books
    left outer join Orders
        on Orders.book.ID = Books.ID
    {
        key Books.ID    as book_ID,
            Books.title as title,
            count(
                Orders.value
            )           as copiesSold : Integer,
    }
    group by
        Books.ID;

annotate BooksTotalSales {
    @title : 'Copies Sold'
    copiesSold;
}
