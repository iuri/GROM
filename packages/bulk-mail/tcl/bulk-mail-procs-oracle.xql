<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="bulk_mail::url_not_cached.select_bulk_mail_url">      
        <querytext>
            select site_node.url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = :package_id
        </querytext>
    </fullquery>

    <fullquery name="bulk_mail::new.select_current_date">      
        <querytext>
            select to_char(sysdate, :date_format)
            from dual
        </querytext>
    </fullquery>

    <fullquery name="bulk_mail::sweep.select_bulk_mails_to_send">      
        <querytext>
            select bulk_mail_messages.*
            from bulk_mail_messages
            where bulk_mail_messages.status = 'pending'
            and bulk_mail_messages.send_date <= sysdate
            for update
        </querytext>
    </fullquery>

</queryset>
