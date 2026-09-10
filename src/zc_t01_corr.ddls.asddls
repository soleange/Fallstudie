@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Projection View - Korrespondenz'
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_T01_CORR
  provider contract transactional_query
  as projection on ZR_T01_CORR
  association [1..1] to ZR_T01_CORR as _BaseEntity on $projection.CorrId = _BaseEntity.CorrId
{
  key CorrId,
        @Consumption.valueHelpDefinition: [
      {
      entity: {
      name: 'ZC_T01_CUSTOMER',
      element: 'CustomerID'
      }
      }
      ]
      CustomerId,
      
      /* Statusname aus dem Hilfsview "ZI_T01_FV_CORR_STATUS" */
      @Consumption.valueHelpDefinition: [{
       entity: {
         name: 'ZI_T01_FV_CORR_STATUS',
         element: 'StatusId'
       }
      }]
      @ObjectModel.text.element: ['StatusName']
      @UI.textArrangement: #TEXT_ONLY
      @EndUserText.label: 'Status'
      StatusId,
      
      @EndUserText.label: 'Status'
      _Status.StatusName as StatusName,
      
      CorrDate,
      Text,
      
      /* TextTypeName aus dem Hilfsview "ZI_T01_FV_CORR_TEXT_TYPE" */
         @EndUserText.label: 'Nachrichtart'
      _Type.TextName     as TextTypeName,
      @Consumption.valueHelpDefinition: [{
      entity: {
        name: 'ZI_T01_FV_CORR_TEXT_TYPE',
        element: 'TextType'
      }
      }]
      @ObjectModel.text.element: ['TextTypeName']
      //      @UI.textArrangement: #TEXT_LAST
      @UI.textArrangement: #TEXT_ONLY
      TextType,
      
      Remarks,

      /* Admin Felder "ZT01_S_ADMIN" */
      @Semantics: { user.createdBy: true }
      @EndUserText.label: 'Erstellt von'
      CreatedBy,

      @Semantics: { systemDateTime.createdAt: true }
      @EndUserText.label: 'Erstellt am'
      CreatedAt,

      @Semantics: { user.localInstanceLastChangedBy: true }
      @EndUserText.label: 'Letzte lokale Änderung von'
      LocalLastChangedBy,

      @Semantics: { systemDateTime.localInstanceLastChangedAt: true }
      @EndUserText.label: 'Letzte lokale Änderung am'
      LocalLastChangedAt,

      @Semantics: { systemDateTime.lastChangedAt: true }
      @EndUserText.label: 'Letzte Änderung am'
      LastChangedAt,

      /* Associations */
      _Customer : redirected to ZC_T01_CUSTOMER,
      _Status,
      _BaseEntity
}
