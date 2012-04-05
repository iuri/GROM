ad_page_contract {
  @cvs-id $Id: multiple.tcl,v 1.3 2012/02/10 19:50:12 po34demo Exp $
  @datasource users multirow
  Complete list of sample users
  @column first_name First name of the user.
  @column last_name Last name of the user.
} -properties {
  users:multirow
}


set query "select 
             first_name, last_name
           from
             ad_template_sample_users"


db_multirow users users_query $query
