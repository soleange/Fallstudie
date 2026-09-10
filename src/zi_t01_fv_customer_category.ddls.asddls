@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FV: Status des Kunden'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_T01_FV_CUSTOMER_CATEGORY as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZT01_DO_CUSTOMER_CATEGORY_ID' )
{
    /* value_low -> ID der Fixed Value z.B. GK für Geschäftskunde */
    @EndUserText.label: 'Kundenkategorie'
    key value_low as CategoryID,
    
    
    /* text -> der Text aus dem Fixed Value z.B. Geschäftskunde */
    @Semantics.text: true 
    @EndUserText.label: 'Kategoriebezeichnung'
    text as CategoryName
}
where language = 'E' /* Verhindert später Warnungen */
