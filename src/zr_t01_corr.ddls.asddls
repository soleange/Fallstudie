@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: 'Interface View (Entity) Korrespondenz'

define root view entity ZR_T01_CORR
  as select from zt01_correspond as Correspondence
  
  association [1..1] to ZR_T01_CUSTOMER as _Customer on $projection.CustomerId = _Customer.CustomerID
  
  association [1..1] to ZI_T01_FV_CORR_STATUS as _Status on $projection.StatusId = _Status.StatusID
  
  association [1..1] to ZI_T01_FV_CORR_TEXT_TYPE as _Type on $projection.TextType = _Type.TextType
{
  key corr_id               as CorrId,
      customer_id           as CustomerId,
      status_id             as StatusId,
      corr_date             as CorrDate,
      text                  as Text,
      text_type             as TextType,
      remarks               as Remarks,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      
      _Status,
      _Customer,
      _Type
}
