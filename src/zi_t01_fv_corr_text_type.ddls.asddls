@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FV: Typ der Korrespondenz'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_T01_FV_CORR_TEXT_TYPE as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZT01_DO_CORR_TEXT_TYPE' )
{
    /* value_low -> ID der Fixed Value z.B. GK für Geschäftskunde */
     @EndUserText.label: 'Nachrichtart'
    key value_low as TextType,
    
    
    /* text -> der Text aus dem Fixed Value z.B. Geschäftskunde */
    @Semantics.text: true 
     @EndUserText.label: 'Bezeichnung'
    text as TextName
}
where language = 'E' /* Verhindert später Warnungen */
