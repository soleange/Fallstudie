@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View - Rechnung'
@AccessControl.authorizationCheck: #MANDATORY

define root view entity ZC_T01_INVOICE
  provider contract transactional_query
  as projection on ZR_T01_INVOICE

  association [1..1] to ZR_T01_INVOICE as _BaseEntity on $projection.InvoiceId = _BaseEntity.InvoiceId

{
  key InvoiceId,
      @Consumption.valueHelpDefinition: [
      {
        entity: {
          name: 'ZC_T01_ORDER',
          element: 'OrderId'
        }
      }
      ]
      OrderId,
      @Consumption.valueHelpDefinition: [
      {
      entity: {
      name: 'ZC_T01_CUSTOMER',
      element: 'CustomerID'
      }
      }
      ]
      CustomerId,
      @EndUserText.label: 'Status'
      @Consumption.valueHelpDefinition: [{
      entity: {
        name: 'ZI_T01_FV_INVOICE_STATUS',
        element: 'StatusID'
      }
      }]
      @ObjectModel.text.element: ['StatusName']
      @UI.textArrangement: #TEXT_ONLY
      StatusId,
      @EndUserText.label: 'Rechnungsstatus'
      _Status.StatusName as StatusName,
      InvoiceDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'USt.'
      TaxAmount,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'Gesamtbetrag (Brutto)'
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
      _Customer    : redirected to ZC_T01_CUSTOMER,
      _Invoice_Itm : redirected to composition child ZC_T01_INVOICE_ITM,
      _Orders      : redirected to ZC_T01_ORDER,
      _Status,

      _BaseEntity
}
