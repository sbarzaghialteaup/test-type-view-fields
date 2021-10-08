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
