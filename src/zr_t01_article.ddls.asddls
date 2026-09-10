@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true

@EndUserText.label: 'Interface View (Entity) Artikel'
define root view entity ZR_T01_ARTICLE
  as select from zt01_article as Article

  association [0..1] to ZI_T01_FV_ARTICLE_CATEGORY as _Category     on $projection.CategoryID = _Category.CategoryID

  association [0..*] to ZR_T01_ORDER_ITM           as _OrderItems   on $projection.ArticleId = _OrderItems.ArticleId

  association [0..*] to ZR_T01_INVOICE_ITM         as _InvoiceItems on $projection.ArticleId = _InvoiceItems.ArticleId

{
  key article_id            as ArticleId,
      category_id           as CategoryID,
      article_name          as ArticleName,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      unit                  as Unit,
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

      _Category,
      _InvoiceItems,
      _OrderItems
}
