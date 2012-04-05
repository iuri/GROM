-- @cvs-id $Id: organizations-drop.sql,v 1.1.1.1 2007/04/29 23:38:30 cognovis Exp $

select drop_package('organization');

-- drop permissions
delete from acs_permissions where object_id in (select organization_id from organizations);

-- drop objects

create function inline_0()
returns integer as '
declare
        object_rec              record;
begin
        for object_rec in select object_id from acs_objects where object_type=''organization''
        loop
                perform acs_object__delete( object_rec.object_id );
        end loop;
        return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

--drop table
drop table organization_type_map;

drop table organizations cascade;

--drop type
select acs_object_type__drop_type(
           'organization',
           't'
    );


drop table organization_types; 




