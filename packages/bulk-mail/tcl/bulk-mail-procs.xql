<?xml version="1.0"?>
<queryset>

    <fullquery name="bulk_mail::package_id_not_cached.select_bulk_mail_package_id">      
        <querytext>
            select min(apm_packages.package_id)
            from apm_packages
            where apm_packages.package_key = :package_key
        </querytext>
    </fullquery>

    <fullquery name="bulk_mail::sweep.mark_message_sent">      
        <querytext>
            update bulk_mail_messages
            set status = 'sent'
            where bulk_mail_id = :bulk_mail_id
        </querytext>
    </fullquery>

</queryset>
