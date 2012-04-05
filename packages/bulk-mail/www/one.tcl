ad_page_contract {

    @author yon (yon@openforce.net)
    @creation-date 2002-05-13
    @cvs-id $Id: one.tcl,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $

} -query {
    bulk_mail_id:integer,notnull
} -properties {
    title:onevalue
    context:onevalue
}

permission::require_permission -object_id $bulk_mail_id -privilege admin

set package_id [ad_conn package_id]

db_1row select_message_info {}

set subject [ad_quotehtml $subject]
set message [ad_quotehtml $message]

set title $subject
set context [list $subject]

ad_return_template
