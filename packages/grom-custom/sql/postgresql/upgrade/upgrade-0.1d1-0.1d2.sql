-- /packages/grom-custom/sql/postgresql/upgrade/upgrade-0.1d1-0.1d2.sql

SELECT acs_log__debug('/packages/grom-custom/sql/postgresql/upgrade/upgrade-0.1d1-0.1d2.sql','');


CREATE OR REPLACE FUNCTION inline_0 ()
RETURNS integer AS '
  DECLARE
  
  BEGIN
	UPDATE im_view_columns
	SET column_render_tcl = ''"<nobr>$indent_html$gif_html<a href=/intranet-timesheet2-tasks/new?[export_url_vars project_id task_id return_url]>$task_name</a></nobr>"''
	WHERE column_id = 91002;

	
	UPDATE im_view_columns
	SET column_render_tcl = ''"<a href=/intranet-timesheet2-tasks/new?[export_url_vars project_id task_id return_url]>$task_name</a>"''
	WHERE column_id = 1007;

	RETURN 0;

  END;' LANGUAGE 'plpgsql';

SELECT inline_0 ();
DROP FUNCTION inline_0 ();


-- insert into im_view_columns (column_id, view_id, group_id, column_name, column_render_tcl,extra_select, extra_where, sort_order, visible_for) values (91115,911,NULL,'Members','"[im_biz_object_member_list_format $project_member_list]"','','',15,'');

-- insert into im_view_columns (column_id, view_id, group_id, column_name, column_render_tcl, extra_select, extra_where, sort_order, visible_for) values (92101,950,NULL,'Name','<nobr>@tasks.gif_html;noquote@<a href=@tasks.object_url;noquote@>@tasks.task_name;noquote@</a></nobr>','','',1,'');


