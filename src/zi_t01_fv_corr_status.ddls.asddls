@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FV: Status der Korrespondenz'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_T01_FV_CORR_STATUS as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZT01_DO_CORRESPOND_STATUS_ID' )
{
    /* value_low -> ID der Fixed Value z.B. GK für Geschäftskunde */
    @EndUserText.label: 'Korrespondenz'
    key value_low as StatusId,
    
    
    /* text -> der Text aus dem Fixed Value z.B. Geschäftskunde */
    @Semantics.text: true 
    @EndUserText.label: 'Bezeichnung'
    text as StatusName
}
where language = 'E' /* Verhindert später Warnungen */
