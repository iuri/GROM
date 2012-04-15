-- packages/postal_address/sql/postgresql/postal_address-plsql.sql
--
-- @author Jon Griffin
-- @creation-date 26 February 2003
-- @cvs-id $Id: postal-address-plsql.sql,v 1.1.1.1 2007/04/29 23:39:27 cognovis Exp $

-- What no comments?

declare
begin 
    acs_object_type.create_type (  
      object_type => 'postal_address',
      pretty_name => 'Postal Address',
      pretty_plural => 'Postal Address',
      supertype => 'acs_object',
      table_name => 'postal_addresses',
      id_column => 'address_id',
      package_name => 'postal_address',
      abstract_p => 'f',
      type_extension_table => null,
      name_method => null
  ); 
end;
/

CREATE OR REPLACE PACKAGE postal_address
AS

    FUNCTION new ( 
        additional_text         in postal_addresses.additional_text%TYPE
                                default null,
        address_id              in postal_addresses.address_id%TYPE
                                default null,
        country_code            in postal_addresses.country_code%TYPE,
        delivery_address        in postal_addresses.delivery_address%TYPE,
        municipality            in postal_addresses.municipality%TYPE
                                default null,
        party_id                in parties.party_id%TYPE
                                default null,
        postal_code             in postal_addresses.postal_code%TYPE
                                default null,
        postal_type             in postal_addresses.postal_type%TYPE
                                default null,
        region                  in postal_addresses.region%TYPE
                                default null,
        creation_user           in acs_objects.creation_user%TYPE
                                default null,
        creation_ip             in acs_objects.creation_ip%TYPE
                                default null,
        context_id              in acs_objects.context_id%TYPE
                                default null,
        security_inherit_p      in acs_objects.security_inherit_p%TYPE
                                default 'f'
    ) RETURN postal_addresses.address_id%TYPE;
    
    -- use del instead of delete to prevent 9i naming problems
    PROCEDURE del (
        address_id              in postal_addresses.address_id%TYPE
    );

    FUNCTION clone (
        address_id              in postal_addresses.address_id%TYPE
    ) RETURN postal_addresses.address_id%TYPE;

END;
/
show errors

CREATE OR REPLACE PACKAGE BODY postal_address
AS

    FUNCTION new ( 
        additional_text         in postal_addresses.additional_text%TYPE
                                default null,
        address_id              in postal_addresses.address_id%TYPE
                                default null,
        country_code            in postal_addresses.country_code%TYPE,
        delivery_address        in postal_addresses.delivery_address%TYPE,
        municipality            in postal_addresses.municipality%TYPE
                                default null,
        party_id                in parties.party_id%TYPE
                                default null,
        postal_code             in postal_addresses.postal_code%TYPE
                                default null,
        postal_type             in postal_addresses.postal_type%TYPE
                                default null,
        region                  in postal_addresses.region%TYPE
                                default null,
        creation_user           in acs_objects.creation_user%TYPE
                                default null,
        creation_ip             in acs_objects.creation_ip%TYPE
                                default null,
        context_id              in acs_objects.context_id%TYPE
                                default null,
        security_inherit_p      in acs_objects.security_inherit_p%TYPE
                                default 'f'
    ) RETURN postal_addresses.address_id%TYPE IS
        -- local vars
        v_address_id postal_addresses.address_id%TYPE; 
    BEGIN 
      v_address_id := acs_object.new (  
        null,  
        'postal_address',
        sysdate, 
        creation_user, 
        creation_ip, 
        context_id 
      );   
       
      update acs_objects set security_inherit_p = security_inherit_p
      where object_id = v_address_id;

      insert into postal_addresses (
        additional_text,
        address_id,
        country_code,
        delivery_address,
        municipality,
        party_id,
        postal_code,
        postal_type,
        region 
      )  
      values ( 
        additional_text,
        v_address_id,
        country_code,
        delivery_address,
        municipality,
        party_id,
        postal_code,
        postal_type,
        region 
      ); 

      IF creation_user IS NOT NULL THEN
          acs_permission.grant_permission (
              v_address_id,
              creation_user,
              'admin'
          );
      END IF;

      return v_address_id;

    END new;

    PROCEDURE del (
        address_id              in postal_addresses.address_id%TYPE
    ) IS
    BEGIN 

       delete from acs_permissions 
         where object_id = del.address_id; 

       delete from postal_addresses 
         where address_id = del.address_id;

       acs_object.del(del.address_id);

    END del;

    FUNCTION clone (
        address_id              in postal_addresses.address_id%TYPE
    ) RETURN postal_addresses.address_id%TYPE IS
        v_address_id    postal_addresses.address_id%TYPE;
    BEGIN
        IF clone.address_id IS NULL THEN RETURN null; END IF;

        FOR x IN
                (SELECT * FROM postal_addresses
                   INNER JOIN acs_objects ON object_id = address_id
                 WHERE address_id = clone.address_id)
        LOOP
            v_address_id := postal_address.new(
                additional_text => x.additional_text,
                country_code => x.country_code,
                delivery_address => x.delivery_address,
                municipality => x.municipality,
                party_id => x.party_id,
                postal_code => x.postal_code,
                postal_type => x.postal_type,
                region => x.region,
                creation_user => x.creation_user,
                creation_ip => x.creation_ip,
                context_id => x.context_id
            );
        END LOOP;

        RETURN v_address_id;
    END clone;

END postal_address;
/
show errors
