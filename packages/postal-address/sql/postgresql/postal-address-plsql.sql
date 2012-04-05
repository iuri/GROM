-- packages/postal_address/sql/postgresql/postal_address-plsql.sql
--
-- @author Jon Griffin
-- @creation-date 26 February 2003
-- @cvs-id $Id: postal-address-plsql.sql,v 1.1.1.1 2007/04/29 23:39:27 cognovis Exp $

-- What no comments?

create function inline_0 () 
returns integer as '  
begin 
    PERFORM acs_object_type__create_type (  
      ''postal_address'', -- object_type  
      ''Postal Address'', -- pretty_name 
      ''Postal Address'',  -- pretty_plural 
      ''acs_object'',   -- supertype 
      ''postal_addresses'',  -- table_name 
      ''address_id'', -- id_column 
      ''postal_address'', -- package_name 
      ''f'', -- abstract_p 
      null, -- type_extension_table 
      null -- name_method 
  ); 
 
  return 0;  
end;' language 'plpgsql'; 

select inline_0 (); 

drop function inline_0 ();

------ start of oacs new proc
create or replace function postal_address__new ( varchar,integer,char,varchar,varchar,
integer,varchar,integer,varchar,integer,varchar,integer )
returns integer as ' 
declare 
    p_additional_text     alias for $1; -- comment
    p_address_id          alias for $2; -- comment
    p_country_code        alias for $3; -- comment
    p_delivery_address    alias for $4; -- comment
    p_municipality        alias for $5; -- comment
    p_party_id            alias for $6; -- comment
    p_postal_code         alias for $7; -- comment
    p_postal_type         alias for $8; -- comment
    p_region              alias for $9; -- comment
    p_creation_user       alias for $10; -- comment
    p_creation_ip         alias for $11; -- comment
    p_context_id          alias for $12; -- comment

    -- local vars
    v_address_id postal_addresses.address_id%TYPE; 
begin 
  v_address_id := acs_object__new (  
    null,  
    ''postal_address'',
    now(), 
    p_creation_user, 
    p_creation_ip, 
    p_context_id 
  );   
   

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
    p_additional_text,
    v_address_id,
    p_country_code,
    p_delivery_address,
    p_municipality,
    p_party_id,
    p_postal_code,
    p_postal_type,
    p_region 
  ); 

  PERFORM acs_permission__grant_permission (
     v_address_id,
     p_creation_user,
     ''admin''
  );

   raise NOTICE ''Adding postal_address - %'',v_address_id;
  return v_address_id;

end;' language 'plpgsql';

------ end new proc

create or replace function postal_address__del (integer) 
returns integer as ' 
declare 
 p_address_id    alias for $1; 
 v_return integer := 0;  
begin 

   delete from acs_permissions 
     where object_id = p_address_id; 

   delete from postal_addresses 
     where address_id = p_address_id;

   raise NOTICE ''Deleting postal_address - %'',p_address_id;

   PERFORM acs_object__delete(p_address_id);

   return v_return;

end;' language 'plpgsql';