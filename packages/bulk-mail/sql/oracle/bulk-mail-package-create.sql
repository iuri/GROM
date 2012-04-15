--
-- bulk_mail logic
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-package-create.sql,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $
--

create or replace package bulk_mail
as

    function new (
        bulk_mail_id in bulk_mail_messages.bulk_mail_id%TYPE default null,
        package_id in bulk_mail_messages.package_id%TYPE,
        send_date in varchar default null,
        date_format in varchar default 'YYYY MM DD HH24 MI SS',
        status in bulk_mail_messages.status%TYPE default 'pending',
        from_addr in bulk_mail_messages.from_addr%TYPE,
        subject in bulk_mail_messages.subject%TYPE default null,
        reply_to in bulk_mail_messages.reply_to%TYPE default null,
        extra_headers in bulk_mail_messages.extra_headers%TYPE default null,
        message in varchar,
        query in varchar,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return bulk_mail_messages.bulk_mail_id%TYPE;

    procedure del (
        bulk_mail_id in bulk_mail_messages.bulk_mail_id%TYPE
    );

end bulk_mail;
/
show errors

create or replace package body bulk_mail
as

    function new (
        bulk_mail_id in bulk_mail_messages.bulk_mail_id%TYPE default null,
        package_id in bulk_mail_messages.package_id%TYPE,
        send_date in varchar default null,
        date_format in varchar default 'YYYY MM DD HH24 MI SS',
        status in bulk_mail_messages.status%TYPE default 'pending',
        from_addr in bulk_mail_messages.from_addr%TYPE,
        subject in bulk_mail_messages.subject%TYPE default null,
        reply_to in bulk_mail_messages.reply_to%TYPE default null,
        extra_headers in bulk_mail_messages.extra_headers%TYPE default null,
        message in varchar,
        query in varchar,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    ) return bulk_mail_messages.bulk_mail_id%TYPE
    is
        v_bulk_mail_id bulk_mail_messages.bulk_mail_id%TYPE;
        v_send_date varchar(4000);
    begin

        v_bulk_mail_id := acs_object.new(
            object_id => bulk_mail.new.bulk_mail_id,
            object_type => 'bulk_mail_message',
            creation_date => bulk_mail.new.creation_date,
            creation_user => bulk_mail.new.creation_user,
            creation_ip => bulk_mail.new.creation_ip,
            context_id => bulk_mail.new.context_id
        );

        v_send_date := bulk_mail.new.send_date;
        if v_send_date is null then
            select to_char(sysdate, bulk_mail.new.date_format)
            into v_send_date
            from dual;
        end if;

        insert
        into bulk_mail_messages
        (bulk_mail_id, package_id,
         send_date, status,
         from_addr, subject, reply_to,
         extra_headers, message, query)
        values
        (v_bulk_mail_id, bulk_mail.new.package_id,
         to_date(bulk_mail.new.send_date, bulk_mail.new.date_format), bulk_mail.new.status,
         bulk_mail.new.from_addr, bulk_mail.new.subject, bulk_mail.new.reply_to,
         bulk_mail.new.extra_headers, bulk_mail.new.message, bulk_mail.new.query);

        return v_bulk_mail_id;

    end new;

    procedure del (
        bulk_mail_id in bulk_mail_messages.bulk_mail_id%TYPE
    )
    is
    begin

        delete
        from bulk_mail_messages
        where bulk_mail_messages.bulk_mail_id = bulk_mail.del.bulk_mail_id;

        acs_object.del(bulk_mail.del.bulk_mail_id);

    end del;

end bulk_mail;
/
show errors
