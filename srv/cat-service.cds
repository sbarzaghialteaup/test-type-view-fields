using {my.bookshop as my} from '../db/data-model';

service CatalogService {
    entity BooksTotalSales as projection on my.BooksTotalSales;
}

annotate CatalogService.BooksTotalSales {
    @odata.Type : 'Edm.Int32'
    copiesSold;
}
