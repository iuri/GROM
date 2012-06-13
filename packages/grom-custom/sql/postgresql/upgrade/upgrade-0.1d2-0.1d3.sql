-- /packages/grom-custom/sql/postgresql/upgrade/upgrade-0.1d2-0.1d3.sql

SELECT acs_log__debug('/packages/grom-custom/sql/postgresql/upgrade/upgrade-0.1d2-0.1d3.sql','');

CREATE OR REPLACE FUNCTION inline_0 ()
RETURNS integer AS '
DECLARE
	v_plugin_id	INTEGER;

BEGIN 

      SELECT plugin_id INTO v_plugin_id FROM im_component_plugins WHERE plugin_name = ''Project Timesheet Tasks'' AND package_name = ''intranet-timesheet2-tasks'' AND page_url = ''/intranet/projects/view'';

      UPDATE im_component_plugins SET component_tcl = ''im_timesheet_task_list_component -restrict_to_project_id $project_id -max_entries_per_page 10 -view_name im_timesheet_task_list'' WHERE plugin_id = v_plugin_id;
      

      RETURN 0;
END;' language 'plpgsql';


SELECT inline_0 ();
DROP FUNCTION inline_0 ();
