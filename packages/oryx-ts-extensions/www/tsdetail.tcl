# packages/oryx-ts-extensions/www/tsdetail.tcl
# Author: Bruno De Wolf (b.dewolf@oryx-consulting.com)
# The code is based on ArsDigita ACS 3.4
# and code from Frank Bergmann (frank.bergmann@project-open.com)



ad_page_contract {
	testing reports	
    @param start_year Year to start the report
    @param start_unit Month or week to start within the start_year
    @param truncate_note_length Truncate (ellipsis) the note field
           to the given number of characters. 0 indicates no
           truncation.
} {
    { start_date "" }
    { end_date "" }
    { level_of_detail 2 }
    { truncate_note_length 80}
    { output_format "html" }
    project_id:integer,optional
    task_id:integer,optional
    company_id:integer,optional
    user_id:integer,optional
}

# ------------------------------------------------------------
# Security

# Label: Provides the security context for this report
# because it identifies unquely the report's Menu and
# its permissions.
set menu_label "oryx-ts-printing"

set current_user_id [ad_maybe_redirect_for_registration]

set read_p [db_string report_perms "
	select	im_object_permission_p(m.menu_id, :current_user_id, 'read')
	from	im_menus m
	where	m.label = :menu_label
" -default 'f']

if {![string equal "t" $read_p]} {
    ad_return_complaint 1 "
    [lang::message::lookup "" intranet-reporting.You_dont_have_permissions "You don't have the necessary permissions to view this page"]"
    return
}

# Check that Start & End-Date have correct format
if {"" != $start_date && ![regexp {[0-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9]} $start_date]} {
    ad_return_complaint 1 "Start Date doesn't have the right format.<br>
    Current value: '$start_date'<br>
    Expected format: 'YYYY-MM-DD'"
}

if {"" != $end_date && ![regexp {[0-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9]} $end_date]} {
    ad_return_complaint 1 "End Date doesn't have the right format.<br>
    Current value: '$end_date'<br>
    Expected format: 'YYYY-MM-DD'"
}

set page_title "Timesheet Report"
set context_bar [im_context_bar $page_title]
set context ""


# ------------------------------------------------------------
# Defaults


set days_in_past 7

db_1row todays_date "
select
	to_char(sysdate::date - :days_in_past::integer, 'YYYY') as todays_year,
	to_char(sysdate::date - :days_in_past::integer, 'MM') as todays_month,
	to_char(sysdate::date - :days_in_past::integer, 'DD') as todays_day
from dual
"

if {"" == $start_date} { 
    set start_date "$todays_year-$todays_month-01"
}

# Maxlevel is 4. Normalize in order to show the right drop-down element
if {$level_of_detail > 4} { set level_of_detail 4 }


db_1row end_date "
select
	to_char(to_date(:start_date, 'YYYY-MM-DD') + 31::integer, 'YYYY') as end_year,
	to_char(to_date(:start_date, 'YYYY-MM-DD') + 31::integer, 'MM') as end_month,
	to_char(to_date(:start_date, 'YYYY-MM-DD') + 31::integer, 'DD') as end_day
from dual
"

if {"" == $end_date} { 
    set end_date "$end_year-$end_month-01"
}


set package_id 0
set package_key "oryx-ts-extensions"
db_1row get_package_id " select min(package_id) as package_id from  apm_packages where package_key = :package_key"
set htmldoc_path [ad_parameter -package_id $package_id htmldoc-path "" "/usr/local/bin/htmldoc"]
set rep_title [ad_parameter -package_id $package_id report-title "" "Your company name"]


# ------------------------------------------------------------
# Conditional SQL Where-Clause
#

set criteria [list]

if {[info exists company_id]} {
    lappend criteria "p.company_id = :company_id"
}

if {[info exists user_id]} {
    lappend criteria "h.user_id = :user_id"
}

if {[info exists task_id]} {
    lappend criteria "h.project_id = :task_id"
}

# Select project & subprojects
if {[info exists project_id]} {
    lappend criteria "p.project_id in (
	select
		p.project_id
	from
		im_projects p,
		im_projects parent_p
	where
		parent_p.project_id = :project_id
		and p.tree_sortkey between parent_p.tree_sortkey and tree_right(parent_p.tree_sortkey)
    )"
}

set where_clause [join $criteria " and\n            "]
if { ![empty_string_p $where_clause] } {
    set where_clause " and $where_clause"
}


# ------------------------------------------------------------
# Define the report - SQL, counters, headers and footers 
#

set inner_sql "
select
	h.day::date as date,
	h.note,
	to_char(h.day, 'J')::integer - to_char(to_date(:start_date, 'YYYY-MM-DD'), 'J')::integer as date_diff,
	h.user_id,
	p.project_id,
	p.company_id,
	h.hours,
	h.billing_rate,
        t.task_id,
        t.task_name
from
	im_hours h,
	im_projects p,
	im_timesheet_tasks t,
	cc_users u
where
	h.project_id = p.project_id
	and h.timesheet_task_id = t.task_id
	and h.user_id = u.user_id
	and h.day >= to_date(:start_date, 'YYYY-MM-DD')
	and h.day < to_date(:end_date, 'YYYY-MM-DD')
	$where_clause
"

set sql "
select
	to_char(s.date, 'YYYY-MM-DD') as date,
	s.date_diff,
	s.note,
        s.task_id,
        s.task_name,
	u.user_id,
	u.first_names || ' ' || u.last_name as user_name,
	p.project_id,
	p.project_nr,
	p.project_name,
	c.company_id,
	c.company_path as company_nr,
	c.company_name,
	to_char(s.hours, '999,999') as hours,
	to_char(s.billing_rate, '999,999.9') as billing_rate
from
	($inner_sql) s,
	im_companies c,
	im_projects p,
	cc_users u
where
	s.user_id = u.user_id
	and s.company_id = c.company_id
	and s.project_id = p.project_id
order by
	s.company_id,
	p.project_id,
	u.user_id,
        s.task_id,
	s.date
"
append timesheet_as_html " <html>
<!-- MEDIA LANDSCAPE YES -->
<body>
<table width=90%>
<tr><td><h4>$rep_title</h4></td><td align=left>Timesheet</td></tr>
</table>"

append timesheet_table "<table border=1> <tr> <td>&nbsp;</td> <td>&nbsp;</td> 
 <td>1</td> <td>2</td> <td>3</td> <td>4</td> <td>5</td> 
 <td>6</td> <td>7</td> <td>8</td> <td>9</td> <td>10</td> 
 <td>11</td> <td>12</td> <td>13</td> <td>14</td> <td>15</td> 
 <td>16</td> <td>17</td> <td>18</td> <td>19</td> <td>20</td> 
 <td>21</td> <td>22</td> <td>23</td> <td>24</td> <td>25</td> 
 <td>26</td> <td>27</td> <td>28</td> <td>29</td> <td>30</td> 
 <td>31</td> "

set ts_line {}
set old_user ""
set old_task ""
set old_daynum 31
set old_monthnum 0
set line_total "Total"
set grand_total 0
set n_lines 0

db_foreach ts_line $sql {

  if {"0"==[string range $date 8 8]} {
    set daynum [string range $date 9 9]
  } else {
    set daynum [string range $date 8 9]
  }

  if {"0"==[string range $date 5 5]} {
    set monthnum [string range $date 6 6]
  } else {
    set monthnum [string range $date 5 6]
  }

  if {$old_user != $user_id || $old_task != $task_id || $monthnum !=$old_monthnum} {
    # close the previous line and start a new one
    for {set i $old_daynum} {$i < 31} {incr i} {
      append timesheet_table  "<td>&nbsp;</td>"
    }
    append timesheet_table  "<td>$line_total</td>"
    set old_daynum 0
    set line_total 0
    incr n_lines
    append timesheet_table  "</tr><tr>"
    if {$old_user == $user_id} {
      append timesheet_table  "<td>&nbsp;</td>"
    } else {
      append timesheet_table  "<td>$user_name</td>"
    }
    append timesheet_table  "<td>$task_name</td>"
  }

# output hours in the right column  
  for {set i $old_daynum} {$i < $daynum-1} {incr i} {
    append timesheet_table  "<td>&nbsp;</td>"
  }
  append timesheet_table  "<td>$hours</td>"

# prepare the next iteration
  set line_total [expr {$line_total + $hours}]
  set grand_total [expr {$grand_total + $hours}]
  set old_user $user_id
  set old_task $task_id
  set old_daynum $daynum
  set old_monthnum $monthnum
}
# close the last line
for {set i $old_daynum} {$i < 31} {incr i} {
  append timesheet_table  "<td>&nbsp;</td>"
}
append timesheet_table  "<td>$line_total</td></tr>"

for {set i $n_lines} {$i < 10} {incr i} {
  append timesheet_table  "<tr>"
  for {set j 0} {$j < 34} {incr j} {
    append timesheet_table  "<td>&nbsp;</td>"
  }
  append timesheet_table  "</tr>"
}

append timesheet_table "</table>"

append timesheet_as_html "<p><b>Customer:</b> $company_name</p>"
append timesheet_as_html "<p><b>Project:</b> $project_name</p>"
append timesheet_as_html "<p><b>Period:</b> $start_date to $end_date</p>"
append timesheet_as_html $timesheet_table

append timesheet_as_html "Total: $grand_total hours<br>"
append timesheet_as_html "<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>"
append timesheet_as_html "<table><tr><td><b>Customer's signature:</b></td><td> ...................</td></tr>"
append timesheet_as_html "<tr><td>&nbsp;</td></tr>"
append timesheet_as_html "<tr><td><b>Date:</b></td><td> ...................</td></tr></table>"
append timesheet_as_html "</body></html> "

#generate the PDF output
 
set file_name_pdf [ns_tmpnam]
append file_name_pdf ".pdf"
if {[catch {exec echo \ $timesheet_as_html\  | $htmldoc_path --webpage --quiet -f $file_name_pdf -} result]} {
       #Do nothing
}
ns_returnfile 200 application/pdf $file_name_pdf
ad_script_abort



