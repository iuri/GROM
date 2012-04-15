-- 
-- 
-- 
-- @author Dave Bauer (dave@thedesignexperience.org)
-- @creation-date 2005-01-06
-- @arch-tag: e086c05a-d0b7-498a-ac50-4ca5c36f3070
-- @cvs-id $Id: upgrade-5.1.4d5-5.1.4d6.sql,v 1.2 2010/10/19 20:10:37 po34demo Exp $
--


select define_function_args('content_template__new','name,parent_id,template_id,creation_date;now,creation_user,creation_ip,text,is_live;f');
