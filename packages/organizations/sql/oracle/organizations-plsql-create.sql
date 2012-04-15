-- packages/organization/sql/oracle/organization-plsql.sql
--
-- @author Jon Griffin
-- @creation-date 13 March 2003
-- @cvs-id $Id: organizations-plsql-create.sql,v 1.1.1.1 2007/04/29 23:38:30 cognovis Exp $

begin 
  acs_object_type.create_type (  
    object_type   => 'organization',
    pretty_name   => 'Organization', 
    pretty_plural => 'Organizations', 
    supertype     => 'party',
    table_name    => 'organizations',
    id_column     => 'organization_id'
  ); 
end;
/
show errors

create or replace package organization
as
    function new (
        p_organization_id       in organizations.organization_id%TYPE default null,
        p_legal_name            in organizations.legal_name%TYPE,
        p_name                  in organizations.name%TYPE,
        p_notes                 in organizations.notes%TYPE default null,
        p_reg_number            in organizations.reg_number%TYPE default null,
        p_email                 in parties.email%TYPE default null,
        p_url                   in parties.url%TYPE default null,
        p_object_type           in acs_objects.object_type%TYPE default 'organization',
        p_creation_date         in acs_objects.creation_date%TYPE default sysdate,
        p_creation_user         in acs_objects.creation_user%TYPE default null,
        p_creation_ip           in acs_objects.creation_ip%TYPE default null,
        p_context_id            in acs_objects.context_id%TYPE default null
    ) return organizations.organization_id%TYPE;

    procedure del (
        p_organization_id in organizations.organization_id%TYPE
    );

end organization;
/
show errors


-- behavior is different between oracle and postgres. Postgres
-- version adds in the first organization_type to the organization_type_map
-- table, to specify which type this organization is.
create or replace package body organization
as
    function new (
        p_organization_id       in organizations.organization_id%TYPE default null,
        p_legal_name            in organizations.legal_name%TYPE,
        p_name                  in organizations.name%TYPE,
        p_notes                 in organizations.notes%TYPE default null,
        p_reg_number            in organizations.reg_number%TYPE default null,
        p_email                 in parties.email%TYPE default null,
        p_url                   in parties.url%TYPE default null,
        p_object_type           in acs_objects.object_type%TYPE default 'organization',
        p_creation_date         in acs_objects.creation_date%TYPE default sysdate,
        p_creation_user         in acs_objects.creation_user%TYPE default null,
        p_creation_ip           in acs_objects.creation_ip%TYPE default null,
        p_context_id            in acs_objects.context_id%TYPE default null
    ) return organizations.organization_id%TYPE
    is
      v_organization_id organizations.organization_id%TYPE;
    begin
  v_organization_id := party.new (  
    party_id		=> null, 
    object_type		=> p_object_type,
    creation_user	=> p_creation_user,
    creation_ip		=> p_creation_ip,
    email		=> p_email, 
    url			=> p_url,
    context_id		=> p_context_id 
  );   
   

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

  acs_permission.grant_permission (
      object_id  => v_organization_id,
      grantee_id => p_creation_user,
      privilege  => 'admin'
  );
  return v_organization_id;
end new;

    --
    --
  procedure del (
      p_organization_id in organizations.organization_id%TYPE
  ) 
  is
  begin

   -- these delete statements should not be necessary
   delete from acs_permissions 
     where object_id = organization.del.p_organization_id; 

   -- need to remove items from organization_type_map, like postgres
   delete from organizations 
     where organization_id = organization.del.p_organization_id;

   party.del(organization.del.p_organization_id);

  end del;
  
end organization;
/
show errors

-- name function is missing in Oracle version!! Need to port from Postgres
