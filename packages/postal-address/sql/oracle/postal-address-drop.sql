------------------------------------------------------------------------------
-- Drop script for the postal_address type
--
-- @author Tom Ayles (tom@beatniq.net)
-- @cvs-id $Id: postal-address-drop.sql,v 1.1.1.1 2007/04/29 23:39:27 cognovis Exp $
------------------------------------------------------------------------------

BEGIN
  FOR v_address IN (SELECT address_id FROM postal_addresses) LOOP
    postal_address.del( v_address.address_id );
  END LOOP;

  acs_object_type.drop_type('postal_address','f');
END;
/

DROP PACKAGE postal_address;

DROP TABLE postal_addresses;

DROP TABLE postal_types;
