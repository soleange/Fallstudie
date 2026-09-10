@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unit'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_T01_UNIT as select from I_UnitOfMeasureStdVH
{
   @EndUserText.label: 'Einheit'
    key UnitOfMeasure as Unit,
//    UnitOfMeasureLongName as UnitText
 
      @EndUserText.label: 'Bezeichnung'
    case UnitOfMeasure
        when 'ST' then 'Stück'       
    else UnitOfMeasure
    
    end as UnitText
}where UnitOfMeasure = 'ST';
