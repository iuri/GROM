<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="bulk_mail_base.bulk_mail_base_query">      
        <querytext>
            select site_node__url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="bulk_mail::new.select_current_date">      
        <querytext>
            select to_char(current_timestamp, :date_format)
        </querytext>
    </fullquery>

    <fullquery name="bulk_mail::sweep.select_bulk_mails_to_send">      
        <querytext>
            select bulk_mail_messages.*
            from bulk_mail_messages
            where bulk_mail_messages.status = 'pending'
            and bulk_mail_messages.send_date <= now()
            for update
        </querytext>
    </fullquery>

</queryset>
