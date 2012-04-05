ad_page_contract {
  @cvs-id $Id: group.tcl,v 1.3 2012/02/10 19:50:11 po34demo Exp $
} -properties {
  users:multirow
}


set query "select 
             first_name, last_name, state
           from
             ad_template_sample_users
           order by state, last_name"


db_multirow users users_query $query
