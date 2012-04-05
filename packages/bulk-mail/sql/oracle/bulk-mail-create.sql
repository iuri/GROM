--
-- bulk_mail model create
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-create.sql,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $
--

create table bulk_mail_messages (
    bulk_mail_id                constraint bm_messages_bulk_mail_id_fk
                                references acs_objects (object_id)
                                constraint bm_messages_bulk_mail_id_pk
                                primary key,
    package_id                  constraint bm_messages_package_id_fk
                                references apm_packages (package_id)
                                constraint bm_messages_package_id_nn
                                not null,
    send_date                   date
                                default sysdate
                                constraint bm_messages_send_date_nn
                                not null,
    from_addr                   varchar(4000)
                                constraint bm_messages_from_addr_nn
                                not null,
    subject                     varchar(4000),
    reply_to                    varchar(4000),
    extra_headers               varchar(4000),
    message                     clob
                                constraint bm_messages_message_nn
                                not null,
    query                       clob
                                constraint bm_messages_query_nn
                                not null,
    status                      varchar2(100)
                                default 'pending'
                                constraint bm_messages_status_ck
                                check (status in ('pending', 'sent'))
                                constraint bm_messages_status_nn
                                not null
);

-- create a new object type
begin
    acs_object_type.create_type(
        supertype => 'acs_object',
        object_type => 'bulk_mail_message',
        pretty_name => 'Bulk Mail Message',
        pretty_plural => 'Bulk Mail Messages',
        table_name => 'bulk_mail_messages',
        id_column => 'bulk_mail_id',
        package_name => 'bulk_mail',
        name_method => 'acs_object.default_name'
    );
end;
/
show errors

@@ bulk-mail-views-create.sql
@@ bulk-mail-package-create.sql
