--
-- Set the context ID of existing calendars to the package_id
--
-- @cvs-id $Id: upgrade-2.0d1-2.0b2.sql,v 1.3 2010/10/21 13:06:47 po34demo Exp $
--


update acs_objects
set    context_id = package_id
from   calendars
where  calendar_id = object_id;
