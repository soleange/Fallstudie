@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FV: Status der Kundenbestellungen'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_T01_FV_ORDER_STATUS as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZT01_DO_ORDER_STATUS_ID' )
{
    /* value_low -> ID der Fixed Value z.B. GK für Geschäftskunde */
    @EndUserText.label: 'Bestellstatus'
    key value_low as StatusID,
    
    
    /* text -> der Text aus dem Fixed Value z.B. Geschäftskunde */
    @Semantics.text: true 
    @EndUserText.label: 'Bezeichnung'
    text as StatusName
}
where language = 'E' /* Verhindert später Warnungen */
