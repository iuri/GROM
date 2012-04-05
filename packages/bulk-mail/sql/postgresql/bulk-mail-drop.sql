--
-- bulk_mail model drop
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-drop.sql,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $
--

create function inline_0 ()
returns integer as'
declare
    row RECORD;
begin

    for row in select bulk_mail_id from bulk_mail_messages loop
        perform bulk_mail__delete(row.bulk_mail_id);
    end loop;

    perform acs_object_type__drop_type(''bulk_mail_message'', ''f'');

    return null;

end;' language 'plpgsql';

select inline_0();

drop function inline_0 ();

\i bulk-mail-package-drop.sql
\i bulk-mail-views-drop.sql

drop table bulk_mail_messages;
