CLASS lhc_zr_t01_article DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR ZrT01Article RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR ZrT01Article RESULT result.
    METHODS validateArticle FOR VALIDATE ON SAVE
       keys FOR ZrT01Article~validateArticle.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE ZrT01Article.

ENDCLASS.

CLASS LHC_ZR_T01_Article IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.

    result-%create = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.

  ENDMETHOD.

  METHOD earlynumbering_create.

    SELECT MAX( article_id )
      FROM zt01_article
      INTO @DATA(lv_max_id).

    DATA(lv_next_id) = CONV i( lv_max_id+1 ).

    LOOP AT entities INTO DATA(entity).

      lv_next_id += 1.

      DATA(lv_article_id) =
       |A{ lv_next_id WIDTH = 7 ALIGN = RIGHT PAD = '0' }|.


      APPEND VALUE #(
        %cid      = entity-%cid
        %key      = VALUE #( ArticleId = lv_article_id )
        %is_draft = entity-%is_draft

      ) TO mapped-zrt01article.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateArticle.


    " Aktuelle Artikeldaten aus dem RAP-Puffer lesen
    READ ENTITIES OF zr_t01_article IN LOCAL MODE
      ENTITY ZrT01Article
        FIELDS (
          CategoryId
          ArticleName
          Price
          CurrencyCode
          Unit
        )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_articles).

    " Alle betroffenen Artikel prüfen
    LOOP AT lt_articles INTO DATA(ls_article).


      " Artikelkategorie prüfen
      IF ls_article-CategoryId IS INITIAL
      OR ls_article-Price IS INITIAL
      OR ls_article-CurrencyCode IS INITIAL
      OR ls_article-Unit IS INITIAL.

        APPEND VALUE #(
          %tky = ls_article-%tky
        ) TO failed-ZrT01Article.

        APPEND VALUE #(
          %tky = ls_article-%tky
          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '201'
            severity = if_abap_behv_message=>severity-error
          )
          %element-CategoryId = if_abap_behv=>mk-on
        ) TO reported-ZrT01Article.

      ENDIF.


      " Artikelbezeichnung prüfen
      IF ls_article-ArticleName IS INITIAL.

        APPEND VALUE #(
          %tky = ls_article-%tky
        ) TO failed-ZrT01Article.

        APPEND VALUE #(
          %tky = ls_article-%tky
          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '202'
            severity = if_abap_behv_message=>severity-error
          )
          %element-ArticleName = if_abap_behv=>mk-on
        ) TO reported-ZrT01Article.

      ENDIF.


      " Preis prüfen
      IF ls_article-Price IS INITIAL.

        APPEND VALUE #(
          %tky = ls_article-%tky
        ) TO failed-ZrT01Article.

        APPEND VALUE #(
          %tky = ls_article-%tky
          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '203'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Price = if_abap_behv=>mk-on
        ) TO reported-ZrT01Article.

      ENDIF.


      " Währung prüfen
      IF ls_article-CurrencyCode IS INITIAL.

        APPEND VALUE #(
          %tky = ls_article-%tky
        ) TO failed-ZrT01Article.

        APPEND VALUE #(
          %tky = ls_article-%tky
          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '204'
            severity = if_abap_behv_message=>severity-error
          )
          %element-CurrencyCode = if_abap_behv=>mk-on
        ) TO reported-ZrT01Article.

      ENDIF.


      " Mengeneinheit prüfen
      IF ls_article-Unit IS INITIAL.

        APPEND VALUE #(
          %tky = ls_article-%tky
        ) TO failed-ZrT01Article.

        APPEND VALUE #(
          %tky = ls_article-%tky
          %msg = new_message(
            id       = 'ZT01_MESSAGE'
            number   = '205'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Unit = if_abap_behv=>mk-on
        ) TO reported-ZrT01Article.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
