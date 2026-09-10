CLASS zcl_t01_revenue_itm_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

ENDCLASS.


CLASS zcl_t01_revenue_itm_query IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA(lo_paging) = io_request->get_paging( ).
    DATA(lv_offset) = lo_paging->get_offset( ).
    DATA(lv_page_size) = lo_paging->get_page_size( ).

    TRY.
        DATA(lt_filter_ranges) =
          io_request->get_filter( )->get_as_ranges( ).

      CATCH cx_rap_query_filter_no_range.
        CLEAR lt_filter_ranges.
    ENDTRY.


    TYPES: BEGIN OF ty_revenue,
             revenuerowkey     TYPE c LENGTH 30,
             customerid        TYPE c LENGTH 8,
             customerdisplay   TYPE c LENGTH 100,
             companyname       TYPE c LENGTH 80,
             firstname         TYPE c LENGTH 40,
             lastname          TYPE c LENGTH 40,
             orderid           TYPE c LENGTH 8,
             orderdate         TYPE d,
             invoiceid         TYPE c LENGTH 8,
             invoicedate       TYPE d,
             invoicestatus     TYPE c LENGTH 2,
             invoicestatusname TYPE c LENGTH 40,
             itemlineno        TYPE c LENGTH 8,
             itemlinenoorder   TYPE c LENGTH 8,
             articleid         TYPE c LENGTH 20,
             articlename       TYPE c LENGTH 80,
             articlequantity   TYPE zt01_invoice_itm-article_quantity,
             unit              TYPE zt01_invoice_itm-unit,
             unitprice         TYPE zt01_invoice_itm-unit_price,
             quantitydisplay   TYPE c LENGTH 25,
             unitpricedisplay  TYPE c LENGTH 30,
             positionamount    TYPE zt01_invoice_itm-total_amount,
             currencycode      TYPE zt01_invoice_itm-currency_code,
           END OF ty_revenue.

    DATA lt_revenue TYPE STANDARD TABLE OF ty_revenue WITH EMPTY KEY.


    DATA lr_customer_id    TYPE RANGE OF zt01_customer-customer_id.
    DATA lr_company_name   TYPE RANGE OF zt01_customer-company_name.
    DATA lr_order_id       TYPE RANGE OF zt01_order-order_id.
    DATA lr_invoice_id     TYPE RANGE OF zt01_invoice-invoice_id.
    DATA lr_invoice_status TYPE RANGE OF zt01_invoice-status_id.
    DATA lr_article_id     TYPE RANGE OF zt01_invoice_itm-article_id.
    DATA lr_article_name   TYPE RANGE OF zt01_invoice_itm-article_name.


    LOOP AT lt_filter_ranges INTO DATA(ls_filter).

      CASE to_upper( ls_filter-name ).

        WHEN 'CUSTOMERID'.
          lr_customer_id =
            CORRESPONDING #( ls_filter-range ).

        WHEN 'COMPANYNAME'.
          lr_company_name =
            CORRESPONDING #( ls_filter-range ).

        WHEN 'ORDERID'.
          lr_order_id =
            CORRESPONDING #( ls_filter-range ).

        WHEN 'INVOICEID'.
          lr_invoice_id =
            CORRESPONDING #( ls_filter-range ).

        WHEN 'INVOICESTATUS'.
          lr_invoice_status =
            CORRESPONDING #( ls_filter-range ).

        WHEN 'ARTICLEID'.
          lr_article_id =
            CORRESPONDING #( ls_filter-range ).

        WHEN 'ARTICLENAME'.
          lr_article_name =
            CORRESPONDING #( ls_filter-range ).

      ENDCASE.

    ENDLOOP.


    DATA(lv_no_customer) =
      xsdbool( lr_customer_id IS INITIAL ).

    DATA(lv_no_company) =
      xsdbool( lr_company_name IS INITIAL ).

    DATA(lv_no_order) =
      xsdbool( lr_order_id IS INITIAL ).

    DATA(lv_no_invoice) =
      xsdbool( lr_invoice_id IS INITIAL ).

    DATA(lv_no_status) =
      xsdbool( lr_invoice_status IS INITIAL ).

    DATA(lv_no_article) =
      xsdbool( lr_article_id IS INITIAL ).

    DATA(lv_no_article_name) =
      xsdbool( lr_article_name IS INITIAL ).


    SELECT

      ii~invoice_id        AS invoiceid,
      i~customer_id        AS customerid,
      c~company_name       AS companyname,
      c~first_name         AS firstname,
      c~last_name          AS lastname,
      i~order_id           AS orderid,
      o~order_date         AS orderdate,
      i~invoice_date       AS invoicedate,
      i~status_id          AS invoicestatus,
      s~statusname         AS invoicestatusname,
      ii~itemline_no       AS itemlineno,
      ii~itemline_no_order AS itemlinenoorder,
      ii~article_id        AS articleid,
      ii~article_name      AS articlename,
      ii~article_quantity  AS articlequantity,
      ii~unit              AS unit,
      ii~unit_price        AS unitprice,
      ii~total_amount      AS positionamount,
      ii~currency_code     AS currencycode

      FROM zt01_invoice_itm AS ii

      INNER JOIN zt01_invoice AS i
        ON i~invoice_id = ii~invoice_id

      INNER JOIN zt01_customer AS c
        ON c~customer_id = i~customer_id

      INNER JOIN zt01_order AS o
        ON o~order_id = i~order_id

      LEFT OUTER JOIN zi_t01_fv_invoice_status AS s
        ON s~statusid = i~status_id

      WHERE
            ( @lv_no_customer = 'X'
              OR i~customer_id IN @lr_customer_id )

        AND ( @lv_no_company = 'X'
              OR c~company_name IN @lr_company_name )

        AND ( @lv_no_order = 'X'
              OR i~order_id IN @lr_order_id )

        AND ( @lv_no_invoice = 'X'
              OR i~invoice_id IN @lr_invoice_id )

        AND ( @lv_no_status = 'X'
              OR i~status_id IN @lr_invoice_status )

        AND ( @lv_no_article = 'X'
              OR ii~article_id IN @lr_article_id )

        AND ( @lv_no_article_name = 'X'
              OR ii~article_name IN @lr_article_name )

        AND i~status_id <> '09'

      INTO CORRESPONDING FIELDS OF TABLE @lt_revenue.


    LOOP AT lt_revenue ASSIGNING FIELD-SYMBOL(<ls_revenue>).

      <ls_revenue>-revenuerowkey =
        |{ <ls_revenue>-invoiceid }-{ <ls_revenue>-itemlineno }|.

      IF <ls_revenue>-companyname IS NOT INITIAL.

        <ls_revenue>-customerdisplay =
          <ls_revenue>-companyname.

      ELSE.

        <ls_revenue>-customerdisplay =
          |{ <ls_revenue>-firstname } { <ls_revenue>-lastname }|.

      ENDIF.

      <ls_revenue>-quantitydisplay =
        |{ <ls_revenue>-articlequantity } { <ls_revenue>-unit }|.

      <ls_revenue>-unitpricedisplay =
        |{ <ls_revenue>-unitprice } { <ls_revenue>-currencycode }|.

    ENDLOOP.


    DATA(lv_total_revenue) =
      CONV zt01_invoice_itm-total_amount( 0 ).

    LOOP AT lt_revenue INTO DATA(ls_revenue).

      lv_total_revenue +=
        ls_revenue-positionamount.

    ENDLOOP.


    IF lt_revenue IS NOT INITIAL.

      DATA(lv_currency) =
        lt_revenue[ 1 ]-currencycode.

      APPEND VALUE #(

        revenuerowkey     = 'TOTAL'
        customerid        = 'GESAMT'
        customerdisplay   = ''
        companyname       = ''
        firstname         = ''
        lastname          = ''
        orderid           = ''
        orderdate         = '00000000'
        invoiceid         = ''
        invoicedate       = '00000000'
        invoicestatus     = ''
        invoicestatusname = ''
        itemlineno        = ''
        itemlinenoorder   = ''
        articleid         = ''
        articlename       = ''
        unit              = ''
        positionamount    = lv_total_revenue
        currencycode      = lv_currency

      ) TO lt_revenue.

    ENDIF.


    io_response->set_total_number_of_records(
      lines( lt_revenue )
    ).

    io_response->set_data( lt_revenue ).

  ENDMETHOD.

ENDCLASS.
