CLASS lhc_ZrT01Order DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR ZrT01Order RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrT01Order RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE ZrT01Order.

    METHODS earlynumbering_cba_OrdersItm FOR NUMBERING
      IMPORTING entities FOR CREATE ZrT01Order\_Orders_Itm.

    METHODS SetInitialValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01Order~SetInitialValues.

    METHODS CreateInvoice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01Order~CreateInvoice.

    METHODS ValidateArticle FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrT01OrderITM~ValidateArticle.

    METHODS ValidateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrT01Order~ValidateCustomer.

    METHODS ValidateOrderItems FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrT01Order~ValidateOrderItems.

ENDCLASS.


CLASS lhc_ZrT01Order IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.


  METHOD get_global_authorizations.

    result-%create = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.

  ENDMETHOD.


  METHOD earlynumbering_create.

    SELECT MAX( order_id )
      FROM zt01_order
      INTO @DATA(lv_max_id).

    DATA(lv_next_id) = CONV i( lv_max_id ).

    LOOP AT entities INTO DATA(entity).

      lv_next_id += 1.

      DATA(lv_order_id) =
        |{ lv_next_id WIDTH = 8 ALIGN = RIGHT PAD = '0' }|.

      APPEND VALUE #(
        %cid      = entity-%cid
        %key      = VALUE #( OrderId = lv_order_id )
        %is_draft = entity-%is_draft
      ) TO mapped-zrt01order.

    ENDLOOP.

  ENDMETHOD.


  METHOD earlynumbering_cba_OrdersItm.

    LOOP AT entities INTO DATA(entity).

      SELECT MAX( itemline_no )
        FROM zt01_order_itm
        WHERE order_id = @entity-OrderId
        INTO @DATA(lv_max_active).

      SELECT MAX( itemlineno )
        FROM zt01_order_i_d
        WHERE orderid = @entity-OrderId
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
            OrderId    = entity-OrderId
            ItemlineNo = lv_itemline_no
          )
          %is_draft = target-%is_draft
        ) TO mapped-zrt01orderitm.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD SetInitialValues.

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    MODIFY ENTITIES OF zr_t01_order IN LOCAL MODE
      ENTITY ZrT01Order
        UPDATE FIELDS (
          StatusId
          OrderDate
          CurrencyCode
        )
        WITH VALUE #(
          FOR key IN keys
          (
            %tky         = key-%tky
            StatusId     = '01'
            OrderDate    = lv_today
            CurrencyCode = 'EUR'
          )
        ).

  ENDMETHOD.


  METHOD CreateInvoice.

    " Bestellung lesen
    READ ENTITIES OF zr_t01_order IN LOCAL MODE
      ENTITY ZrT01Order
        FIELDS (
          OrderId
          CustomerId
          StatusId
          TotalAmount
          CurrencyCode
        )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    LOOP AT lt_orders INTO DATA(ls_order).

      " Nur bei Status 02 = Rechnung erstellt
      IF ls_order-StatusId <> '02'.
        CONTINUE.
      ENDIF.

      " Prüfen, ob bereits eine nicht stornierte Rechnung existiert
      SELECT SINGLE invoice_id
        FROM zt01_invoice
        WHERE order_id  = @ls_order-OrderId
          AND status_id <> '09'
        INTO @DATA(lv_existing_invoice).

      IF sy-subrc = 0.
        CONTINUE.
      ENDIF.


      "------------------------------------------------------------
      " Bestellpositionen lesen
      "------------------------------------------------------------

      READ ENTITIES OF zr_t01_order IN LOCAL MODE
        ENTITY ZrT01Order
          BY \_Orders_Itm
          FIELDS (
            ItemlineNo
            ArticleId
            ArticleName
            ArticleQuantity
            Unit
            UnitPrice
            NetAmount
            CurrencyCode
            Remarks
          )
          WITH VALUE #(
            (
              OrderId   = ls_order-OrderId
              %is_draft = ls_order-%is_draft
            )
          )
        RESULT DATA(lt_order_items).


      "------------------------------------------------------------
      " Steuer aus Bruttobetrag berechnen
      " Brutto = 119 %
      "------------------------------------------------------------

      DATA lv_tax_amount TYPE zt01_invoice-tax_amount.

      lv_tax_amount = ls_order-TotalAmount * 19 / 119.


      "------------------------------------------------------------
      " Rechnungskopf anlegen
      " InvoiceId kommt über Early Numbering
      "------------------------------------------------------------

      MODIFY ENTITIES OF zr_t01_invoice
        ENTITY ZrT01Invoice
          CREATE FIELDS (
            OrderId
            CustomerId
            StatusId
            InvoiceDate
            TaxAmount
            TotalAmount
            CurrencyCode
            Remarks
          )
          WITH VALUE #(
            (
              %cid         = 'INVOICE'
              OrderId      = ls_order-OrderId
              CustomerId   = ls_order-CustomerId
              StatusId     = '01'
              InvoiceDate  = cl_abap_context_info=>get_system_date( )
              TaxAmount    = lv_tax_amount
              TotalAmount  = ls_order-TotalAmount
              CurrencyCode = ls_order-CurrencyCode
              Remarks      = 'Automatisch aus Bestellung erstellt'
            )
          )
        MAPPED DATA(lt_mapped_invoice)
        FAILED DATA(lt_failed_invoice)
        REPORTED DATA(lt_reported_invoice).


      " Wenn Rechnung nicht angelegt werden konnte -> nächste Bestellung
      IF lt_failed_invoice IS NOT INITIAL.
        CONTINUE.
      ENDIF.


      "------------------------------------------------------------
      " Neue InvoiceId aus Early Numbering holen
      "------------------------------------------------------------

      READ TABLE lt_mapped_invoice-zrt01invoice
        INDEX 1
        INTO DATA(ls_mapped_invoice).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      DATA(lv_invoice_id) = ls_mapped_invoice-InvoiceId.


      "------------------------------------------------------------
      " Rechnungspositionen aus Bestellpositionen erzeugen
      "------------------------------------------------------------

      MODIFY ENTITIES OF zr_t01_invoice
        ENTITY ZrT01Invoice
          CREATE BY \_Invoice_Itm
          FIELDS (
            ItemlineNoOrder
            ArticleId
            ArticleName
            ArticleQuantity
            Unit
            UnitPrice
            TotalAmount
            CurrencyCode
            Remarks
          )
          WITH VALUE #(
            (
              InvoiceId = lv_invoice_id

              %target = VALUE #(
                FOR ls_item IN lt_order_items
                (
                  %cid            = |INVITEM{ ls_item-ItemlineNo }|
                  ItemlineNoOrder = ls_item-ItemlineNo
                  ArticleId       = ls_item-ArticleId
                  ArticleName     = ls_item-ArticleName
                  ArticleQuantity = ls_item-ArticleQuantity
                  Unit            = ls_item-Unit
                  UnitPrice       = ls_item-UnitPrice
                  TotalAmount     = ls_item-NetAmount
                  CurrencyCode    = ls_item-CurrencyCode
                  Remarks         = ls_item-Remarks
                )
              )
            )
          )
        MAPPED DATA(lt_mapped_items)
        FAILED DATA(lt_failed_items)
        REPORTED DATA(lt_reported_items).

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidateArticle.

    READ ENTITIES OF zr_t01_order IN LOCAL MODE
      ENTITY ZrT01OrderITM
        FIELDS ( ArticleId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).

      IF ls_item-ArticleId IS INITIAL.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-zrt01orderitm.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message(
            id       = 'ZT01_MSG'
            number   = '001' "/*" 001 = Bitte einen Artikel eingeben.
            severity = if_abap_behv_message=>severity-error
          )
          %element-ArticleId = if_abap_behv=>mk-on
        ) TO reported-zrt01orderitm.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidateCustomer.

    READ ENTITIES OF zr_t01_order IN LOCAL MODE
      ENTITY ZrT01Order
        FIELDS ( CustomerId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    LOOP AT lt_orders INTO DATA(ls_order).

      IF ls_order-CustomerId IS INITIAL.

        APPEND VALUE #(
          %tky = ls_order-%tky
        ) TO failed-zrt01order.

        APPEND VALUE #(
          %tky = ls_order-%tky

          %msg = new_message(
            id       = 'ZT01_MSG'
            number   = '002'
            severity = if_abap_behv_message=>severity-error
          )

          %element-CustomerId = if_abap_behv=>mk-on
        ) TO reported-zrt01order.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD ValidateOrderItems.

  READ ENTITIES OF zr_t01_order IN LOCAL MODE
    ENTITY ZrT01Order
      FIELDS ( StatusId )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_orders).

  LOOP AT lt_orders INTO DATA(ls_order).

    " Nur prüfen, wenn Status 02 gesetzt ist
    IF ls_order-StatusId = '02'. "002 = Bitte einen Kunden auswählen.

      READ ENTITIES OF zr_t01_order IN LOCAL MODE
        ENTITY ZrT01Order
          BY \_Orders_Itm
          FIELDS ( ItemlineNo )
          WITH VALUE #(
            (
              OrderId   = ls_order-OrderId
              %is_draft = ls_order-%is_draft
            )
          )
        RESULT DATA(lt_items).

      IF lt_items IS INITIAL.

        APPEND VALUE #(
          %tky = ls_order-%tky
        ) TO failed-zrt01order.

        APPEND VALUE #(
          %tky = ls_order-%tky

          %msg = new_message(
            id       = 'ZT01_MSG'
            number   = '003' "003 = Eine Bestellung benötigt mindestens eine Position.
            severity = if_abap_behv_message=>severity-error
          )

          %element-StatusId = if_abap_behv=>mk-on
        ) TO reported-zrt01order.

      ENDIF.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.



CLASS lhc_ZrT01OrderITM DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS RecalcOrderTotal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01OrderITM~RecalcOrderTotal.

    METHODS SetArticleData FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01OrderITM~SetArticleData.

    METHODS CalculateNetAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrT01OrderITM~CalculateNetAmount.

ENDCLASS.



CLASS lhc_ZrT01OrderITM IMPLEMENTATION.

  METHOD RecalcOrderTotal.

    LOOP AT keys INTO DATA(key).

      READ ENTITIES OF zr_t01_order IN LOCAL MODE
        ENTITY ZrT01Order
          BY \_Orders_Itm
          FIELDS (
            NetAmount
          )
          WITH VALUE #(
            (
              OrderId   = key-OrderId
              %is_draft = key-%is_draft
            )
          )
        RESULT DATA(lt_items).

      DATA lv_total TYPE zt01_order-total_amount.

      CLEAR lv_total.

      LOOP AT lt_items INTO DATA(ls_item).
        lv_total += ls_item-NetAmount.
      ENDLOOP.

      MODIFY ENTITIES OF zr_t01_order IN LOCAL MODE
        ENTITY ZrT01Order
          UPDATE FIELDS (
            TotalAmount
          )
          WITH VALUE #(
            (
              OrderId     = key-OrderId
              %is_draft   = key-%is_draft
              TotalAmount = lv_total
            )
          ).

    ENDLOOP.

  ENDMETHOD.


  METHOD SetArticleData.

    READ ENTITIES OF zr_t01_order IN LOCAL MODE
      ENTITY ZrT01OrderITM
        FIELDS (
          ArticleId
        )
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

        MODIFY ENTITIES OF zr_t01_order IN LOCAL MODE
          ENTITY ZrT01OrderITM
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


  METHOD CalculateNetAmount.

    READ ENTITIES OF zr_t01_order IN LOCAL MODE
      ENTITY ZrT01OrderITM
        FIELDS (
          ArticleQuantity
          UnitPrice
        )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    MODIFY ENTITIES OF zr_t01_order IN LOCAL MODE
      ENTITY ZrT01OrderITM
        UPDATE FIELDS (
          NetAmount
        )
        WITH VALUE #(
          FOR item IN lt_items
          (
            %tky      = item-%tky
            NetAmount = item-ArticleQuantity * item-UnitPrice
          )
        ).

  ENDMETHOD.

ENDCLASS.
