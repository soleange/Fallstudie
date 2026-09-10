@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Währung Euro'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_T01_CURRENCY_EUR as select from I_CurrencyStdVH
{
   @EndUserText.label: 'Währung'
  key Currency
    
}
where Currency = 'EUR';
