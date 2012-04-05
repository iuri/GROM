ad_page_contract {
    Simple add/edit form for organizations
} {
    organization_id:integer,optional
    organization_type_id:integer,multiple,optional
} -properties {
    context_bar:onevalue
    title:onevalue
}

# The unique identifier for this package.
set package_id [ad_conn package_id]

# The id of the person logged in and browsing this page
set user_id [auth::require_login]

# address of person logged in
set peeraddr [ad_conn peeraddr]

# An HTML block for the breadcrumb trail 
set title "Add an organization"

if {[exists_and_not_null organization_id]} {
    set title "Edit an organization"
    set context_bar [ad_context_bar "Edit"] 

    permission::require_permission \
	-object_id $package_id \
	-privilege write

    set org_types_used [db_list select_org_types_used { }]

} else {
    set context_bar [ad_context_bar "New"] 

    permission::require_permission \
	-object_id $package_id \
	-privilege create

    set org_types_used {}
}


ad_form -name org -form {
    organization_id:key
    {name:text
        {label "Name"}
    }
    {legal_name:text
        {label "Legal name"}
    }
    {email:text,optional
        {label "Organization email address"}
    }
    {url:text,optional
        {label "Organization URL"}
    }
    {notes:text(textarea),optional
        {label "Notes"}
    }
    {organization_type_id:text(checkbox),multiple
	{label "Organization type"} 
	{ options {[db_list_of_lists get_org_types { }]}}
	{ values {$org_types_used}}
    }
    {reg_number:text,optional
        {label "Registration number (ein/ssn/vat/etc)"}
    }
} -select_query_name org_query -new_data {

    set org_type_id [lindex $organization_type_id 0]

    set organization_id [db_exec_plsql do_insert_org { *SQL* }]

    db_transaction {

	set i 0
	foreach oti $organization_type_id {
	    if {$i > 0} {
		db_dml do_insert_types { }
	    }
	    incr i
	}
    }

} -edit_data {

    db_transaction {
	db_dml delete_org_types_used { }
	db_dml do_update_org { *SQL* }
	db_dml do_update_parties { *SQL* }
	foreach oti $organization_type_id {
	    db_dml do_insert_types { }
	}
    }

} -after_submit {
    ad_returnredirect "one?[export_url_vars organization_id]"
}

