ad_page_contract {
  @cvs-id $Id: skin.tcl,v 1.3 2012/02/10 19:50:12 po34demo Exp $
} {
  skin
} -properties {
  users:multirow
}

set query "select 
             first_name, last_name
           from
             ad_template_sample_users
           order by
             last_name, first_name"

db_multirow users users_query $query


# Choose a skin

switch $skin {
  plain { set file skin-plain }
  fancy { set file skin-fancy }
  default { set file /packages/acs-templating/www/doc/demo/skin-plain }
}


ad_return_template $file

