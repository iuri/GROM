ad_page_contract {

    Display all readable unmounted packages

    @author bquinn@arsdigita.com
    @creation-date 2000-09-12
    @cvs-id $Id: unmounted.tcl,v 1.2 2010/10/19 20:12:37 po34demo Exp $

}

set page_title "Unmounted Packages"
set context [list [list "." "Site Map"] $page_title]
set user_id [ad_conn user_id]

db_multirow -extend {instance_delete_url} packages_normal packages_normal_select {} {
    set instance_delete_url [export_vars -base instance-delete package_id]
}

db_multirow -extend {instance_delete_url} packages_singleton packages_singleton_select {} {
    set instance_delete_url [export_vars -base instance-delete package_id]
}
