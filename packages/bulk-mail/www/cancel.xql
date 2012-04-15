<?xml version="1.0"?>

<queryset>

    <fullquery name="cancel_bulk_mail_message">
        <querytext>
            update bulk_mail_messages
            set status = 'cancelled'
            where bulk_mail_id = :bulk_mail_id
        </querytext>
    </fullquery>

</queryset>
