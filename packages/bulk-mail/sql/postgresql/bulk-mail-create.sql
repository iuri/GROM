--
-- bulk_mail model create
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-create.sql,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $
--

create table bulk_mail_messages (
    bulk_mail_id                integer
                                constraint bm_messages_bulk_mail_id_fk
                                references acs_objects (object_id)
                                constraint bm_messages_bulk_mail_id_pk
                                primary key,
    package_id                  integer
                                constraint bm_messages_package_id_fk
                                references apm_packages (package_id)
                                constraint bm_messages_package_id_nn
                                not null,
    send_date                   timestamptz
                                default now()
                                constraint bm_messages_send_date_nn
                                not null,
    sent_p                      boolean
                                default 'f'
                                constraint bm_messages_sent_p_nn
                                not null,
    from_addr                   varchar(4000)
                                constraint bm_messages_from_addr_nn
                                not null,
    subject                     varchar(4000),
    reply_to                    varchar(4000),
    extra_headers               varchar(4000),
    message                     text
                                constraint bm_messages_message_nn
                                not null,
    query                       text
                                constraint bm_messages_query_nn
                                not null,
    status                      varchar(100)
                                default 'pending'
                                constraint bm_messages_status_nn
                                not null
                                
);

-- create a new object type
create function inline_0 ()
returns integer as '
begin
    perform acs_object_type__create_type(
        ''bulk_mail_message'',
        ''Bulk Mail Message'',
        ''Bulk Mail Messages'',
        ''acs_object'',
        ''bulk_mail_messages'',
        ''bulk_mail_id'',
        ''bulk_mail'',
        ''f'',
        null,
        ''acs_object__default_name''
    );

    return null;
end;' language 'plpgsql';

select inline_0();

drop function inline_0 ();

\i bulk-mail-views-create.sql
\i bulk-mail-package-create.sql
