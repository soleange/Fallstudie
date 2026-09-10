@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View - Bestellung'
@AccessControl.authorizationCheck: #MANDATORY

define root view entity ZC_T01_ORDER
  provider contract transactional_query
  as projection on ZR_T01_ORDER

  association [1..1] to ZR_T01_ORDER as _BaseEntity on $projection.OrderId = _BaseEntity.OrderId

{
  key OrderId,
      @Consumption.valueHelpDefinition: [ {
      entity: {
        name: 'ZC_T01_CUSTOMER',
        element: 'CustomerID' } }
      ]
      CustomerId,
      @Consumption.valueHelpDefinition: [{
      entity: {
        name: 'ZI_T01_FV_ORDER_STATUS',
        element: 'StatusID'
      }
      }]
      @ObjectModel.text.element: ['StatusName']
      @UI.textArrangement: #TEXT_ONLY
      StatusId,
      @EndUserText.label: 'Bestellstatus'
      _Status.StatusName as StatusName,
      OrderDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalAmount,
      @Consumption.valueHelpDefinition: [
        { entity: { name: 'I_Currency', element: 'Currency' } }
      ]
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
      _Customer   : redirected to ZC_T01_CUSTOMER,
      _Invoice    : redirected to ZC_T01_INVOICE,
      _Orders_Itm : redirected to composition child ZC_T01_ORDER_ITM,
      _Status,

      _BaseEntity
}
