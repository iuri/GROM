--
-- packages/acs-messaging/sql/acs-messaging-drop.sql
--
-- @author akk@arsdigita.com
-- @creation-date 2000-08-31
-- @cvs-id $Id: acs-messaging-drop.sql,v 1.2 2010/10/19 20:11:59 po34demo Exp $
--

begin
  acs_object_type.drop_type('acs_message');
end;
/
show errors

drop package acs_message;

drop table acs_messages_outgoing;

drop view acs_messages_all;

drop table acs_messages;

