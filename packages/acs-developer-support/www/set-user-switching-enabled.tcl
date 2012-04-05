ad_page_contract {
    
    @author Lars Pind (lars@pinds.com)
    @creation-date 31 August 2000
    @cvs-id $Id: set-user-switching-enabled.tcl,v 1.1.1.1 2005/06/24 17:56:26 cvs Exp $
} {
    enabled_p
    {return_url "."}
}

ds_require_permission [ad_conn package_id] "admin"

ds_set_user_switching_enabled $enabled_p

ad_returnredirect $return_url
