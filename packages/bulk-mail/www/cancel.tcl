ad_page_contract {

    @author Caroline Meeks (caroline@meekshome.com)
    @creation-date 2002-11-27
    @cvs-id $Id: cancel.tcl,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $

} -query {
    bulk_mail_id:integer,notnull
} -validate {
    message_pending -requires {bulk_mail_id:notnull} {
	if { ![string equal [db_string bulk_mail_message_status "select status from bulk_mail_messages where bulk_mail_id=$bulk_mail_id"] "pending"] } {
	    ad_complain {You may only cancel messages that have not yet been sent.}
	}
    }
}

permission::require_permission -object_id $bulk_mail_id -privilege admin

db_dml cancel_bulk_mail_message {}

ad_returnredirect "index"