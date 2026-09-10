@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View - Bestellpositionen'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZC_T01_ORDER_ITM
  as projection on ZR_T01_ORDER_ITM

  association [1..1] to ZR_T01_ORDER_ITM as _BaseEntity on  $projection.OrderId    = _BaseEntity.OrderId
                                                        and $projection.ItemlineNo = _BaseEntity.ItemlineNo
                                                        
  association [0..1] to I_UnitOfMeasure as _UnitOfMeasure
  on $projection.Unit = _UnitOfMeasure.UnitOfMeasure
{
  key OrderId,
  key ItemlineNo,
      @Consumption.valueHelpDefinition: [
      { entity: { name: 'ZC_T01_ARTICLE', element: 'ArticleId' } }
      ]
      ArticleId,
      ArticleName,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      ArticleQuantity,
      @Consumption.valueHelpDefinition: [
      { entity: { name: 'ZI_T01_UNIT', element: 'Unit' } }
      ]
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_UnitOfMeasure'
      Unit,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'Einzelpreis'
      UnitPrice,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'Gesamtpreis'
      NetAmount,
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
      _Orders  : redirected to parent ZC_T01_ORDER,

      _BaseEntity,
      _UnitOfMeasure
}
