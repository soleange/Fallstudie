CLASS zcl_t01_daten_importieren DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_t01_daten_importieren IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "------------------------------------------------------------
    " Vorhandene Testdaten löschen
    " Reihenfolge wegen Abhängigkeiten beachten
    "------------------------------------------------------------

    " Child-Tabellen zuerst
    DELETE FROM zt01_invoice_itm.
    DELETE FROM zt01_invoice_i_d.
    DELETE FROM zt01_order_itm.
    DELETE FROM zt01_order_i_d.

    " Bewegungsdaten
    DELETE FROM zt01_invoice.
    DELETE FROM zt01_invoice_d.
    DELETE FROM zt01_order.
    DELETE FROM zt01_order_d.
    DELETE FROM zt01_correspond.
    DELETE FROM zt01_corr_d.

    " Stammdaten
    DELETE FROM zt01_customer.
    DELETE FROM zt01_customer_d.
    DELETE FROM zt01_article.
    DELETE FROM zt01_article_d.


    "------------------------------------------------------------
    " Artikel
    " ID-Schema: A + 7 Ziffern
    "------------------------------------------------------------

    INSERT zt01_article FROM TABLE @(
      VALUE #(
        ( article_id    = 'A0000001'
          category_id   = 'NB'
          article_name  = 'Notebook Business'
          price         = '1099.00'
          currency_code = 'EUR'
          unit          = 'ST'
          remarks       = 'Business Notebook' )

        ( article_id    = 'A0000002'
          category_id   = 'ST'
          article_name  = 'Desktop Office'
          price         = '899.00'
          currency_code = 'EUR'
          unit          = 'ST'
          remarks       = 'Office Desktop PC' )

        ( article_id    = 'A0000003'
          category_id   = 'MO'
          article_name  = 'Monitor 27 Zoll'
          price         = '329.00'
          currency_code = 'EUR'
          unit          = 'ST'
          remarks       = '27 Zoll Business Monitor' )

        ( article_id    = 'A0000004'
          category_id   = 'ZU'
          article_name  = 'USB-C Dock'
          price         = '119.00'
          currency_code = 'EUR'
          unit          = 'ST'
          remarks       = 'USB-C Dockingstation' )

        ( article_id    = 'A0000005'
          category_id   = 'ZU'
          article_name  = 'Tastatur Wireless'
          price         = '79.00'
          currency_code = 'EUR'
          unit          = 'ST'
          remarks       = 'Kabellose Tastatur' )

        ( article_id    = 'A0000006'
          category_id   = 'ZU'
          article_name  = 'Maus Wireless'
          price         = '49.00'
          currency_code = 'EUR'
          unit          = 'ST'
          remarks       = 'Kabellose Maus' )

        ( article_id    = 'A0000007'
          category_id   = 'DS'
          article_name  = 'Multifunktionsdrucker'
          price         = '449.00'
          currency_code = 'EUR'
          unit          = 'ST'
          remarks       = 'Drucker und Scanner' )

        ( article_id    = 'A0000008'
          category_id   = 'SW'
          article_name  = 'Office Software'
          price         = '199.00'
          currency_code = 'EUR'
          unit          = 'ST'
          remarks       = 'Office Software Lizenz' )
      )
    ).


    "------------------------------------------------------------
    " Kunden
    " ID-Schema: K + 5 Ziffern
    "------------------------------------------------------------

    INSERT zt01_customer FROM TABLE @(
      VALUE #(
        ( customer_id   = 'K00001'
          category_id   = 'GK'
          company_name  = 'Nordstern GmbH'
          title         = ''
          first_name    = 'Anna'
          last_name     = 'Weber'
          phone_number  = '+49 40 1234567'
          email_address = 'anna.weber@nordstern.de'
          street        = 'Hafenstrasse 12'
          postal_code   = '20457'
          city          = 'Hamburg'
          country_code  = 'DE'
          remarks       = 'Geschaeftskunde' )

        ( customer_id   = 'K00002'
          category_id   = 'GK'
          company_name  = 'Rheinwerk Solutions GmbH'
          title         = ''
          first_name    = 'Thomas'
          last_name     = 'Becker'
          phone_number  = '+49 221 223344'
          email_address = 'thomas.becker@rheinwerk.de'
          street        = 'Domstrasse 8'
          postal_code   = '50667'
          city          = 'Koeln'
          country_code  = 'DE'
          remarks       = 'Geschaeftskunde' )

        ( customer_id   = 'K00003'
          category_id   = 'PK'
          company_name  = ''
          title         = 'Dr.'
          first_name    = 'Julia'
          last_name     = 'Schmidt'
          phone_number  = '+49 89 334455'
          email_address = 'julia.schmidt@example.de'
          street        = 'Isarweg 17'
          postal_code   = '80331'
          city          = 'Muenchen'
          country_code  = 'DE'
          remarks       = 'Privatkunde' )

        ( customer_id   = 'K00004'
          category_id   = 'GK'
          company_name  = 'Spree Consulting AG'
          title         = ''
          first_name    = 'Daniel'
          last_name     = 'Krueger'
          phone_number  = '+49 30 556677'
          email_address = 'daniel.krueger@spree-consulting.de'
          street        = 'Alexanderplatz 4'
          postal_code   = '10178'
          city          = 'Berlin'
          country_code  = 'DE'
          remarks       = 'Geschaeftskunde' )

        ( customer_id   = 'K00005'
          category_id   = 'PK'
          company_name  = ''
          title         = ''
          first_name    = 'Laura'
          last_name     = 'Fischer'
          phone_number  = '+49 711 667788'
          email_address = 'laura.fischer@example.de'
          street        = 'Koenigstrasse 25'
          postal_code   = '70173'
          city          = 'Stuttgart'
          country_code  = 'DE'
          remarks       = 'Privatkunde' )
      )
    ).


    "------------------------------------------------------------
    " Aufträge
    " ORDER_ID bleibt NUMC(8)
    "------------------------------------------------------------

    INSERT zt01_order FROM TABLE @(
      VALUE #(
        ( order_id      = '00000001'
          customer_id   = 'K00001'
          status_id     = '03'
          order_date    = '20260702'
          total_amount  = '2436.00'
          currency_code = 'EUR'
          remarks       = 'Komplettauftrag' )

        ( order_id      = '00000002'
          customer_id   = 'K00002'
          status_id     = '02'
          order_date    = '20260710'
          total_amount  = '1556.00'
          currency_code = 'EUR'
          remarks       = 'Rechnung erstellt' )

        ( order_id      = '00000003'
          customer_id   = 'K00003'
          status_id     = '01'
          order_date    = '20260715'
          total_amount  = '0.00'
          currency_code = 'EUR'
          remarks       = 'Auftrag noch ohne Position' )

        ( order_id      = '00000004'
          customer_id   = 'K00004'
          status_id     = '03'
          order_date    = '20260720'
          total_amount  = '1798.00'
          currency_code = 'EUR'
          remarks       = 'Desktop-Arbeitsplaetze' )

        ( order_id      = '00000005'
          customer_id   = 'K00005'
          status_id     = '03'
          order_date    = '20260801'
          total_amount  = '727.00'
          currency_code = 'EUR'
          remarks       = 'Privatkundenauftrag' )

        ( order_id      = '00000006'
          customer_id   = 'K00001'
          status_id     = '03'
          order_date    = '20260810'
          total_amount  = '1193.00'
          currency_code = 'EUR'
          remarks       = 'Software und Zubehoer' )

        " Neue offene Aufträge
        ( order_id      = '00000007'
          customer_id   = 'K00002'
          status_id     = '01'
          order_date    = '20260901'
          total_amount  = '2198.00'
          currency_code = 'EUR'
          remarks       = 'Offener Auftrag - Notebooks' )

        ( order_id      = '00000008'
          customer_id   = 'K00003'
          status_id     = '01'
          order_date    = '20260902'
          total_amount  = '658.00'
          currency_code = 'EUR'
          remarks       = 'Offener Auftrag - Monitore' )

        ( order_id      = '00000009'
          customer_id   = 'K00004'
          status_id     = '01'
          order_date    = '20260903'
          total_amount  = '238.00'
          currency_code = 'EUR'
          remarks       = 'Offener Auftrag - Dockingstations' )

        ( order_id      = '00000010'
          customer_id   = 'K00005'
          status_id     = '01'
          order_date    = '20260904'
          total_amount  = '158.00'
          currency_code = 'EUR'
          remarks       = 'Offener Auftrag - Tastaturen' )

        ( order_id      = '00000011'
          customer_id   = 'K00001'
          status_id     = '01'
          order_date    = '20260905'
          total_amount  = '199.00'
          currency_code = 'EUR'
          remarks       = 'Offener Auftrag - Software' )
      )
    ).


    "------------------------------------------------------------
    " Auftragspositionen
    "------------------------------------------------------------

    INSERT zt01_order_itm FROM TABLE @(
      VALUE #(
        ( order_id         = '00000001'
          itemline_no      = '1'
          article_id       = 'A0000001'
          article_name     = 'Notebook Business'
          article_quantity = 2
          unit             = 'ST'
          unit_price       = '1099.00'
          net_amount       = '2198.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000001'
          itemline_no      = '2'
          article_id       = 'A0000004'
          article_name     = 'USB-C Dock'
          article_quantity = 2
          unit             = 'ST'
          unit_price       = '119.00'
          net_amount       = '238.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000002'
          itemline_no      = '1'
          article_id       = 'A0000003'
          article_name     = 'Monitor 27 Zoll'
          article_quantity = 3
          unit             = 'ST'
          unit_price       = '329.00'
          net_amount       = '987.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000002'
          itemline_no      = '2'
          article_id       = 'A0000007'
          article_name     = 'Multifunktionsdrucker'
          article_quantity = 1
          unit             = 'ST'
          unit_price       = '449.00'
          net_amount       = '449.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000002'
          itemline_no      = '3'
          article_id       = 'A0000005'
          article_name     = 'Tastatur Wireless'
          article_quantity = 1
          unit             = 'ST'
          unit_price       = '79.00'
          net_amount       = '79.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000002'
          itemline_no      = '4'
          article_id       = 'A0000006'
          article_name     = 'Maus Wireless'
          article_quantity = 1
          unit             = 'ST'
          unit_price       = '49.00'
          net_amount       = '49.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000004'
          itemline_no      = '1'
          article_id       = 'A0000002'
          article_name     = 'Desktop Office'
          article_quantity = 2
          unit             = 'ST'
          unit_price       = '899.00'
          net_amount       = '1798.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000005'
          itemline_no      = '1'
          article_id       = 'A0000003'
          article_name     = 'Monitor 27 Zoll'
          article_quantity = 1
          unit             = 'ST'
          unit_price       = '329.00'
          net_amount       = '329.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000005'
          itemline_no      = '2'
          article_id       = 'A0000008'
          article_name     = 'Office Software'
          article_quantity = 2
          unit             = 'ST'
          unit_price       = '199.00'
          net_amount       = '398.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000006'
          itemline_no      = '1'
          article_id       = 'A0000008'
          article_name     = 'Office Software'
          article_quantity = 5
          unit             = 'ST'
          unit_price       = '199.00'
          net_amount       = '995.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000006'
          itemline_no      = '2'
          article_id       = 'A0000005'
          article_name     = 'Tastatur Wireless'
          article_quantity = 1
          unit             = 'ST'
          unit_price       = '79.00'
          net_amount       = '79.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000006'
          itemline_no      = '3'
          article_id       = 'A0000004'
          article_name     = 'USB-C Dock'
          article_quantity = 1
          unit             = 'ST'
          unit_price       = '119.00'
          net_amount       = '119.00'
          currency_code    = 'EUR' )

        " Positionen für die 5 neuen offenen Aufträge

        ( order_id         = '00000007'
          itemline_no      = '1'
          article_id       = 'A0000001'
          article_name     = 'Notebook Business'
          article_quantity = 2
          unit             = 'ST'
          unit_price       = '1099.00'
          net_amount       = '2198.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000008'
          itemline_no      = '1'
          article_id       = 'A0000003'
          article_name     = 'Monitor 27 Zoll'
          article_quantity = 2
          unit             = 'ST'
          unit_price       = '329.00'
          net_amount       = '658.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000009'
          itemline_no      = '1'
          article_id       = 'A0000004'
          article_name     = 'USB-C Dock'
          article_quantity = 2
          unit             = 'ST'
          unit_price       = '119.00'
          net_amount       = '238.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000010'
          itemline_no      = '1'
          article_id       = 'A0000005'
          article_name     = 'Tastatur Wireless'
          article_quantity = 2
          unit             = 'ST'
          unit_price       = '79.00'
          net_amount       = '158.00'
          currency_code    = 'EUR' )

        ( order_id         = '00000011'
          itemline_no      = '1'
          article_id       = 'A0000008'
          article_name     = 'Office Software'
          article_quantity = 1
          unit             = 'ST'
          unit_price       = '199.00'
          net_amount       = '199.00'
          currency_code    = 'EUR' )
      )
    ).


    "------------------------------------------------------------
    " Rechnungen
    " INVOICE_ID bleibt NUMC(8)
    "------------------------------------------------------------

    INSERT zt01_invoice FROM TABLE @(
      VALUE #(
        ( invoice_id    = '00000001'
          order_id      = '00000001'
          customer_id   = 'K00001'
          status_id     = '03'
          invoice_date  = '20260703'
          tax_amount    = '389.04'
          total_amount  = '2436.00'
          currency_code = 'EUR'
          remarks       = 'Bezahlt' )

        ( invoice_id    = '00000002'
          order_id      = '00000002'
          customer_id   = 'K00002'
          status_id     = '09'
          invoice_date  = '20260711'
          tax_amount    = '248.50'
          total_amount  = '1556.00'
          currency_code = 'EUR'
          remarks       = 'Storniert wegen Korrektur' )

        ( invoice_id    = '00000003'
          order_id      = '00000002'
          customer_id   = 'K00002'
          status_id     = '03'
          invoice_date  = '20260712'
          tax_amount    = '248.50'
          total_amount  = '1556.00'
          currency_code = 'EUR'
          remarks       = 'Ersatzrechnung' )

        ( invoice_id    = '00000004'
          order_id      = '00000004'
          customer_id   = 'K00004'
          status_id     = '03'
          invoice_date  = '20260721'
          tax_amount    = '287.08'
          total_amount  = '1798.00'
          currency_code = 'EUR'
          remarks       = 'Bezahlt' )

        ( invoice_id    = '00000005'
          order_id      = '00000005'
          customer_id   = 'K00005'
          status_id     = '04'
          invoice_date  = '20260802'
          tax_amount    = '116.08'
          total_amount  = '727.00'
          currency_code = 'EUR'
          remarks       = 'Zahlungsverzug' )
      )
    ).


    "------------------------------------------------------------
    " Rechnungspositionen
    "------------------------------------------------------------

    INSERT zt01_invoice_itm FROM TABLE @(
      VALUE #(
        ( invoice_id        = '00000001'
          itemline_no       = '1'
          itemline_no_order = '1'
          article_id        = 'A0000001'
          article_name      = 'Notebook Business'
          article_quantity  = 2
          unit              = 'ST'
          unit_price        = '1099.00'
          total_amount      = '2198.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000001'
          itemline_no       = '2'
          itemline_no_order = '2'
          article_id        = 'A0000004'
          article_name      = 'USB-C Dock'
          article_quantity  = 2
          unit              = 'ST'
          unit_price        = '119.00'
          total_amount      = '238.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000002'
          itemline_no       = '1'
          itemline_no_order = '1'
          article_id        = 'A0000003'
          article_name      = 'Monitor 27 Zoll'
          article_quantity  = 3
          unit              = 'ST'
          unit_price        = '329.00'
          total_amount      = '987.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000003'
          itemline_no       = '1'
          itemline_no_order = '1'
          article_id        = 'A0000003'
          article_name      = 'Monitor 27 Zoll'
          article_quantity  = 3
          unit              = 'ST'
          unit_price        = '329.00'
          total_amount      = '987.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000003'
          itemline_no       = '2'
          itemline_no_order = '2'
          article_id        = 'A0000007'
          article_name      = 'Multifunktionsdrucker'
          article_quantity  = 1
          unit              = 'ST'
          unit_price        = '449.00'
          total_amount      = '449.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000003'
          itemline_no       = '3'
          itemline_no_order = '3'
          article_id        = 'A0000005'
          article_name      = 'Tastatur Wireless'
          article_quantity  = 1
          unit              = 'ST'
          unit_price        = '79.00'
          total_amount      = '79.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000003'
          itemline_no       = '4'
          itemline_no_order = '4'
          article_id        = 'A0000006'
          article_name      = 'Maus Wireless'
          article_quantity  = 1
          unit              = 'ST'
          unit_price        = '49.00'
          total_amount      = '49.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000004'
          itemline_no       = '1'
          itemline_no_order = '1'
          article_id        = 'A0000002'
          article_name      = 'Desktop Office'
          article_quantity  = 2
          unit              = 'ST'
          unit_price        = '899.00'
          total_amount      = '1798.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000005'
          itemline_no       = '1'
          itemline_no_order = '1'
          article_id        = 'A0000003'
          article_name      = 'Monitor 27 Zoll'
          article_quantity  = 1
          unit              = 'ST'
          unit_price        = '329.00'
          total_amount      = '329.00'
          currency_code     = 'EUR' )

        ( invoice_id        = '00000005'
          itemline_no       = '2'
          itemline_no_order = '2'
          article_id        = 'A0000008'
          article_name      = 'Office Software'
          article_quantity  = 2
          unit              = 'ST'
          unit_price        = '199.00'
          total_amount      = '398.00'
          currency_code     = 'EUR' )
      )
    ).


    "------------------------------------------------------------
    " Korrespondenz
    " CORR_ID bleibt NUMC(8)
    "------------------------------------------------------------

    INSERT zt01_correspond FROM TABLE @(
      VALUE #(
        ( corr_id      = '00000001'
          customer_id  = 'K00001'
          status_id    = '03'
          corr_date    = '20260625'
          text         = 'Anfrage zu neuen Business Notebooks.'
          text_type    = '01'
          remarks      = 'Vertriebskontakt' )

        ( corr_id      = '00000002'
          customer_id  = 'K00001'
          status_id    = '03'
          corr_date    = '20260704'
          text         = 'Kunde bestaetigt erfolgreichen Erhalt der Lieferung.'
          text_type    = '01'
          remarks      = 'Nachfassaktion' )

        ( corr_id      = '00000003'
          customer_id  = 'K00002'
          status_id    = '03'
          corr_date    = '20260711'
          text         = 'Rechnung muss korrigiert und neu erstellt werden.'
          text_type    = '03'
          remarks      = 'Interne Notiz' )

        ( corr_id      = '00000004'
          customer_id  = 'K00003'
          status_id    = '01'
          corr_date    = '20260715'
          text         = 'Kunde bittet um Beratung zu einem neuen Arbeitsplatz.'
          text_type    = '01'
          remarks      = 'Offene Anfrage' )

        ( corr_id      = '00000005'
          customer_id  = 'K00004'
          status_id    = '02'
          corr_date    = '20260722'
          text         = 'Dankesschreiben und Rechnung wurden versendet.'
          text_type    = '02'
          remarks      = 'Brief versendet' )

        ( corr_id      = '00000006'
          customer_id  = 'K00005'
          status_id    = '02'
          corr_date    = '20260820'
          text         = 'Zahlungserinnerung zur offenen Rechnung.'
          text_type    = '01'
          remarks      = 'Mahnung' )
      )
    ).


    COMMIT WORK.

    out->write(
      |Testdaten erfolgreich angelegt.|
    ).

  ENDMETHOD.

ENDCLASS.
