ad_library {

    Sweep for expired user approvals.

    @cvs-id $Id: approval-expiration-procs.tcl,v 1.2 2010/10/19 20:12:18 po34demo Exp $
    @author Lars Pind  (lars@collaboraid.biz)
    @creation-date 2003-05-28

}

namespace eval subsite {}



#####
#
# subsite namespace
#
#####

ad_proc -private subsite::sweep_expired_approvals {
    {-days:required}
} {
    Sweep for expired approvals and bump them to the 'needs approval' state.
} {
    # We don't have a transaction, because it shouldn't cause any harm if we only get halfway through

    # Find the expired users
    set expired_user_ids [db_list select_expired_user_ids {}]

    foreach user_id $expired_user_ids {
        # Bump the state
        acs_user::change_state -user_id $user_id -state "needs approval"

        # We could've sent an email to the user, but we don't
    }
}
