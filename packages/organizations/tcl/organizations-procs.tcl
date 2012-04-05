# 

ad_library {
    
    Procs for organizations
    
    @author Jade Rubick (jader@bread.com)
    @creation-date 2004-05-24
    @arch-tag: 1d9b7e33-1d9f-43e5-a85e-47dc870fedb9
    @cvs-id $Id: organizations-procs.tcl,v 1.1.1.1 2007/04/29 23:38:30 cognovis Exp $
}

namespace eval organization {}
namespace eval organizations {}

ad_proc -public organizations::name {
    {-organization_id:required}
} {
    Returns the organization name when given the organization_id
    
    @author Jade Rubick (jader@bread.com)
    @creation-date 2004-05-24
    
    @param organization_id

    @return organization name
    
    @error returns an empty string
} {
    return [db_string get_name {
        SELECT
        name
        FROM
        organizations
        WHERE
        organization_id = :organization_id
    } -default ""]
}

ad_proc -public organization::get_by_name {
    {-name:required}
} {
    Return the organization_id of the organization with the given name. Uses
    a lowercase comparison so we do not allow organizations to differ only 
    in case. Returns empty string if no organization found.

    @author Matthew Geddert (openacs@geddert.com)
    @creation-date 2005-07-06
    
    @return organization_id
} {
    return [db_string get_by_name { select organization_id from organizations where lower(name) = lower(:name) } -default {}]
}

ad_proc -public organization::new {
    {-organization_id ""}
    {-legal_name ""}
    {-name:required}
    {-notes ""}
    {-organization_type_id ""}
    {-reg_number ""}
    {-email ""}
    {-url ""}
    {-user_id ""}
    {-peeraddr ""}
    {-package_id ""}
} {
    Creates a new organization
    
    @author Matthew Geddert (openacs@geddert.com)
    @creation-date 2004-06-14
    
    @return organization_id
    
    @error returns an empty string
} {
    if { ![exists_and_not_null user_id] } {
	set user_id [ad_conn user_id]
    }
    if { ![exists_and_not_null peeraddr] } {
	set peeraddr [ad_conn peeraddr]
    }
    if { ![exists_and_not_null package_id] } {
	set package_id [ad_conn package_id]
    }

    set organization_id [db_exec_plsql create_organization {
	select organization__new ( 
				  :legal_name,
				  :name,
				  :notes,
				  :organization_id,
				  :organization_type_id,
				  :reg_number,
				  :email,
				  :url,
				  :user_id,
				  :peeraddr,
				  :package_id
				  )
    }]

    return $organization_id
}

ad_proc -public organizations::id {
    {-name:required}
} {
    Returns the organization id for a given name
    
    @author Christian Langmann (C_Langmann@gmx.de)
    @creation-date 2005-06-14
    
    @param name the name to look for

    @return organization id
    
    @error returns an empty string
} {
    return [db_string get_id {
        SELECT
        organization_id
        FROM
        organizations
        WHERE
        name = :name
    } -default ""]
}

ad_proc -public organization::name_p {
    {-name:required}
} {
    this returns whether the organization with the given name exists
} {

    if {[db_0or1row contact_org_exists_p {select '1' from organizations where name = :name}]} {
	return 1
    } else {
      	return 0
    }
}


ad_proc -public organization::organization_p {
    {-party_id:required}
} {
    is this party an organization? Cached
} {
    return [util_memoize [list ::organization::organization_p_not_cached -party_id $party_id]]
}

ad_proc -public organization::organization_p_not_cached {
    {-party_id:required}
} {
    is this party and organization?
} {
    if {[person::person_p -party_id $party_id]} {
        return 0
    } else {
        if {[db_0or1row contact_org_exists_p {select '1' from organizations where organization_id = :party_id}]} {
            return 1
        } else {
            return 0
        }
    }
}

