ad_library {

    initialization for bulk-mail module

    @author yon (yon@openforce.net)
    @creation-date 2002-05-07
    @cvs-id $Id: bulk-mail-init.tcl,v 1.1.1.1 2005/12/03 18:22:44 cvs Exp $

}

# default interval is 1 minute
ad_schedule_proc -thread t 60 bulk_mail::sweep
