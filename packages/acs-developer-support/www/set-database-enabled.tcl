ad_page_contract {
    
    @author Lars Pind (lars@pinds.com)
    @creation-date 2003-10-28
    @cvs-id $Id: set-database-enabled.tcl,v 1.1.1.1 2005/06/24 17:56:26 cvs Exp $
} {
    enabled_p
    {return_url "."}
}

ds_require_permission [ad_conn package_id] "admin"

ds_set_database_enabled $enabled_p

ad_returnredirect $return_url
