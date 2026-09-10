@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View - Rechnungspositionen'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZC_T01_INVOICE_ITM
  as projection on ZR_T01_INVOICE_ITM

  association [1..1] to ZR_T01_INVOICE_ITM as _BaseEntity on  $projection.InvoiceId  = _BaseEntity.InvoiceId
                                                          and $projection.ItemlineNo = _BaseEntity.ItemlineNo
{
  key InvoiceId,
  key ItemlineNo,
      ItemlineNoOrder,
      @Consumption.valueHelpDefinition: [
      { entity: { name: 'ZC_T01_ARTICLE', element: 'ArticleId' } }
      ]
      ArticleId,
      ArticleName,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      ArticleQuantity,
      @Consumption.valueHelpDefinition: [
      { entity: { name: 'I_UnitOfMeasure', element: 'UnitOfMeasure' } }
      ]
      @Semantics.unitOfMeasure: true
      Unit,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'Einzelpreis'
      UnitPrice,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'Gesamtpreis'
      TotalAmount,
      CurrencyCode,
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
      _Article : redirected to ZC_T01_ARTICLE,
      _Invoice : redirected to parent ZC_T01_INVOICE,

      _BaseEntity
}
