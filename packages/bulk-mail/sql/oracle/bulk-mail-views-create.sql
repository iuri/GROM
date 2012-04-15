--
-- bulk_mail views
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-views-create.sql,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $
--

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

