# Intro

In the project there are:
- Entity `Books`
- Entity `Orders`
- View `BooksTotalSales` with calculated field `copiesSold`
- Service `CatalogService.BooksTotalSales` expose view `BooksTotalSales`
- The service annotate `CatalogService.BooksTotalSales.copiesSold` with `@odata.Type : 'Edm.Int32'`

## Problem
Attribute `Type` in $metadata edmx-v4 for property `copiesSold` is missing:
```xml
<EntityType Name="BooksTotalSales">
    <Key>
        <PropertyRef Name="book_ID"/>
    </Key>
    <Property Name="book_ID" Type="Edm.Int32" Nullable="false"/>
    <Property Name="title" Type="Edm.String"/>
    <Property Name="copiesSold"/>
</EntityType>
```

There is also a warning during `cds compile --to edmx-v4 srv/cat-service.cds`:
```
[WARNING] srv/cat-service.cds:4:12: Expected element to have a type (in entity:"CatalogService.BooksTotalSales"/element:"copiesSold")
```

## Our investigation
Something strange here `@sap/cds-compiler/lib/edm/edm.js`:
```javascript
      if(this[typeName] == undefined)
      {
        let typecsn = csn.type ? csn : (csn.items && csn.items.type ? csn.items : csn);
        // Complex/EntityType are derived from TypeBase
        // but have no type attribute in their CSN
---->   if(typecsn.type) { // this thing has a type
          // check wether this is a scalar type (or array of scalar type) or a named type
          let scalarType = undefined;
```

## Our temporary hot-fix
```javascript
        if(typecsn.type || typecsn['@odata.Type']) { // this thing has a type
```

## Conclusiom
Easy solution... the type must be specified during definition of the property, see commit:

[Solution](https://github.com/sbarzaghialteaup/test-type-view-fields/commit/8d1e97a6792eb2c4a3982e34eee08ad04ad034b4)

https://answers.sap.com/questions/13500064/metadata-type-attribute-on-property-is-missing.html?childToView=13499055
Just recently we have raised this warning to an error which will be shipped in one of the next releases.

