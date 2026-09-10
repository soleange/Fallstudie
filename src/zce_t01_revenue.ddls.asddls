@EndUserText.label: 'Dynamische Umsatzliste'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_T01_REVENUE_QUERY'
@Metadata.allowExtensions: true

define custom entity ZCE_T01_REVENUE
{
  key RevenueRowKey : abap.char( 10 );
      @Consumption.valueHelpDefinition: [
        { entity    : { name: 'ZC_T01_CUSTOMER', element: 'CustomerID' } }
      ]
      @EndUserText.label: 'Kundennummer'
      CustomerId    : abap.char( 8 );
      @Consumption.valueHelpDefinition: [
        { entity    : { name: 'ZC_T01_CUSTOMER', element: 'CompanyName' } }
      ]
      @EndUserText.label: 'Kunde'
      CompanyName   : abap.char( 80 );

      @Consumption.valueHelpDefinition: [
        { entity    : { name: 'ZC_T01_ORDER', element: 'OrderId' } }
      ]
      @EndUserText.label: 'Bestellung'
      OrderId       : abap.char( 8 );
      OrderDate     : abap.dats;
      @Consumption.valueHelpDefinition: [
        { entity    : { name: 'ZC_T01_INVOICE', element: 'InvoiceId' } }
      ]
      @EndUserText.label: 'Rechnung'
      InvoiceId     : abap.char( 8 );
      InvoiceDate   : abap.dats;

      @EndUserText.label: 'Status'
      @Consumption.valueHelpDefinition: [
        { entity    : { name: 'ZI_T01_FV_INVOICE_STATUS', element: 'StatusID' } }
      ]
      @ObjectModel.text.element: ['InvoiceStatusName']
      @UI.textArrangement: #TEXT_LAST
      InvoiceStatus : abap.char( 2 );
      InvoiceStatusName : abap.char( 40 );

      @Semantics.amount.currencyCode: 'CurrencyCode'
      GrossRevenue  : abap.curr( 15, 2 );

      CurrencyCode  : abap.cuky( 5 );
}
