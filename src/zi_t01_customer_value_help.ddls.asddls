@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_T01_CUSTOMER_VALUE_HELP as select from zt01_customer
{

  @Search.defaultSearchElement: true
  key customer_id as CustomerID,

  @Search.defaultSearchElement: true
  company_name as Companyname

}   
