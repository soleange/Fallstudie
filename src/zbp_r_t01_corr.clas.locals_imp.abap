CLASS lhc_ZrT01Corr DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZrT01Corr
      RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE ZrT01Corr.

    METHODS SetInitialValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01Corr~SetInitialValues.

ENDCLASS.


CLASS lhc_ZrT01Corr IMPLEMENTATION.

  METHOD get_global_authorizations.

    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.

    IF requested_authorizations-%update = if_abap_behv=>mk-on.
      result-%update = if_abap_behv=>auth-allowed.
    ENDIF.

    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
      result-%delete = if_abap_behv=>auth-allowed.
    ENDIF.

  ENDMETHOD.


  METHOD earlynumbering_create.

    SELECT MAX( corr_id )
      FROM zt01_correspond
      INTO @DATA(lv_max_active).

    SELECT MAX( corrid )
      FROM zt01_corr_d
      INTO @DATA(lv_max_draft).

    DATA(lv_max_id) =
      COND #(
        WHEN lv_max_draft > lv_max_active
        THEN lv_max_draft
        ELSE lv_max_active
      ).

    DATA(lv_next_id) = CONV i( lv_max_id ).

    LOOP AT entities INTO DATA(entity).

      lv_next_id += 1.

      DATA(lv_corr_id) =
        |{ lv_next_id WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.

      APPEND VALUE #(
        %cid      = entity-%cid
        %key      = VALUE #( CorrId = lv_corr_id )
        %is_draft = entity-%is_draft
      ) TO mapped-zrt01corr.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetInitialValues.

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    MODIFY ENTITIES OF zr_t01_corr IN LOCAL MODE
      ENTITY ZrT01Corr
        UPDATE FIELDS ( CorrDate )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky     = key-%tky
            CorrDate = lv_today
          )
        ).

  ENDMETHOD.
ENDCLASS.
