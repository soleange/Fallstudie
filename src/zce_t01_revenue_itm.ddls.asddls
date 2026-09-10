@EndUserText.label: 'Umsatzliste Rechnungspositionen'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_T01_REVENUE_ITM_QUERY'
@Metadata.allowExtensions: true

define custom entity ZCE_T01_REVENUE_ITM
{
      @UI.hidden: true
  key RevenueRowKey : abap.char( 30 );

      @EndUserText.label: 'Kunde'
      @Consumption.valueHelpDefinition: [
        { entity: { name: 'ZC_T01_CUSTOMER', element: 'CustomerID' } }
      ]
      @ObjectModel.text.element: ['CustomerDisplay']
      @UI.textArrangement: #TEXT_LAST
      CustomerId : abap.char( 8 );

      @Semantics.text: true
      CustomerDisplay : abap.char( 100 );

      @EndUserText.label: 'Kundenname'
      @Consumption.valueHelpDefinition: [
        { entity: { name: 'ZC_T01_CUSTOMER', element: 'CompanyName' } }
      ]
      CompanyName : abap.char( 80 );

      FirstName : abap.char( 40 );

      LastName : abap.char( 40 );

      @EndUserText.label: 'Bestellung'
      @Consumption.valueHelpDefinition: [
        { entity: { name: 'ZC_T01_ORDER', element: 'OrderId' } }
      ]
      OrderId : abap.char( 8 );

      @EndUserText.label: 'Bestelldatum'
      OrderDate : abap.dats;

      @EndUserText.label: 'Rechnung'
      @Consumption.valueHelpDefinition: [
        { entity: { name: 'ZC_T01_INVOICE', element: 'InvoiceId' } }
      ]
      InvoiceId : abap.char( 8 );

      @EndUserText.label: 'Rechnungsdatum'
      InvoiceDate : abap.dats;

      @EndUserText.label: 'Status'
      @Consumption.valueHelpDefinition: [
        { entity: { name: 'ZI_T01_FV_INVOICE_STATUS', element: 'StatusID' } }
      ]
      @ObjectModel.text.element: ['InvoiceStatusName']
      @UI.textArrangement: #TEXT_LAST
      InvoiceStatus : abap.char( 2 );

      @Semantics.text: true
      InvoiceStatusName : abap.char( 40 );

      @EndUserText.label: 'Position'
      ItemlineNo : abap.char( 8 );

      @EndUserText.label: 'Bestellposition'
      ItemlineNoOrder : abap.char( 8 );

      @EndUserText.label: 'Artikel'
      @Consumption.valueHelpDefinition: [
        { entity: { name: 'ZC_T01_ARTICLE', element: 'ArticleId' } }
      ]
      @ObjectModel.text.element: ['ArticleName']
      @UI.textArrangement: #TEXT_LAST
      ArticleId : abap.char( 20 );

      @EndUserText.label: 'Artikelname'
      @Consumption.valueHelpDefinition: [
        { entity: { name: 'ZC_T01_ARTICLE', element: 'ArticleName' } }
      ]
      ArticleName : abap.char( 80 );

      @EndUserText.label: 'Menge'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      ArticleQuantity : abap.quan( 15, 3 );

      @EndUserText.label: 'Einheit'
      Unit : abap.unit( 3 );

      @EndUserText.label: 'Einzelpreis'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      UnitPrice : abap.curr( 15, 2 );

      @EndUserText.label: 'Positionsumsatz'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      PositionAmount : abap.curr( 15, 2 );

      CurrencyCode : abap.cuky( 5 );

      @EndUserText.label: 'Menge'
      QuantityDisplay : abap.char( 25 );

      @EndUserText.label: 'Einzelpreis'
      UnitPriceDisplay : abap.char( 30 );
}
