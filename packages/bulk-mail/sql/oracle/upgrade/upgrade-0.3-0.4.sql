-- Changes to support HTML in bulk mail (work originally done by Mohan for
-- Sloanspace).

-- this should be a 'not null' column, but you can't do that when the 
-- table's not empty
alter table bulk_mail_messages
add status varchar2(100);

-- mark all the messages that are already sent as such
update bulk_mail_messages
set status = 'sent'
where sent_p = 't';

alter table bulk_mail_messages
drop column sent_p;

-- now we can do this without having all the previously sent messages get
-- suddenly marked as pending and sent again (don't ask me how I know this :)
alter table bulk_mail_messages
modify status default 'pending';

alter table bulk_mail_messages
add constraint bm_messages_status_ck
check (status in ('pending', 'sent'));

-- recreate the views
create or replace view bulk_mail_messages_unsent
as
    select bulk_mail_messages.*
    from bulk_mail_messages
    where status = 'pending';

create or replace view bulk_mail_messages_sent
as
    select bulk_mail_messages.*
    from bulk_mail_messages
    where status = 'sent';


-- lastly, we seem to have to do this because the  package is invalidated by 
-- the above steps
@@bulk-mail-package-create
