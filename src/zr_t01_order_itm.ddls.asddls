@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Interface View (Entity) K-Best-Pos'

define view entity ZR_T01_ORDER_ITM
  as select from zt01_order_itm as Orders_Itm
  
  association [0..1] to I_UnitOfMeasure as _UnitOfMeasure
  on $projection.Unit = _UnitOfMeasure.UnitOfMeasure

  association to parent ZR_T01_ORDER as _Orders on $projection.OrderId = _Orders.OrderId
  
  association [1..1] to ZR_T01_ARTICLE as _Article on $projection.ArticleId = _Article.ArticleId
{
  key order_id              as OrderId,
  key itemline_no           as ItemlineNo,
      article_id            as ArticleId,
      article_name          as ArticleName,
      @Semantics.quantity.unitOfMeasure: 'unit'
      article_quantity      as ArticleQuantity,
      unit                  as Unit,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      unit_price            as UnitPrice,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      net_amount            as NetAmount,
      currency_code         as CurrencyCode,
      remarks               as Remarks,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,      

      _Orders,
      _Article,
      _UnitOfMeasure
}
