ad_page_contract {

    Displays all organizations associated with this instance.

    @author jade@bread.com
    @creation-date 2003-05-23
    @cvs-id $Id: index.tcl,v 1.1.1.1 2007/04/29 23:38:30 cognovis Exp $

    @param organization_type_id limits view to a particular organization_type

    @return context_bar passed to the master template to show the context bar
    @return create_p does the user have create permissions?
    @return admin_p does the user have admin permissions?
    @return write_p does the user have write permissions?
    @return title passed to the master template for title display
    @return orgs datasource for organization information
} {
    organization_type_id:integer,optional
} -properties {
    title:onevalue
    context_bar:onevalue
    create_p:onevalue
    delete_p:onevalue
    admin_p:onevalue
    write_p:onevalue
    orgs:multirow
}

# The unique identifier for this package.
set package_id [ad_conn package_id]

# The id of the person logged in and browsing this page
set user_id [auth::require_login]

# An HTML block for the breadcrumb trail 
set context_bar [ad_context_bar] 
set title "Organizations"

# Permissions
permission::require_permission \
    -object_id $package_id \
    -privilege read

set create_p [permission::permission_p -object_id $package_id -privilege create] 
set write_p  [permission::permission_p -object_id $package_id -privilege write] 
set delete_p [permission::permission_p -object_id $package_id -privilege delete] 
set admin_p  [permission::permission_p -object_id $package_id -privilege admin] 

# list builder

template::list::create \
    -name orgs \
    -multirow orgs \
    -key organization_id \
    -class "list" \
    -main_class "list" \
    -sub_class "narrow" \
    -elements {
       edit {
            label {}
            display_template {
               <if @orgs.write@>
                <a href="add-edit?organization_id=@orgs.organization_id@" title="Edit this organization">
		<img src="/shared/images/Edit16.gif" height="16" width="16" 
                alt="Edit" border="0"></a>
                </if>
                <else>
                @orgs.write@
                </else>
            }
        }
        name {
	    label "Name"
	    link_url_eval {one?[export_vars {organization_id}]}
        }
        notes {
	    label "Notes"
	    hide_p 1
        }
	organization_type_id {
	    label "Type"
	    display_col organization_type
	}
    } \
    -filters {
	organization_type_id {
	    label "Organization type"
	    values {[db_list_of_lists select_org_types {}]}
	    where_clause {
		ot.organization_type_id = :organization_type_id
	    }
	    add_url_eval {[export_vars -base "index" { {organization_type_id $__filter_value } variable_id}]}
	}
    } \
    -actions {
	"Add" "add-edit" "Add a new organization"
    } \
    -orderby {
	default_value name,asc
	name {
	    label "Name"
	    orderby_desc "upper(o.name), desc"
	    orderby_asc "upper(o.name)"
	    default_direction asc
	}
	notes {
	    label "Notes"
	    orderby_desc "o.notes, desc"
	    orderby_asc "o.notes"
	    default_direction asc
	}
    } 


db_multirow -extend { item_url write } orgs orgs_query { 
} {
    set item_url [export_vars -base "one" {organization_id}]

    set write $write_p
}


