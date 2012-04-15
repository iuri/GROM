<?xml version="1.0"?>

<queryset>

    <fullquery name="select_message_info">
        <querytext>
            select bulk_mail_messages.bulk_mail_id,
                   to_char(bulk_mail_messages.send_date, 'Mon DD YYYY HH24:MI') as send_date,
                   bulk_mail_messages.status,
                   bulk_mail_messages.from_addr,
                   bulk_mail_messages.subject,
                   bulk_mail_messages.reply_to,
                   bulk_mail_messages.extra_headers,
                   bulk_mail_messages.message,
                   bulk_mail_messages.query
            from bulk_mail_messages
            where bulk_mail_messages.bulk_mail_id = :bulk_mail_id
        </querytext>
    </fullquery>

</queryset>
