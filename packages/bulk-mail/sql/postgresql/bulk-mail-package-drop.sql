--
-- bulk_mail logic
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: bulk-mail-package-drop.sql,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $
--

drop function bulk_mail__new (integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, varchar, text, varchar, timestamptz, integer, varchar, integer);
drop function bulk_mail__delete (integer);
