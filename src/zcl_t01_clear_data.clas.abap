CLASS zcl_t01_clear_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_t01_clear_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " Child-Tabellen zuerst

*    DELETE FROM zt01_invoice_itm.
*    DELETE FROM zt01_invoice_i_d.
*
*    DELETE FROM zt01_order_itm.
*    DELETE FROM zt01_order_i_d.
*
*    " Bewegungsdaten
*
*    DELETE FROM zt01_invoice.
*    DELETE FROM zt01_invoice_d.
*
*    DELETE FROM zt01_order.
*    DELETE FROM zt01_order_d.
*
*    DELETE FROM zt01_correspond.
*    DELETE FROM zt01_corr_d.
*
*    " Stammdaten
*
*    DELETE FROM zt01_customer.
    DELETE FROM zt01_customer_d.
*
*    DELETE FROM zt01_article.
*    DELETE FROM zt01_article_d.

    COMMIT WORK.

    out->write( 'Alle T01-Testdaten wurden gelöscht.' ).

  ENDMETHOD.

ENDCLASS.
