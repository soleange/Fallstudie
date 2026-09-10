@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View - Artikel'
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_T01_ARTICLE
  provider contract transactional_query
  as projection on ZR_T01_ARTICLE
  association [1..1] to ZR_T01_ARTICLE as _BaseEntity on $projection.ArticleId = _BaseEntity.ArticleId
{
  key ArticleId,
      @Consumption.valueHelpDefinition: [{
            entity: {
              name: 'ZI_T01_FV_ARTICLE_CATEGORY',
              element: 'CategoryID'
            }
          }]
      @ObjectModel.text.element: ['CategoryName']
      @UI.textArrangement: #TEXT_LAST
      CategoryID,
      @EndUserText.label: 'Artikelkategorie'
      _Category.CategoryName as CategoryName,
      ArticleName,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      @Consumption: {
      valueHelpDefinition: [ {
      entity.element: 'Currency',
      entity.name: 'ZI_T01_CURRENCY_EUR',
      useForValidation: true
      } ]
      }
      @EndUserText.label: 'Währung' // EUR als Standardwert beim Anlegen
      CurrencyCode,

      @Consumption.valueHelpDefinition: [
      { entity: { name: 'I_UnitOfMeasure', element: 'UnitOfMeasure' } }
      ]
      @Semantics.unitOfMeasure: true
      Unit,
      Remarks,

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

      /* Associations */
      _InvoiceItems : redirected to ZC_T01_INVOICE_ITM,
      _OrderItems   : redirected to ZC_T01_ORDER_ITM,
      _BaseEntity
}
