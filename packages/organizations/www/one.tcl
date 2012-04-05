ad_page_contract {

    Displays all organizations associated with this instance.

    @author jade@bread.com
    @creation-date 2003-05-23
    @cvs-id $Id: one.tcl,v 1.1.1.1 2007/04/29 23:38:30 cognovis Exp $

    @return context_bar passed to the master template to show the context bar
    @return create_p does the user have create permissions?
    @return admin_p does the user have admin permissions?
    @return write_p does the user have write permissions?
    @return title passed to the master template for title display
    @return name organization name
    @return legal_name organization's legal name
    @return reg_number EIN/SSN/etc number
    @return notes notes about the organization
} {
    organization_id:integer
} -properties {
    title:onevalue
    context_bar:onevalue
    create_p:onevalue
    admin_p:onevalue
    delete_p:onevalue
    write_p:onevalue
    name:onevalue
    legal_name:onevalue
    reg_number:onevalue
    notes:onevalue
}

# The unique identifier for this package.
set package_id [ad_conn package_id]

# The id of the person logged in and browsing this page
set user_id [auth::require_login]

# An HTML block for the breadcrumb trail 
set context_bar [ad_context_bar "One"] 
set title "Organizations"

# Permissions
permission::require_permission \
    -object_id $package_id \
    -privilege read

set create_p [permission::permission_p -object_id $package_id -privilege create] 
set write_p  [permission::permission_p -object_id $package_id -privilege write] 
set delete_p  [permission::permission_p -object_id $package_id -privilege delete] 
set admin_p  [permission::permission_p -object_id $package_id -privilege admin] 

db_1row org_query { }

