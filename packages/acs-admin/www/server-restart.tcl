ad_page_contract {

    Kill (restart) the server.

    @author Peter Marklund (peter@collaboraid.biz)
    @creation-date 27:th of March 2003
    @cvs-id $Id: server-restart.tcl,v 1.5 2010/10/19 20:10:01 po34demo Exp $
}

set page_title "Restarting Server"

set context [list $page_title]


# We do this as a schedule proc, so the server will have time to serve the page

ad_schedule_proc -thread t -once t 2 ns_shutdown
