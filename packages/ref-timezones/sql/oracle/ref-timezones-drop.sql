-- packages/acs-reference/sql/common/timezone-drop.sql
--
-- Drop the timezone package
--
-- @author  jon@jongriffin.com
-- @created 2000-12-04
-- @cvs-id  $Id: ref-timezones-drop.sql,v 1.2 2010/11/26 10:35:20 po34demo Exp $

declare
    v_repository_id integer;
begin
    select repository_id into v_repository_id
    from   acs_reference_repositories
    where  lower(table_name) = 'timezones';

    acs_reference.del(v_repository_id);
end;
/
show errors;

drop sequence timezone_seq;
drop table    timezone_rules;
drop table    timezones;
drop package  timezone;


