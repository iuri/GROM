alter table bulk_mail_messages drop constraint bm_messages_status_ck;
alter table bulk_mail_messages add constraint bm_messages_status_ck
    check (status in ('pending', 'sent', 'cancelled'));

