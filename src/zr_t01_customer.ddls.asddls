@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZT01_CUSTOMER'
@EndUserText.label: 'Interface View (Entity) Kunden'
define root view entity ZR_T01_CUSTOMER
  as select from zt01_customer as Customer

  association [0..1] to ZI_T01_FV_CUSTOMER_CATEGORY as _Category     on $projection.CategoryID = _Category.CategoryID

  association [0..*] to ZR_T01_CORR                 as _Corr         on $projection.CustomerID = _Corr.CustomerId

  association [0..*] to ZR_T01_INVOICE              as _Invoice      on $projection.CustomerID = _Invoice.CustomerId

  association [0..*] to ZR_T01_ORDER                as _Order        on $projection.CustomerID = _Order.CustomerId

{
  key customer_id           as CustomerID,
      category_id           as CategoryID,
      company_name          as CompanyName,
      remarks               as Remarks,
      title                 as Title,
      first_name            as FirstName,
      last_name             as LastName,
      phone_number          as PhoneNumber,
      email_address         as EmailAddress,
      street                as Street,
      postal_code           as PostalCode,
      city                  as City,
      country_code          as CountryCode,
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

      _Category,
      _Corr,
      _Invoice,
      _Order
}
