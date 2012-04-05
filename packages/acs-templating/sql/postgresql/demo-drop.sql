-- Uninstall file for the data model created by 'demo-create.sql'
-- (This file created automatically by create-sql-uninst.pl.)
--
-- brech (Mon Aug 28 11:06:33 2000)
--
-- $Id: demo-drop.sql,v 1.3 2012/02/10 19:50:07 po34demo Exp $
--

\i template-demo-notes-drop.sql

drop table ad_template_sample_users;
drop sequence ad_template_sample_users_seq;
