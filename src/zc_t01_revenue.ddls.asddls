@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Umsatzliste Team 01'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_T01_REVENUE
  as select from ZR_T01_INVOICE  as Invoice
    inner join   ZR_T01_CUSTOMER as Customer on Invoice.CustomerId = Customer.CustomerID
    inner join   ZR_T01_ORDER    as Orders   on Invoice.OrderId = Orders.OrderId
{
  key Invoice.InvoiceId                         as RevenueRowKey,

      cast( Invoice.InvoiceId as abap.char(8) ) as InvoiceId,

      @Consumption.valueHelpDefinition: [
      {
      entity: {
      name: 'ZC_T01_CUSTOMER',
      element: 'CustomerID'
      }
      }
      ]
      Customer.CustomerID                       as CustomerId,
  
      Customer.CompanyName                      as CompanyName,

      cast( Orders.OrderId as abap.char(8) )    as OrderId,
      Orders.OrderDate                          as OrderDate,

      Invoice.InvoiceDate                       as InvoiceDate,
      Invoice.StatusId                          as InvoiceStatus,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      Invoice.TotalAmount                       as GrossRevenue,

      Invoice.CurrencyCode                      as CurrencyCode
}

union all

select from ZR_T01_INVOICE as Invoice
{
  key cast( '99999999' as abap.numc(8) ) as RevenueRowKey,

      cast( '' as abap.char(8) )         as InvoiceId,

      cast( '' as abap.char(8) )         as CustomerId,
      cast( 'GESAMT' as abap.char(80) )  as CompanyName,

      cast( '' as abap.numc(8) )         as OrderId,
      cast( '00000000' as abap.dats )    as OrderDate,

      cast( '00000000' as abap.dats )    as InvoiceDate,
      cast( '' as abap.char(2) )         as InvoiceStatus,


      sum( Invoice.TotalAmount )         as GrossRevenue,

      Invoice.CurrencyCode               as CurrencyCode
}
group by
  Invoice.CurrencyCode
