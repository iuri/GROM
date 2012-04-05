--
-- A simple mail queue
--
-- @author <a href="mailto:eric@openforce.net">eric@openforce.net</a>
-- @version $Id: acs-mail-lite-drop.sql,v 1.2 2010/10/19 20:11:58 po34demo Exp $
--

drop table acs_mail_lite_queue;
drop sequence acs_mail_lite_id_seq;
drop table acs_mail_lite_mail_log; 
drop table acs_mail_lite_bounce; 
drop table acs_mail_lite_bounce_notif;
