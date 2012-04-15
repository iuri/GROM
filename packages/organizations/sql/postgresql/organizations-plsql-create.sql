-- packages/organization/sql/postgresql/organization-plsql.sql
--
-- @author Jon Griffin
-- @creation-date 24 February 2003
-- @cvs-id $Id: organizations-plsql-create.sql,v 1.1.1.1 2007/04/29 23:38:30 cognovis Exp $

-- What no comments?

create function inline_0 () 
returns integer as '  
begin 
    PERFORM acs_object_type__create_type (  
      ''organization'',      -- object_type  
      ''Organization'',      -- pretty_name 
      ''Organization'',      -- pretty_plural 
      ''party'',             -- supertype 
      ''organizations'',     -- table_name 
      ''organization_id'',   -- id_column 
      ''organization'',      -- package_name 
      ''f'',                 -- abstract_p 
      null,                  -- type_extension_table 
      ''organization__name'' -- name_method 
  ); 
 
  return 0;  
end;' language 'plpgsql'; 

select inline_0 (); 

drop function inline_0 ();



------ start of oacs new proc
select define_function_args('organization__new','legal_name,name,notes,organization_id,organization_type_id,reg_number,email,url,creation_user,creation_ip,context_id'); 

create or replace function organization__new ( 
	varchar, -- legal_name
	varchar, -- name
	text,    -- notes
	integer, -- organization_id
	integer, -- organization_type_id
	varchar, -- reg_number
	varchar, -- email
	varchar, -- url
	integer, -- creation_user
	varchar, -- creation_ip
	integer  -- context_id
) returns integer as ' 
declare 
    p_legal_name           alias for $1; -- comment
    p_name                 alias for $2; -- comment
    p_notes                alias for $3; -- comment
    p_organization_id      alias for $4; -- comment
    p_organization_type_id alias for $5; -- comment
    p_reg_number           alias for $6; -- comment
    p_email                alias for $7; -- email
    p_url                  alias for $8;
    p_creation_user        alias for $9; -- comment
    p_creation_ip          alias for $10;
    p_context_id           alias for $11; -- comment

    -- local vars
    v_organization_id organizations.organization_id%TYPE; 
begin 
  v_organization_id := party__new (  
    p_organization_id,     -- party_id
    ''organization'',
    now(), 
    p_creation_user,
    p_creation_ip,
    p_email, 
    p_url,
    p_context_id 
  );   
   
  update acs_objects
  set title = p_name
  where object_id = v_organization_id;

  insert into organizations (
    legal_name,
    name,
    notes,
    organization_id,
    reg_number 
  )  
  values ( 
    p_legal_name,
    p_name,
    p_notes,
    v_organization_id,
    p_reg_number 
  ); 

  insert into organization_type_map (
    organization_id,
    organization_type_id
  ) values (
    v_organization_id,
    p_organization_type_id
  );

  PERFORM acs_permission__grant_permission (
     v_organization_id,
     p_creation_user,
     ''admin''
  );

   raise NOTICE ''Adding organization - %'',p_name;
  return v_organization_id;

end;' language 'plpgsql';

------ end new proc


------ start of oacs del proc
select define_function_args('organization__del','organization_id'); 

create or replace function organization__del (integer) 
returns integer as ' 
declare 
 p_organization_id    alias for $1; 
 v_return integer := 0;  
begin 

   -- these should not be necessary
   delete from acs_permissions 
     where object_id = p_organization_id; 

   delete from organization_type_map
     where organization_id = p_organization_id;

   delete from organizations 
     where organization_id = p_organization_id;

   raise NOTICE ''Deleting organization - %'',p_organization_id;

   PERFORM party__delete(p_organization_id);

   return v_return;

end;' language 'plpgsql';

------ end del proc


------ start of oacs set proc
select define_function_args('organization__set','legal_name,name,notes,organization_id,reg_number'); 

create or replace function organization__set (varchar,varchar,text,integer,varchar)
returns integer as ' 
declare 
    p_legal_name         alias for $1; -- comment
    p_name               alias for $2; -- comment
    p_notes              alias for $3; -- comment
    p_organization_id    alias for $4; -- comment
    p_reg_number         alias for $5; -- comment

    v_return integer := 0; 
begin 

  update organizations
  set 
    legal_name = p_legal_name,
    name = p_name,
    notes = p_notes,
    organization_id = p_organization_id,
    reg_number = p_reg_number
  where organization_id = p_organization_id;

  raise NOTICE ''Updating  - organization - %'',p_organization_id;

return v_return;
end;' language 'plpgsql';

------ end set proc


------ start of oacs name proc
select define_function_args('organization___name','organization_id');

create or replace function organization__name (integer)
returns varchar as '
declare
    p_organization_id    alias for $1;
    v_organization_name  organizations.name%TYPE;
begin
        select name || ''_'' || organization_id into v_organization_name
                from organizations
                where organization_id = p_organization_id;
    return v_organization_name;
end;
' language 'plpgsql';
------ end name proc

-- create functions for organization_rels
select define_function_args('organization_rel__new','rel_id,rel_type;organization_rel,object_id_one,object_id_two,creation_user,creation_ip');

create or replace function organization_rel__new (integer,varchar,integer,integer,integer,varchar)
returns integer as '
declare
  new__rel_id            alias for $1;  -- default null  
  rel_type               alias for $2;  -- default ''organization_rel''
  object_id_one          alias for $3;  
  object_id_two          alias for $4;  
  creation_user          alias for $5;  -- default null
  creation_ip            alias for $6;  -- default null
  v_rel_id               integer;       
begin
    v_rel_id := acs_rel__new (
      new__rel_id,
      rel_type,
      object_id_one,
      object_id_two,
      object_id_one,
      creation_user,
      creation_ip
    );

    return v_rel_id;
   
end;' language 'plpgsql';

-- function new
create or replace function organization_rel__new (integer,integer)
returns integer as '
declare
  object_id_one          alias for $1;  
  object_id_two          alias for $2;  
begin
        return organization_rel__new(null,
                                    ''organization_rel'',
                                    object_id_one,
                                    object_id_two,
                                    null,
                                    null);
end;' language 'plpgsql';

-- procedure delete
create or replace function organization_rel__delete (integer)
returns integer as '
declare
  rel_id                 alias for $1;  
begin
    PERFORM acs_rel__delete(rel_id);

    return 0; 
end;' language 'plpgsql';
