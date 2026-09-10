CLASS lhc_ZR_T01_INVOICE DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR ZrT01Invoice RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrT01Invoice RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE ZrT01Invoice.

    METHODS earlynumbering_cba_InvoiceItm FOR NUMBERING
      IMPORTING entities FOR CREATE ZrT01Invoice\_Invoice_Itm.

    METHODS SetInitialValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01Invoice~SetInitialValues.

ENDCLASS.


CLASS lhc_ZR_T01_INVOICE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD get_global_authorizations.

    result-%create = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.

  ENDMETHOD.


  METHOD earlynumbering_create.

    SELECT MAX( invoice_id )
      FROM zt01_invoice
      INTO @DATA(lv_max_active).

    SELECT MAX( invoiceid )
      FROM zt01_invoice_d
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

      DATA(lv_invoice_id) =
        |{ lv_next_id WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.

      APPEND VALUE #(
        %cid      = entity-%cid
        %key      = VALUE #( InvoiceId = lv_invoice_id )
        %is_draft = entity-%is_draft
      ) TO mapped-zrt01invoice.

    ENDLOOP.

  ENDMETHOD.


  METHOD earlynumbering_cba_InvoiceItm.

    LOOP AT entities INTO DATA(entity).

      SELECT MAX( itemline_no )
        FROM zt01_invoice_itm
        WHERE invoice_id = @entity-InvoiceId
        INTO @DATA(lv_max_active).

      SELECT MAX( itemlineno )
        FROM zt01_invoice_i_d
        WHERE invoiceid = @entity-InvoiceId
        INTO @DATA(lv_max_draft).

      DATA(lv_max_itemline) =
        COND #(
          WHEN lv_max_draft > lv_max_active
          THEN lv_max_draft
          ELSE lv_max_active
        ).

      DATA(lv_next_itemline) = CONV i( lv_max_itemline ).

      LOOP AT entity-%target INTO DATA(target).

        lv_next_itemline += 1.

        DATA(lv_itemline_no) =
          |{ lv_next_itemline WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.

        APPEND VALUE #(
          %cid = target-%cid
          %key = VALUE #(
            InvoiceId  = entity-InvoiceId
            ItemlineNo = lv_itemline_no
          )
          %is_draft = target-%is_draft
        ) TO mapped-zrt01invoiceitm.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetInitialValues.

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    MODIFY ENTITIES OF zr_t01_invoice IN LOCAL MODE
      ENTITY ZrT01Invoice
        UPDATE FIELDS (
          StatusId
          InvoiceDate
          CurrencyCode
        )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky         = key-%tky
            StatusId     = '01'
            InvoiceDate  = lv_today
            CurrencyCode = 'EUR'
          )
        ).

  ENDMETHOD.

ENDCLASS.



CLASS lhc_ZrT01InvoiceITM DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS ValidateArticle FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrT01InvoiceITM~ValidateArticle.

    METHODS CalculateTotalAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01InvoiceITM~CalculateTotalAmount.

    METHODS RecalcInvoiceTotal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01InvoiceITM~RecalcInvoiceTotal.

    METHODS SetArticleData FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01InvoiceITM~SetArticleData.

ENDCLASS.


CLASS lhc_ZrT01InvoiceITM IMPLEMENTATION.

  METHOD ValidateArticle.

    READ ENTITIES OF zr_t01_invoice IN LOCAL MODE
      ENTITY ZrT01InvoiceITM
        FIELDS ( ArticleId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).

      IF ls_item-ArticleId IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-zrt01invoiceitm.

        APPEND VALUE #(
          %tky = ls_item-%tky

          %msg = new_message(
            id       = 'ZT01_MSG'
            number   = '001' "Bitte einen Artikel auswählen.
            severity = if_abap_behv_message=>severity-error
          )

          %element-ArticleId = if_abap_behv=>mk-on
        ) TO reported-zrt01invoiceitm.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD CalculateTotalAmount.

    READ ENTITIES OF zr_t01_invoice IN LOCAL MODE
      ENTITY ZrT01InvoiceITM
        FIELDS (
          ArticleQuantity
          UnitPrice
        )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    MODIFY ENTITIES OF zr_t01_invoice IN LOCAL MODE
      ENTITY ZrT01InvoiceITM
        UPDATE FIELDS (
          TotalAmount
        )
        WITH VALUE #(
          FOR item IN lt_items
          (
            %tky        = item-%tky
            TotalAmount = item-ArticleQuantity * item-UnitPrice
          )
        ).

  ENDMETHOD.


  METHOD RecalcInvoiceTotal.

    LOOP AT keys INTO DATA(key).

      READ ENTITIES OF zr_t01_invoice IN LOCAL MODE
        ENTITY ZrT01Invoice
          BY \_Invoice_Itm
          FIELDS ( TotalAmount )
          WITH VALUE #(
            (
              InvoiceId = key-InvoiceId
              %is_draft = key-%is_draft
            )
          )
        RESULT DATA(lt_items).

      DATA lv_total TYPE zt01_invoice-total_amount.
      CLEAR lv_total.

      LOOP AT lt_items INTO DATA(ls_item).
        lv_total += ls_item-TotalAmount.
      ENDLOOP.

      DATA lv_tax TYPE zt01_invoice-tax_amount.

      lv_tax = lv_total * 19 / 119.

      MODIFY ENTITIES OF zr_t01_invoice IN LOCAL MODE
        ENTITY ZrT01Invoice
          UPDATE FIELDS (
            TotalAmount
            TaxAmount
          )
          WITH VALUE #(
            (
              InvoiceId   = key-InvoiceId
              %is_draft   = key-%is_draft
              TotalAmount = lv_total
              TaxAmount   = lv_tax
            )
          ).

    ENDLOOP.

  ENDMETHOD.

  METHOD SetArticleData.

    READ ENTITIES OF zr_t01_invoice IN LOCAL MODE
      ENTITY ZrT01InvoiceITM
        FIELDS ( ArticleId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).

      SELECT SINGLE
        article_name,
        price,
        unit
        FROM zt01_article
        WHERE article_id = @ls_item-ArticleId
        INTO @DATA(ls_article).

      IF sy-subrc = 0.

        MODIFY ENTITIES OF zr_t01_invoice IN LOCAL MODE
          ENTITY ZrT01InvoiceITM
            UPDATE FIELDS (
              ArticleName
              Unit
              UnitPrice
              CurrencyCode
            )
            WITH VALUE #(
              (
                %tky         = ls_item-%tky
                ArticleName  = ls_article-article_name
                Unit         = ls_article-unit
                UnitPrice    = ls_article-price
                CurrencyCode = 'EUR'
              )
            ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
