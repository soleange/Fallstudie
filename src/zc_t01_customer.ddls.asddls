@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
//  label: '###GENERATED Core Data Service Entity'
  label: 'Kunden'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZT01_CUSTOMER'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_T01_CUSTOMER
  provider contract transactional_query
  as projection on ZR_T01_CUSTOMER
  association [1..1] to ZR_T01_CUSTOMER as _BaseEntity on $projection.CustomerID = _BaseEntity.CustomerID
{
  key CustomerID,
      @Consumption.valueHelpDefinition: [{
        entity: {
          name: 'ZI_T01_FV_CUSTOMER_CATEGORY',
          element: 'CategoryID'
        }
      }]
      @ObjectModel.text.element: ['CategoryName']
      @UI.textArrangement: #TEXT_LAST
      CategoryID,
      /* Kategoriename aus dem Hilfsview "ZI_T01_FV_CUSTOMER_CATEGORY" */
      @EndUserText.label: 'Kategoriename'
      _Category.CategoryName as CategoryName,
      
//       case
//      when CompanyName is initial
//        then concat_with_space( FirstName, LastName, 1 )
//      else CompanyName
//    end as CompanyName,
      CompanyName,
      Remarks,

      /* Personen Felder "ZT01_S_PERSON" */
      Title,
      FirstName,
      LastName,
      PhoneNumber,
      EmailAddress,

      /* Adressen Felder "ZT01_S_ADDRESS" */
      Street,
      PostalCode,
      City,

      @EndUserText.label: 'Land'
      CountryCode,


      // -->
      /* Admin Felder "ZT01_S_ADMIN" */

      @Semantics: { user.createdBy: true }
      @EndUserText.label: 'Erstellt von'
      CreatedBy,

      @Semantics: { systemDateTime.createdAt: true }
      @EndUserText.label: 'Erstellt am'
      CreatedAt,

      @Semantics: { user.localInstanceLastChangedBy: true }
      @EndUserText.label: 'Letzte lokale Änderung von'
      LocalLastChangedBy,

      @Semantics: { systemDateTime.localInstanceLastChangedAt: true }
      @EndUserText.label: 'Letzte lokale Änderung am'
      LocalLastChangedAt,

      @Semantics: { systemDateTime.lastChangedAt: true }
      @EndUserText.label: 'Letzte Änderung am'
      LastChangedAt,
      // <--


      /* Associations */
      _Corr    : redirected to ZC_T01_CORR,
      _Invoice : redirected to ZC_T01_INVOICE,
      _Order   : redirected to ZC_T01_ORDER,
      _BaseEntity
}
