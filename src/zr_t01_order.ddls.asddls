@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: 'Interface View (Entity) K-Bestellungen'

define root view entity ZR_T01_ORDER
  as select from zt01_order as Orders

  association [1..1] to ZR_T01_CUSTOMER        as _Customer on $projection.CustomerId = _Customer.CustomerID

  association [0..*] to ZR_T01_INVOICE         as _Invoice  on $projection.OrderId = _Invoice.OrderId

  association [0..1] to ZI_T01_FV_ORDER_STATUS as _Status   on $projection.StatusId = _Status.StatusID

  composition [1..*] of ZR_T01_ORDER_ITM       as _Orders_Itm
{
  key order_id              as OrderId,
      customer_id           as CustomerId,
      status_id             as StatusId,
      order_date            as OrderDate,
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

      _Status,
      _Customer,
      _Orders_Itm,
      _Invoice
}
