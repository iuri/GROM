# 

ad_page_contract {
    
    WebDAV enable folders
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2004-02-15
    @cvs-id $Id: enable.tcl,v 1.1.1.1 2010/10/20 02:10:25 po34demo Exp $
} {
    folder_id:integer,multiple
} -properties {
} -validate {
} -errors {
}

permission::require_permission \
    -party_id [ad_conn user_id] \
    -object_id [ad_conn package_id ] \
    -privilege "admin"

foreach id $folder_id {

    db_dml enable_folder ""
    
}
util_user_message -message [_ oacs-dav.Folders_Enabled]
ad_returnredirect "."