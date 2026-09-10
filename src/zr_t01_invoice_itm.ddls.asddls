@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Interface View (Entity) Rg-Pos'

define view entity ZR_T01_INVOICE_ITM
  as select from zt01_invoice_itm as Invoice_Itm
  
  association to parent ZR_T01_INVOICE as _Invoice on $projection.InvoiceId = _Invoice.InvoiceId
  
  association [1..1] to ZR_T01_ARTICLE as _Article on $projection.ArticleId = _Article.ArticleId
{
  key invoice_id            as InvoiceId,
  key itemline_no           as ItemlineNo,
      itemline_no_order     as ItemlineNoOrder,
      article_id            as ArticleId,
      article_name          as ArticleName,
      @Semantics.quantity.unitOfMeasure: 'unit'
      article_quantity      as ArticleQuantity,
      unit                  as Unit,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      unit_price            as UnitPrice,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_amount          as TotalAmount,
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
      
      _Invoice,
      _Article
}
