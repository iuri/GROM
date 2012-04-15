-- 
-- packages/postal-address/sql/postgresql/upgrade/upgrade-0.1d-0.2d1.sql
-- 
-- @author <yourname> (<your email>)
-- @creation-date 2007-01-23
-- @cvs-id $Id: upgrade-0.2d1-0.2d2.sql,v 1.1.1.1 2007/04/29 23:39:27 cognovis Exp $
--

alter table postal_addresses alter column delivery_address drop not null;