ad_library {

    Procs for grom-custom package

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-04-22
}

# ----------------------------------------------------------------------
# Task List Page Component
# ---------------------------------------------------------------------

namespace eval grom {}
 
ad_proc -public grom::im_timesheet_task_list_component {
    {-debug 0}
    {-view_name "im_timesheet_task_list"} 
    {-order_by ""} 
    {-restrict_to_type_id 0} 
    {-restrict_to_status_id 0} 
    {-restrict_to_material_id 0} 
    {-restrict_to_project_id 0} 
    {-restrict_to_mine_p "all"} 
    {-restrict_to_with_member_id ""} 
    {-restrict_to_cost_center_id ""} 
    {-task_how_many 50} 
    {-export_var_list {} }
    {-task_start_idx ""}
    {-max_entries_per_page ""}
    -current_page_url 
    -return_url 
} {
    Creates a HTML table showing a table of Tasks 
} {
    ns_log Notice "Running im_timesheet_task_list_component"
   # ---------------------- Security - Show the comp? -------------------------------
    set user_id [ad_get_user_id]
    set user_is_admin_p [im_is_user_site_wide_or_intranet_admin $user_id]

    set include_subprojects 0

    # Is this a "Consulting Project"?
#    if {0 != $restrict_to_project_id} {
#	if {![im_project_has_type $restrict_to_project_id "Consulting Project"]} { return "" }
#    }

    # Compatibibilty with older versions
    if {"" != $max_entries_per_page} { set task_how_many $max_entries_per_page }

    if {"" == $order_by} { 
	if { "/intranet/" == [im_url_with_query] } {
	    set order_by [parameter::get_from_package_key -package_key intranet-timesheet2-tasks -parameter TaskListHomeDefaultSortOrder -default "start_date"] 
	} else {
	    set order_by [parameter::get_from_package_key -package_key intranet-timesheet2-tasks -parameter TaskListDetailsDefaultSortOrder -default "sort_order"] 
	}
    }

    # URL to toggle open/closed tree
    set open_close_url "/intranet/biz-object-tree-open-close"    

    # Check vertical permissions - Is this user allowed to see TS stuff at all?
    if {![im_permission $user_id "view_timesheet_tasks"]} { return "" }

    # Check if the user can see all timesheet tasks
    if {![im_permission $user_id "view_timesheet_tasks_all"]} { set restrict_to_mine_p "mine" }

    # Check horizontal permissions -
    # Is the user allowed to see this project?
    im_project_permissions $user_id $restrict_to_project_id view read write admin
    if {!$read && ![im_permission $user_id view_timesheet_tasks_all]} { return ""}

    # Is the current user allowed to edit the timesheet task hours?
    set edit_task_estimates_p [im_permission $user_id edit_timesheet_task_estimates]

    # ---------------------- Defaults ----------------------------------

    # Get parameters from HTTP session
    # Don't trust the container page to pass-on that value...
    set form_vars [ns_conn form]
    if {"" == $form_vars} { set form_vars [ns_set create] }

    # Get the start_idx in case of pagination
    if {"" == $task_start_idx} {
	set task_start_idx [ns_set get $form_vars "task_start_idx"]
    }
    if {"" == $task_start_idx} { set task_start_idx 0 }
    set task_end_idx [expr $task_start_idx + $task_how_many - 1]

    set bgcolor(0) " class=roweven"
    set bgcolor(1) " class=rowodd"
    set date_format "YYYY-MM-DD"

    set timesheet_report_url "/intranet-timesheet2-tasks/report-timesheet"
    set current_url [im_url_with_query]

    if {![info exists current_page_url]} { set current_page_url [ad_conn url] }
    if {![exists_and_not_null return_url]} { set return_url $current_url }

    # Get the "view" (=list of columns to show)
    set view_id [util_memoize [list db_string get_view_id "select view_id from im_views where view_name = '$view_name'" -default 0]]
    if {0 == $view_id} {
	ns_log Error "im_timesheet_task_component: we didn't find view_name=$view_name"
	set view_name "im_timesheet_task_list"
	set view_id [db_string get_view_id "select view_id from im_views where view_name=:view_name"]
    }
    if {$debug} { ns_log Notice "im_timesheet_task_component: view_id=$view_id" }


    # ---------------------- Get Columns ----------------------------------
    # Define the column headers and column contents that
    # we want to show:
    #
    set column_headers [list]
    set column_vars [list]
    set admin_links [list]
    set extra_selects [list]
    set extra_froms [list]
    set extra_wheres [list]

    set column_sql "
	select	*
	from	im_view_columns
	where	view_id=:view_id
		and group_id is null
	order by sort_order
    "
    set col_span 0
    db_foreach column_list_sql $column_sql {
	if {"" == $visible_for || [eval $visible_for]} {
	    lappend column_headers "$column_name"
	    lappend column_vars "$column_render_tcl"
	    lappend admin_links "<a href=[export_vars -base "/intranet/admin/views/new-column" {return_url column_id {form_mode edit}}] target=\"_blank\"><span class=\"icon_wrench_po\">[im_gif wrench]</span></a>"

	    if {"" != $extra_select} { lappend extra_selects $extra_select }
	    if {"" != $extra_from} { lappend extra_froms $extra_from }
	    if {"" != $extra_where} { lappend extra_wheres $extra_where }
	}
	incr col_span
    }
    if {$debug} { ns_log Notice "im_timesheet_task_component: column_headers=$column_headers" }

    if {[string is integer $restrict_to_cost_center_id] && $restrict_to_cost_center_id > 0} {
	lappend extra_wheres "(t.cost_center_id is null or t.cost_center_id = :restrict_to_cost_center_id)"
    }

    if { "0" != $restrict_to_project_id } {
        lappend extra_wheres "parent.project_id = :restrict_to_project_id"
    }

    # -------- Compile the list of parameters to pass-through-------
    set form_vars [ns_conn form]
    if {"" == $form_vars} { set form_vars [ns_set create] }

    set bind_vars [ns_set create]
    foreach var $export_var_list {
	upvar 1 $var value
	if { [info exists value] } {
	    ns_set put $bind_vars $var $value
	    if {$debug} { ns_log Notice "im_timesheet_task_component: $var <- $value" }
	} else {
	    set value [ns_set get $form_vars $var]
	    if {![string equal "" $value]} {
 		ns_set put $bind_vars $var $value
 		if {$debug} { ns_log Notice "im_timesheet_task_component: $var <- $value" }
	    }
	}
    }

    ns_set delkey $bind_vars "order_by"
    ns_set delkey $bind_vars "task_start_idx"
    set params [list]
    set len [ns_set size $bind_vars]
    for {set i 0} {$i < $len} {incr i} {
	set key [ns_set key $bind_vars $i]
	set value [ns_set value $bind_vars $i]
	if {![string equal $value ""]} {
	    lappend params "$key=[ns_urlencode $value]"
	}
    }
    set pass_through_vars_html [join $params "&"]


    # ---------------------- Format Header ----------------------------------
    # Set up colspan to be the number of headers + 1 for the # column
    set colspan [expr [llength $column_headers] + 1]

    # Format the header names with links that modify the
    # sort order of the SQL query.
    #
    set col_ctr 0
    set admin_link ""
    set table_header_html ""
    foreach col $column_headers {
	set cmd_eval ""
	if {$debug} { ns_log Notice "im_timesheet_task_component: eval=$cmd_eval $col" }
	set cmd "set cmd_eval $col"
	eval $cmd
	regsub -all " " $cmd_eval "_" cmd_eval_subs
	set cmd_eval [lang::message::lookup "" intranet-timesheet2-tasks.$cmd_eval_subs $cmd_eval]
	if {$user_is_admin_p} { set admin_link [lindex $admin_links $col_ctr] }
	append table_header_html "  <th class=rowtitle>$cmd_eval$admin_link</th>\n"
	incr col_ctr
    }

    # ---------------------- Calculate the Children's restrictions -------------------------
    set criteria [list]

    if {[string is integer $restrict_to_status_id] && $restrict_to_status_id > 0} {
	lappend criteria "p.project_status_id in ([join [im_sub_categories $restrict_to_status_id] ","])"
    }

    if {"mine" == $restrict_to_mine_p} {
	lappend criteria "p.project_id in (select object_id_one from acs_rels where object_id_two = [ad_get_user_id])"
    } 

    if {[string is integer $restrict_to_with_member_id] && $restrict_to_with_member_id > 0} {
	lappend criteria "p.project_id in (select object_id_one from acs_rels where object_id_two = :restrict_to_with_member_id)"
    }

    if {[string is integer $restrict_to_type_id] && $restrict_to_type_id > 0} {
	lappend criteria "p.project_type_id in ([join [im_sub_categories $restrict_to_type_id] ","])"
    }

    set restriction_clause [join $criteria "\n\tand "]
    if {"" != $restriction_clause} { 
	set restriction_clause "and $restriction_clause" 
    }

    set extra_select [join $extra_selects ",\n\t\t"]
    if { ![empty_string_p $extra_select] } { set extra_select ",\n\t$extra_select" }

    set extra_from [join $extra_froms ",\n\t\t"]
    if { ![empty_string_p $extra_from] } { set extra_from ",\n\t$extra_from" }

    set extra_where [join $extra_wheres " and\n\t\t"]
    if { ![empty_string_p $extra_where] } { set extra_where " and \n\t$extra_where" }

    # ---------------------- Inner Permission Query -------------------------

    # Check permissions for showing subprojects
    set child_perm_sql "
			select	p.* 
			from	im_projects p,
				acs_rels r 
			where	r.object_id_one = p.project_id and 
				r.object_id_two = :user_id
				$restriction_clause"

    if {([im_permission $user_id "view_projects_all"] || [im_permission $user_id "view_timesheet_tasks_all"]) && "mine" != $restrict_to_mine_p} { 
	set child_perm_sql "
			select	p.*
			from	im_projects p 
			where	1=1
				$restriction_clause"
    }

    set parent_perm_sql "
			select	p.*
			from	im_projects p,
				acs_rels r
			where	
				p.parent_id IS NULL and
				r.object_id_one = p.project_id and 
				r.object_id_two = :user_id 
				$restriction_clause"

    if {[im_permission $user_id "view_projects_all"] && "mine" != $restrict_to_mine_p} {
	set parent_perm_sql "
			select	p.*
			from	im_projects p
			where	1=1
				$restriction_clause"
    }

    # ---------------------- Get the SQL Query -------------------------

    # Check if the table im_gantt_projects exists, and add it to the query
    if {[db_table_exists im_gantt_projects]} {
	set gp_select "gp.*,"
	set gp_from "left outer join im_gantt_projects gp on (gp.project_id = child.project_id)"
    } else {
	set gp_select ""
	set gp_from ""
    }

    # Sorting: Create a sort_by_clause that returns a "sort_by_value".
    # This value is used to sort the hierarchical multirow.
	
    switch $order_by {
	sort_order { 
	    # Order like the imported Gantt diagram (GanttProject or MS-Project)
	    set order_by_clause "child.sort_order" 
	}
	start_date { 
	    # Order by which tasks starts first
	    set order_by_clause "child.start_date" 
	}
	project_name { 
	    set order_by_clause "lower(child.project_name)" 
	}
	project_nr { 
	    set order_by_clause "lower(child.project_nr)" 
	}
	default {
	    set order_by_clause "''" 
	}
    }

    set sql "
	select
		t.*,
		to_char(planned_units, '9999999.0') as planned_units_bad,
		to_char(billable_units, '9999999.0') as billable_units_bad,
		(	select	round(sum(coalesce(planned_units, 0.0)))
			from	im_projects pp, im_timesheet_tasks pt
			where	pp.project_id = pt.task_id and
				pp.tree_sortkey between child.tree_sortkey and tree_right(child.tree_sortkey) and
				pp.project_type_id = [im_project_type_task]
		) as planned_units,
		(	select	round(sum(coalesce(billable_units, 0.0)))
			from	im_projects pp, im_timesheet_tasks pt
			where	pp.project_id = pt.task_id and
				pp.tree_sortkey between child.tree_sortkey and tree_right(child.tree_sortkey) and
				pp.project_type_id = [im_project_type_task]
		) as billable_units,
		im_biz_object_member__list(child.project_id) as project_member_list,
		gp.*,
		child.*,
		child.project_nr as task_nr,
		child.project_name as task_name,
		child.project_status_id as task_status_id,
		child.project_type_id as task_type_id,
		child.project_id as child_project_id,
		child.parent_id as child_parent_id,
		im_category_from_id(t.uom_id) as uom,
		im_material_nr_from_id(t.material_id) as material_nr,
		to_char(child.percent_completed, '999990.9') as percent_completed_rounded,
		cc.cost_center_name,
		cc.cost_center_code,
		child.project_id as subproject_id,
		child.project_nr as subproject_nr,
		child.project_name as subproject_name,
		child.project_status_id as subproject_status_id,
		im_category_from_id(child.project_status_id) as subproject_status,
		im_category_from_id(child.project_type_id) as subproject_type,
		tree_level(child.tree_sortkey) - tree_level(parent.tree_sortkey) as subproject_level,
		$order_by_clause as order_by_value
		$extra_select
	from
		($parent_perm_sql) parent,
		($child_perm_sql) child
		left outer join im_timesheet_tasks t on (t.task_id = child.project_id)
		left outer join im_gantt_projects gp on (gp.project_id = child.project_id)
		left outer join im_cost_centers cc on (t.cost_center_id = cc.cost_center_id)
		$extra_from
	where
		child.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey) and
		child.project_status_id not in ([im_project_status_deleted])
		$extra_where
	order by
		child.tree_sortkey
    "

    db_multirow task_list_multirow task_list_sql $sql {
	# Create a list list of all projects
	set all_projects_hash($child_project_id) 1

	# The list of projects that have a sub-project
        set parents_hash($child_parent_id) 1
	ns_log Notice "im_timesheet_task_list_component: id=$project_id, nr=$project_nr, o=$order_by_value"
    }

    # Sort the tree according to the specified sort order
    # "sort_order" is an integer, so we have to tell the sort algorithm to use integer sorting
    ns_log Notice "im_timesheet_task_list_component: starting to sort multirow"

    if {[catch {
	if {"sort_order" == $order_by} {
	    multirow_sort_tree -integer task_list_multirow project_id parent_id order_by_value
	} else {
	    multirow_sort_tree task_list_multirow project_id parent_id order_by_value
	}
    } err_msg]} {
	ns_log Error "multirow_sort_tree: Error sorting: $err_msg"
	return "<b>Error</b>:<pre>$err_msg</pre>"
    }
    ns_log Notice "im_timesheet_task_list_component: finished to sort multirow"



    # ----------------------------------------------------
    # Determine closed projects and their children

    # Store results in hash array for faster join
    # Only store positive "closed" branches in the hash to save space+time.
    # Determine the sub-projects that are also closed.
    set oc_sub_sql "
	select	child.project_id as child_id
	from	im_projects child,
		im_projects parent
	where	parent.project_id in (
			select	ohs.object_id
			from	im_biz_object_tree_status ohs
			where	ohs.open_p = 'c' and
				ohs.user_id = :user_id and
				ohs.page_url = 'default' and
				ohs.object_id in (
					select	child_project_id
					from	($sql) p
				)
			) and
		child.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)
    "
    db_foreach oc_sub $oc_sub_sql {
	set closed_projects_hash($child_id) 1
    }

    # Calculate the list of leaf projects
    set all_projects_list [array names all_projects_hash]
    set parents_list [array names parents_hash]
    set leafs_list [set_difference $all_projects_list $parents_list]
    foreach leaf_id $leafs_list { set leafs_hash($leaf_id) 1 }

    if {$debug} { 
	ns_log Notice "timesheet-tree: all_projects_list=$all_projects_list"
	ns_log Notice "timesheet-tree: parents_list=$parents_list"
	ns_log Notice "timesheet-tree: leafs_list=$leafs_list"
	ns_log Notice "timesheet-tree: closed_projects_list=[array get closed_projects_hash]"
	ns_log Notice "timesheet-tree: "
    }

    # Render the multirow
    set table_body_html ""
    set ctr 0
    set old_project_id 0
    set skip_first_ctr $task_start_idx

    # Show links to previous and next page?
    set next_page_url ""
    set prev_page_url ""

    # ----------------------------------------------------
    # Render the list of tasks
    template::multirow foreach task_list_multirow {

	# Skip this entry completely if the parent of this project is closed
	if {[info exists closed_projects_hash($child_parent_id)]} { continue }

	# Skip the entry if we exceed the task_how_many value
	if {$ctr > $task_how_many} { continue }

	# Skipe the entry if we have an "OFFSET":
	if {$skip_first_ctr > 0} {
	    incr skip_first_ctr -1

	    # Create a link back to the previous page
	    set prev_task_start_idx [expr $task_start_idx - $task_how_many]
	    if {$prev_task_start_idx < 0} { set $prev_task_start_idx 0 }
	    set prev_page_url [export_vars -base "/intranet-timesheet2-tasks/index" { \
			task_how_many \
			view_name \
			order_by \
			{project_id $restrict_to_project_id} \
			{task_start_idx $prev_task_start_idx} \
			{task_type_id $restrict_to_type_id }
			{task_status_id $restrict_to_status_id }
			{mine_p $restrict_to_mine_p}
			{with_member_id $restrict_to_with_member_id}
			{cost_center_id $restrict_to_cost_center_id}
			{material_id $restrict_to_material_id} \
	    }]

	    continue
	}

	# Replace "0" by "" to make lists better readable
	if {0 == $reported_hours_cache} { set reported_hours_cache "" }
	if {0 == $reported_days_cache} { set reported_days_cache "" }

	# Select the "reported_units" depending on the Unit of Measure
	# of the task. 320="Hour", 321="Day". Don't show anything if
	# UoM is not hour or day.
	switch $uom_id {
	    320 { set reported_units_cache $reported_hours_cache }
	    321 { set reported_units_cache $reported_days_cache }
	    default { set reported_units_cache "-" }
	}
	if {$debug} { ns_log Notice "im_timesheet_task_list_component: project_id=$project_id, hours=$reported_hours_cache, days=$reported_days_cache, units=$reported_units_cache" }

	set indent_html ""
	set indent_short_html ""
	for {set i 0} {$i < $subproject_level} {incr i} {
	    append indent_html "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	    append indent_short_html "&nbsp;&nbsp;&nbsp;"
	}

	if {$debug} { ns_log Notice "timesheet-tree: child_project_id=$child_project_id" }
	if {[info exists closed_projects_hash($child_project_id)]} {
	    # Closed project
	    set gif_html "<a href='[export_vars -base $open_close_url {user_id {page_url "default"} {object_id $child_project_id} {open_p "o"} return_url}]'>[im_gif "plus_9"]</a>"
	} else {
	    # So this is an open task - show a "(-)", unless the project is a leaf.
	    set gif_html "<a href='[export_vars -base $open_close_url {user_id {page_url "default"} {object_id $child_project_id} {open_p "c"} return_url}]'>[im_gif "minus_9"]</a>"
	    if {[info exists leafs_hash($child_project_id)]} { set gif_html "&nbsp;" }
	}

	# In theory we can find any of the sub-types of project
	# here: Ticket and Timesheet Task.
	switch $project_type_id {
	    100 {
		# Timesheet Task
		set object_url [export_vars -base "/intranet-timesheet2-tasks/new" {{task_id $child_project_id} return_url}]
	    }
	    101 {
		# Ticket
		set object_url [export_vars -base "/intranet-helpdesk/new" {{ticket_id $child_project_id} return_url}]
	    }
	    default {
		# Project
		set object_url [export_vars -base "/intranet/projects/view" {{project_id $child_project_id} return_url}]
	    }
	}

	# Table fields for timesheet tasks
	set percent_done_input "<input type=textbox size=3 name=percent_completed.$task_id value=$percent_completed_rounded>"
	set billable_hours_input "<input type=textbox size=3 name=billable_units.$task_id value=$billable_units>"
        if { ![empty_string_p $task_id]} {
            set status_select [im_category_select {Intranet Project Status} task_status_id.$task_id $task_status_id]
        } else {
            set status_select ""
        }
	set planned_hours_input "<input type=textbox size=3 name=planned_units.$task_id value=$planned_units>"

	# Table fields for parents of any type
	if {[info exists parents_hash($task_id)] || !$edit_task_estimates_p} {

	    # A project doesn't have a "material" and a UoM.
	    # Just show "hour" and "default" material here
	    set uom_id [im_uom_hour]
	    set uom [im_category_from_id $uom_id]
	    set material_id [im_material_default_material_id]
	    set reported_units_cache $reported_hours_cache

	    set percent_done_input $percent_completed_rounded
	    set billable_hours_input $billable_units
	    set planned_hours_input $planned_units
	}

	set task_name "<nobr>[string range $task_name 0 20]</nobr>"

	# Something is going wrong with task_id, so set it again.
	set task_id $project_id

	# We've got a task.
	# Write out a line with task information
	append table_body_html "<tr$bgcolor([expr $ctr % 2])>\n"
	foreach column_var $column_vars {
	    append table_body_html "\t<td valign=top>"
	    set cmd "append table_body_html $column_var"
	    eval $cmd
	    append table_body_html "</td>\n"
	}
	append table_body_html "</tr>\n"

	# Update the counter.
	incr ctr

	if {$task_how_many > 0 && $ctr >= $task_how_many} {
	    set next_task_start_idx [expr $task_start_idx + $task_how_many]
	    set next_page_url [export_vars -base "/intranet-timesheet2-tasks/index" { \
			task_how_many \
			view_name \
			order_by \
			{project_id $restrict_to_project_id} \
			{task_start_idx $next_task_start_idx} \
			{task_type_id $restrict_to_type_id }
			{task_status_id $restrict_to_status_id }
			{mine_p $restrict_to_mine_p}
			{with_member_id $restrict_to_with_member_id}
			{cost_center_id $restrict_to_cost_center_id}
			{material_id $restrict_to_material_id} \
	    }]
	    break
	}

    }

    # ----------------------------------------------------
    # Show a reasonable message when there are no result rows:
    #
    if {[empty_string_p $table_body_html] && "" == $prev_page_url && "" == $next_page_url} {
        set new_task_url [export_vars -base "/intranet-timesheet2-tasks/new" {{project_id $restrict_to_project_id} {return_url $current_url}}]
	set table_body_html "
		<tr class=table_list_page_plain>
			<td colspan=$colspan align=left>
			<b>[_ intranet-timesheet2-tasks.There_are_no_active_tasks]</b>
			</td>
		</tr>
		<tr>
			<td colspan=$colspan>
			<ul>
			<li><a href=\"$new_task_url\">[_ intranet-timesheet2-tasks.New_Timesheet_Task]</a>
			</ul>
			</td>
		</tr>
	"
    }
    
    # ----------------------------------------------------
    # Deal with pagination
    #
    set next_page_html ""
    set prev_page_html ""
    if {"" != $next_page_url} {
	set next_page_html "<a href='$next_page_url'>[lang::message::lookup "" intranet-core.Next_Page "Next %task_how_many% &gt;&gt"]</a>"
    }
    if {"" != $prev_page_url} {
	set prev_page_html "<a href='$prev_page_url'>[lang::message::lookup "" intranet-core.Prev_Page "&lt;&lt Previous %task_how_many%"]</a>"
    }

    # -------------------------------------------------
    # Format the action bar at the bottom of the table
    #
    set action_html "
	<td align=left>
		<select name=action>
		<option value=save>[lang::message::lookup "" intranet-timesheet2-tasks.Save_Changes "Save Changes"]</option>
		<option value=delete>[_ intranet-timesheet2-tasks.Delete]</option>
		</select>
		<input type=submit name=submit value='[_ intranet-timesheet2-tasks.Apply]'>
		<br>
		<a href=\"/intranet-timesheet2-tasks/new?[export_url_vars project_id return_url]\"
		>[_ intranet-timesheet2-tasks.New_Timesheet_Task]</a>
		
	</td>
    "
    if {!$write} { set action_html "" }

    set task_start_idx_pretty [expr $task_start_idx+1]
    set task_end_idx_pretty [expr $task_end_idx+1]
    set next_prev_html "
	$prev_page_html
	[lang::message::lookup "" intranet-timesheet2-tasks.Showing_tasks_start_idx_how_many "Showing tasks %task_start_idx_pretty% to %task_end_idx_pretty%"]
	$next_page_html
    "

    # ---------------------- Join all parts together ------------------------

    # Restore the original value of project_id
    set project_id $restrict_to_project_id

    set component_html "
	<center>$next_prev_html</center>
	<form action=/intranet-timesheet2-tasks/task-action method=POST>
	[export_form_vars project_id return_url]
	<table width=100% bgcolor=white border=0 cellpadding=1 cellspacing=1 class=\"table_list_page\">
	<thead>
		<tr class=tableheader>
		$table_header_html
		</tr>
	</thead>
	$table_body_html
	<tfoot>
		<tr>
		<td class=rowplain colspan=$colspan align=right>
			<table width='100%'>
			<tr>
			$action_html
			</tr>
			</table>
		</td>
		</tr>
	<tfoot>
	</table>
	</form>
	<center>$next_prev_html</center>
    "

    return $component_html
}
