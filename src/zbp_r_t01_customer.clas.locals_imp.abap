CLASS lhc_zr_t01_customer DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR ZrT01Customer RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrT01Customer RESULT result.
    METHODS validateCustomer FOR VALIDATE ON SAVE
      keys FOR ZrT01Customer~validateCustomer.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE ZrT01Customer.

ENDCLASS.

CLASS lhc_zr_t01_customer IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.

    result-%create = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.

  ENDMETHOD.

  METHOD earlynumbering_create.

    SELECT MAX( customer_id )
      FROM zt01_customer
      INTO @DATA(lv_max_id).

    DATA lv_next_id TYPE i.

    IF lv_max_id IS INITIAL.
      lv_next_id = 0.
    ELSE.
      lv_next_id = CONV i( lv_max_id+1 ).
    ENDIF.

    LOOP AT entities INTO DATA(entity).

      lv_next_id += 1.

      DATA(lv_customer_id) =
        |K{ lv_next_id WIDTH = 5 ALIGN = RIGHT PAD = '0' }|.

      APPEND VALUE #(
        %cid       = entity-%cid
        %key       = VALUE #( CustomerId = lv_customer_id )
        %is_draft  = entity-%is_draft
      ) TO mapped-zrt01customer.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateCustomer.

   "----------------------------------------------------------
    " Aktuelle Kundendaten aus dem RAP-Puffer lesen
    "----------------------------------------------------------
    READ ENTITIES OF zr_t01_customer IN LOCAL MODE
      ENTITY ZrT01Customer
        FIELDS (
          CategoryId
          FirstName
          LastName
          PhoneNumber
          EmailAddress
          Street
          PostalCode
          City
        )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_customers).
   "----------------------------------------------------------
    " Alle zu validierenden Kunden prüfen
    "----------------------------------------------------------
    LOOP AT lt_customers INTO DATA(ls_customer).


" Keine leeren Pflichtfelder erlauben
    IF ls_customer-CategoryId   IS INITIAL
       OR ls_customer-FirstName    IS INITIAL
       OR ls_customer-LastName     IS INITIAL
       OR ls_customer-PhoneNumber  IS INITIAL
       OR ls_customer-EmailAddress IS INITIAL
       OR ls_customer-Street       IS INITIAL
       OR ls_customer-PostalCode   IS INITIAL
       OR ls_customer-City         IS INITIAL.



        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-ZRT01CUSTOMER.

        APPEND VALUE #(
          %tky = ls_customer-%tky

          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '103'   " Bitte PK oder GK auswählen.
            severity = if_abap_behv_message=>severity-error
          )

          %element-CategoryId = if_abap_behv=>mk-on

        ) TO reported-ZRT01CUSTOMER.

      ENDIF.


      "--------------------------------------------------------
      " Vorname prüfen
      "--------------------------------------------------------
      IF ls_customer-FirstName IS INITIAL.

        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-ZRT01CUSTOMER.

        APPEND VALUE #(
          %tky = ls_customer-%tky

          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '104'
            severity = if_abap_behv_message=>severity-error
          )

          %element-FirstName = if_abap_behv=>mk-on

        ) TO reported-ZRT01CUSTOMER.

      ENDIF.


      "--------------------------------------------------------
      " Nachname prüfen
      "--------------------------------------------------------
      IF ls_customer-LastName IS INITIAL.

        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-ZRT01CUSTOMER.

        APPEND VALUE #(
          %tky = ls_customer-%tky

          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '105'
            severity = if_abap_behv_message=>severity-error
          )

          %element-LastName = if_abap_behv=>mk-on

        ) TO reported-ZRT01CUSTOMER.

      ENDIF.


      "--------------------------------------------------------
      " Telefonnummer prüfen
      "--------------------------------------------------------
      IF ls_customer-PhoneNumber IS INITIAL.

        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-ZRT01CUSTOMER.

        APPEND VALUE #(
          %tky = ls_customer-%tky

          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '106'
            severity = if_abap_behv_message=>severity-error
          )

          %element-PhoneNumber = if_abap_behv=>mk-on

        ) TO reported-ZRT01CUSTOMER.

      ENDIF.


      "--------------------------------------------------------
      " E-Mail-Adresse prüfen
      "--------------------------------------------------------
      IF ls_customer-EmailAddress IS INITIAL.

        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-ZRT01CUSTOMER.

        APPEND VALUE #(
          %tky = ls_customer-%tky

          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '107'
            severity = if_abap_behv_message=>severity-error
          )

          %element-EmailAddress = if_abap_behv=>mk-on

        ) TO reported-ZRT01CUSTOMER.

      ENDIF.


      "--------------------------------------------------------
      " Straße prüfen
      "--------------------------------------------------------
      IF ls_customer-Street IS INITIAL.

        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-ZRT01CUSTOMER.

        APPEND VALUE #(
          %tky = ls_customer-%tky

          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '108'
            severity = if_abap_behv_message=>severity-error
          )

          %element-Street = if_abap_behv=>mk-on

        ) TO reported-ZRT01CUSTOMER.

      ENDIF.


      "--------------------------------------------------------
      " Postleitzahl prüfen
      "--------------------------------------------------------
      IF ls_customer-PostalCode IS INITIAL.

        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-ZRT01CUSTOMER.

        APPEND VALUE #(
          %tky = ls_customer-%tky

          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '109'
            severity = if_abap_behv_message=>severity-error
          )

          %element-PostalCode = if_abap_behv=>mk-on

        ) TO reported-ZRT01CUSTOMER.

      ENDIF.


      "--------------------------------------------------------
      " Ort prüfen
      "--------------------------------------------------------
      IF ls_customer-City IS INITIAL.

        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-ZRT01CUSTOMER.

        APPEND VALUE #(
          %tky = ls_customer-%tky

          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '110'
            severity = if_abap_behv_message=>severity-error
          )

          %element-City = if_abap_behv=>mk-on

        ) TO reported-ZRT01CUSTOMER.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
