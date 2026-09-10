@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Interface View (Entity) Rechnungen'

define root view entity ZR_T01_INVOICE
  as select from zt01_invoice
  
  association [1..1] to ZR_T01_CUSTOMER as _Customer on $projection.CustomerId = _Customer.CustomerID
  
  association [1..1] to ZR_T01_ORDER as _Orders on $projection.OrderId = _Orders.OrderId
  
  association [0..1] to ZI_T01_FV_INVOICE_STATUS as _Status on $projection.StatusId = _Status.StatusID
  
  composition [1..*] of ZR_T01_INVOICE_ITM as _Invoice_Itm
{
  key invoice_id            as InvoiceId,
      order_id              as OrderId,
      customer_id           as CustomerId,
      status_id             as StatusId,
      invoice_date          as InvoiceDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      tax_amount            as TaxAmount,
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
      
      _Customer,
      _Orders,
      _Status,
      _Invoice_Itm
}
