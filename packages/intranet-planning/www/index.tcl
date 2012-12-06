# /packages/intranet-planning/www/index.tcl
#
# Copyright (C) 2003 - 2011 ]project-open[
#
# All rights reserved. Please check
# http://www.project-open.com/license/ for details.

# ---------------------------------------------------------------
# 1. Page Contract
# ---------------------------------------------------------------

ad_page_contract { 
    Create a new quote from planning information
    @author frank.bergmann@project-open.com
} {
}


set page_title [lang::message::lookup "" intranet-planning.New_quote_from_planning_data "Project Planning"]


set return_url [ad_return_url]

set projects_html ""
set current_level 1
set ctr 1
set max_projects 15



db_multirow -extend {project_url} active_projects select_projects "
    WITH RECURSIVE children AS ( 
				SELECT p.*
				FROM im_projects p 
				WHERE p.parent_id IS NULL 
				UNION ALL 
				SELECT p2.* 
				FROM im_projects p2 
				JOIN children ON (p2.parent_id = children.project_id)
				) 
    SELECT p3.* 
    FROM im_projects p3 
    WHERE p3.project_type_id NOT IN ([im_project_type_task], [im_project_type_ticket])  
    ORDER BY p3.tree_sortkey;
" {


    set project_url [export_vars -base "quote-wizard/new" {project_id return_url}]

}

# ---------------------------------------------------------------
# NavBars
# ---------------------------------------------------------------

set sub_navbar_html [im_costs_navbar "none" "/intranet/invoices/index" "" "" [list]]

