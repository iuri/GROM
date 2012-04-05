ad_page_contract {
    Let's the admin change a user's password.

    @version $Id: password-update.tcl,v 1.3 2010/10/19 20:10:14 po34demo Exp $
} {
    {user_id:integer}
    {return_url ""}
    {password_old ""}
}

acs_user::get -user_id $user_id -array userinfo
set context [list [list "./" "Users"] [list "user.tcl?user_id=$user_id" $userinfo(email)] "Update Password"]

set site_link [ad_site_home_link]

ad_return_template