-- packages/acs-events/sql/postgresql/test/utest-drop.sql
--
-- Drop the unit test package
--
-- @author jowell@jsabino.com
-- @creation-date 2001-06-26
--
-- $Id: utest-drop.sql,v 1.2 2010/10/19 20:11:27 po34demo Exp $

-- For now, we require openacs4 installed.
select drop_package('ut_assert');




