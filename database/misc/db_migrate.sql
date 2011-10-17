--
-- This file is part of the knowhow ERP, a free and open source
-- Enterprise Resource Planning software suite,
-- Copyright (c) 2010-2011 by bring.out doo Sarajevo.
-- It is licensed to you under the Common Public Attribution License
-- version 1.0, the full text of which (including knowhow-specific Exhibits)
-- is available in the file LICENSE_CPAL_bring.out_knowhow.md located at the
-- root directory of this source code archive.
-- By using this software, you agree to be bound by its terms.
--

------------------------------------------------
-- init
-- postojece funkcije
------------------------------------------------

SELECT u2.execute($$

CREATE OR REPLACE FUNCTION public.uomusedforitem(integer)
  RETURNS SETOF uom AS
$BODY$
DECLARE
  pitemid       ALIAS FOR $1;
  _row          uom%ROWTYPE;
BEGIN
  FOR _row IN SELECT DISTINCT *
              FROM uom
              WHERE uom_id IN (
                SELECT bomitem_uom_id AS uom_id 
                FROM bomitem 
                WHERE (bomitem_item_id=pitemid)
                UNION 
                SELECT cmitem_qty_uom_id 
                FROM cmitem, itemsite 
                WHERE ((cmitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT cmitem_price_uom_id 
                FROM cmitem, itemsite 
                WHERE ((cmitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT coitem_qty_uom_id 
                FROM coitem, itemsite 
                WHERE ((coitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT coitem_price_uom_id 
                FROM coitem, itemsite 
                WHERE ((coitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT invcitem_qty_uom_id 
                FROM invcitem 
                WHERE ((invcitem_item_id=pitemid))
                UNION 
                SELECT invcitem_price_uom_id 
                FROM invcitem 
                WHERE ((invcitem_item_id=pitemid))
                UNION 
                SELECT ipsitem_qty_uom_id 
                FROM ipsitem 
                WHERE (ipsitem_item_id=pitemid)
                UNION 
                SELECT ipsitem_price_uom_id 
                FROM ipsitem 
                WHERE (ipsitem_item_id=pitemid)
                UNION 
                SELECT quitem_qty_uom_id 
                FROM quitem, itemsite 
                WHERE ((quitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT quitem_price_uom_id 
                FROM quitem, itemsite 
                WHERE ((quitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT womatl_uom_id 
                FROM womatl, itemsite 
                WHERE ((womatl_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
  ) LOOP
    RETURN NEXT _row;
  END LOOP;

  IF (fetchmetricbool('MultiWhs')) THEN
    FOR _row IN SELECT DISTINCT *
                FROM uom
                WHERE uom_id IN (
                  SELECT rahist_uom_id 
                  FROM rahist, itemsite 
                  WHERE ((rahist_itemsite_id=itemsite_id)
                     AND (itemsite_item_id=pitemid))
    ) LOOP
      RETURN NEXT _row;
    END LOOP;
  END IF;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.uomusedforitem(integer)
  OWNER TO admin;


$$) 
WHERE (u2.knowhow_package_version('xtunlock') < 100);
------------------------------------------------
-- end 
-------------------------------------------------


------------------------------------------------
-- verzija 0.1.1
-- unlock funkcije
------------------------------------------------

SELECT u2.execute($$


CREATE OR REPLACE FUNCTION public.uomusedforitem(integer)
  RETURNS SETOF uom AS
$BODY$
DECLARE
  pitemid       ALIAS FOR $1;
  _row          uom%ROWTYPE;
BEGIN
  FOR _row IN SELECT DISTINCT *
              FROM uom
              WHERE uom_id IN (
                SELECT bomitem_uom_id AS uom_id 
                FROM bomitem 
                WHERE (bomitem_item_id=pitemid)
                UNION 
                SELECT cmitem_qty_uom_id 
                FROM cmitem, itemsite 
                WHERE ((cmitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT cmitem_price_uom_id 
                FROM cmitem, itemsite 
                WHERE ((cmitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT coitem_qty_uom_id 
                FROM coitem, itemsite 
                WHERE ((coitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT coitem_price_uom_id 
                FROM coitem, itemsite 
                WHERE ((coitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT invcitem_qty_uom_id 
                FROM invcitem 
                WHERE ((invcitem_item_id=pitemid))
                UNION 
                SELECT invcitem_price_uom_id 
                FROM invcitem 
                WHERE ((invcitem_item_id=pitemid))
                UNION 
                SELECT ipsitem_qty_uom_id 
                FROM ipsitem 
                WHERE (ipsitem_item_id=pitemid)
                UNION 
                SELECT ipsitem_price_uom_id 
                FROM ipsitem 
                WHERE (ipsitem_item_id=pitemid)
                UNION 
                SELECT quitem_qty_uom_id 
                FROM quitem, itemsite 
                WHERE ((quitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT quitem_price_uom_id 
                FROM quitem, itemsite 
                WHERE ((quitem_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
                UNION 
                SELECT womatl_uom_id 
                FROM womatl, itemsite 
                WHERE ((womatl_itemsite_id=itemsite_id)
                   AND (itemsite_item_id=pitemid))
  ) LOOP
    RETURN NEXT _row;
  END LOOP;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.uomusedforitem(integer)
  OWNER TO admin;

$$) 
WHERE (u2.knowhow_package_version('xtunlock') <= 10100);
------------------------------------------------
-- end 
-------------------------------------------------



-- ##########################################
-- na kraju setujemo novu verziju iz pkghead
SELECT u2.set_knowhow_package_version('xtunlock');
-- ##########################################
