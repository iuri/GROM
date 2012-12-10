-- /packages/grom-custom/sql/postgresql/upgrade/upgrade-0.1d4-0.1d5.sql

SELECT acs_log__debug('/packages/grom-custom/sql/postgresql/upgrade/upgrade-0.1d4-0.1d5.sql','');



-- Set dynfields also_hard_coded_p to true
CREATE OR REPLACE FUNCTION inline_0 ()
RETURNS integer AS '
DECLARE
	v_plugin_id	INTEGER;
	row		record;

BEGIN 

     SELECT plugin_id INTO v_plugin_id FROM im_component_plugins WHERE package_name = ''intranet-timesheet2-tasks'' AND page_url = ''intranet/projects/view'' AND plugin_name = ''Project Timesheet Tasks'';

     FOR row IN
     	  SELECT DISTINCT g.group_id FROM acs_objects o , groups g, im_profiles p WHERE g.group_id = o.object_id AND g.group_id = p.profile_id AND o.object_type = ''im_profile''
     LOOP
	SELECT im_grant_permission(v_plugin_id,row.group_id,''read'');
     END LOOP;


     UPDATE im_component_plugins SET component_tcl = ''grom::im_timesheet_task_list_component -restrict_to_project_id $project_id -max_entries_per_page 10 -view_name im_timesheet_task_list'' WHERE plugin_id = v_plugin_id;


     DELETE FROM im_component_plugin_user_map WHERE plugin_id = v_plugin_id


     RETURN 0;
END;' language 'plpgsql';


SELECT inline_0 ();
DROP FUNCTION inline_0 ();

\echo 'date'

\i /usr/share/postgresql/8.4/contrib/tsearch2.sql
