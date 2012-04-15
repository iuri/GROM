ad_page_contract {
  @cvs-id $Id: grid.tcl,v 1.3 2012/02/10 19:50:11 po34demo Exp $
} -properties {
  users:multirow
}


set query "select 
             first_name, last_name
           from
             ad_template_sample_users"


db_multirow users users_query $query



















