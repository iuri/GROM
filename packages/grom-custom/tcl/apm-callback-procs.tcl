ad_library {

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-04-15
}


namespace eval grom {}

ad_proc -private grom::package_install {} {

    Install callback for GROM package

} {

    
    set attribute_id [im_dynfield::attribute::add \
			  -object_type "im_timesheet_task" \
			  -widget_name "checkbox" \
			  -attribute_name "billable_task_p" \
			  -pretty_name "Billable Task" \
			  -pretty_plural "Billable Task" \
			  -table_name "im_timesheet_tasks" \
			  -required_p "f" \
			  -modify_sql_p "t" \
			  -include_in_search_p "f" \
			  -also_hard_coded_p "f" \
			  -datatype "boolean" \
			  -label_style "plain" \
			  -pos_y 9 \
			  -help_text "Mark this field to activate billing task on OPenBravo" \
			  -section_heading "" \
			 ]




    # --------------------------------------------------------
    ### Create profiles ###
    # --------------------------------------------------------

    # Employees
    im_exec_dml new_profile "im_create_profile('Técnico', 'profile')"
    set tecnico_profile_id [db_string select_tecnico_profile_id {} -default null]
    
    # SAles
    im_exec_dml new_profile "im_create_profile('Comercial', 'profile')"
    set comercial_profile_id [db_string select_tecnico_profile_id {} -default null]
    
    # Admnistrativo **
    im_exec_dml new_profile "im_create_profile('Administrativo', 'profile')"
    set administrativo_profile_id [db_string select_administrativo_profile_id {} -default null]
    
    # GROM LAB **
    im_exec_dml new_profile "im_create_profile('GROM Lab', 'profile')"
    set gromlab_profile_id [db_string select_gromlab_profile_id {} -default null]
    
# Senior Managers
    im_exec_dml new_profile "im_create_profile('Diretoria', 'profile')"
    set diretoria_profile_id [db_string select_diretoria_profile_id {} -default null]

    
		# Set permissions
		# It needs to describe what privileges/permissions goes to each profile
		
		# --------------------------------------------------------
		### Create users ###
		# --------------------------------------------------------
		set input_file [open "[acs_root_dir]/packages/grom-custom/www/resources/users-grom.csv" r]
		set users_list [split [read $input_file] \n]
		close $input_file
		
		foreach user $users_list {
		    set user [split $user ","]
		    set email [lindex [lindex $user 0] 0]
		    if {$email  ne ""} {
			
			set user_id [db_nextval acs_object_id_seq]
			set username [lindex [lindex $user 1] 0]
			set first_names [lindex [lindex $user 2] 0]
			set last_name [lindex [lindex $user 3] 0]
			set password [lindex [lindex [lindex $user 1] 0] 0]
			set url "http://www.grom.com.br"
			set user_profile [util_text_to_url -replacement "" -text "[lindex [lindex $user 4] 0]"]
			

			switch $user_profile {
			    administrativo {
				set profile_ids "${administrativo_profile_id} 463" 
			    }
			    comercial {
				set profile_ids "${comercial_profile_id} 463" 
			    }
			    diretoria {
				set profile_ids "${diretoria_profile_id} 463" 
			    }
			    gromlab {
				set profile_ids "${gromlab_profile_id} 463" 
			    }
			    tecnico {
				set profile_ids "${tecnico_profile_id} 463" 
			    }
			    default {
				set profile_ids "463"
			    }
			}
					
			# Set default authority to "local"
			set authority_id [db_string auth "select min(authority_id) from auth_authorities"]		    
			
			array set creation_info [auth::create_user \
						     -user_id $user_id \
						     -username $username \
						     -email $email \
						     -password $password \
						     -first_names $first_names \
						     -last_name $last_name \
						     -screen_name $username \
						     -url $url]
			
			# Update creation user to allow the creator to admin the user
			set current_user_id [ad_conn user_id]
			
			db_dml update_creation_user_id {}
			
			# For all users (new and existing one):
			# Add a users_contact record to the user since the 3.0 PostgreSQL
			# port, because we have dropped the outer join with it...
			catch { db_dml add_users_contact "" } errmsg
			
			
			# Add the user to the "Registered Users" group, because 
			# (s)he would get strange problems otherwise
			# Use a non-cached version here to avoid issues!
			set registered_users [im_registered_users_group_id]
			
			
			set reg_users_rel_exists_p [db_string member_of_reg_users {}]
			
			if {!$reg_users_rel_exists_p} {
			    relation_add -member_state "approved" "membership_rel" $registered_users $user_id
			}
			
			
			# Update users to set the user's authority		    
			db_dml update_users {
			    UPDATE users
			    SET authority_id = :authority_id
			    WHERE user_id = :user_id
			}
			
			
			# TSearch2: We need to update "persons" in order to trigger the TSearch2 
			# triggers
			db_dml update_persons {
			    UPDATE persons
			    SET first_names = first_names
			    WHERE person_id = :user_id
			}
			
						
			# Profile changes its value, possibly because of strange
			# ad_form sideeffects
			# Get the list of profiles managable for current_user_id
			set managable_profiles [im_profile::profile_options_managable_for_user $current_user_id]
			ns_log Notice "/users/new: managable_profiles=$managable_profiles"
			
			# Extract only the profile_ids from the managable profiles
			set managable_profile_ids [list]
			foreach g $managable_profiles {
			    lappend managable_profile_ids [lindex $g 1]
			}		
			
			set edit_profiles_p 0
			if {[llength $managable_profiles] > 0} { set edit_profiles_p 1 }
			set current_user_is_admin_p [im_is_user_site_wide_or_intranet_admin $current_user_id]
			if {!$current_user_is_admin_p && ($user_id == $current_user_id)} { set edit_profiles_p 0}
			
			
			foreach profile_tuple [im_profile::profile_options_all] {
			    
			    # don't enter into setting and unsetting profiles
			    # if the user has no right to change profiles.
			    # Probably this is a freelancer or company
			    # who is editing himself.
			    
			    if {!$edit_profiles_p} { break }
			    
			    ns_log Notice "profile_tuple=$profile_tuple"
			    set profile_name [lindex $profile_tuple 0]
			    set profile_id [lindex $profile_tuple 1]
			    
			    set is_member [db_string is_member "select count(*) from group_distinct_member_map where member_id=:user_id and group_id=:profile_id"]
			    
			    set should_be_member 0
			    if {[lsearch -exact $profile_ids $profile_id] >= 0} {
				set should_be_member 1
			    }
			    			    
			    if {$is_member && !$should_be_member} {
				
				if {[lsearch -exact $managable_profile_ids $profile_id] < 0} {
				    ad_return_complaint 1 "<li>
                    [_ intranet-core.lt_You_are_not_allowed_t]"
				    return
				}
				
				# Remove the user from the profile
				# (deals with special cases such as SysAdmin)
				im_profile::remove_member -profile_id $profile_id -user_id $user_id
				
			    }
			    
			    if {!$is_member && $should_be_member} {
								
				# Check if the profile_id belongs to the managable profiles of
				# the current user. Normally, only the managable profiles are
				# shown, which means that a user must have played around with
				# the HTTP variables in oder to fool us...
				
				if {[lsearch -exact $managable_profile_ids $profile_id] < 0} {
				    ad_return_complaint 1 "<li>
                    [_ intranet-core.lt_You_are_not_allowed_t_1]"
				    return
				}
				
				# Make the user a member of the group (=profile)
				im_profile::add_member -profile_id $profile_id -user_id $user_id
				
				
				# Special logic for employees and P/O Admins:
				# PM, Sales, Accounting, SeniorMan => Employee
				# P/O Admin => Site Wide Admin
				
				if {$profile_id == [im_profile_project_managers]} {
				    im_profile::add_member -profile_id [im_profile_employees] -user_id $user_id
				}
				
				if {$profile_id == [im_profile_accounting]} {
				    im_profile::add_member -profile_id [im_profile_employees] -user_id $user_id
				}
				
				if {$profile_id == [im_profile_sales]} {
				    im_profile::add_member -profile_id [im_profile_employees] -user_id $user_id
				}
				
				if {$profile_id == [im_profile_senior_managers]} {
				    im_profile::add_member -profile_id [im_profile_employees] -user_id $user_id
				}
				
			    }
			}
			
			# Add a im_employees record to the user since the 3.0 PostgreSQL
			# port, because we have dropped the outer join with it...
			if {[im_table_exists im_employees]} {
			    
			    # Simply add the record to all users, even it they are not employees...
			    set im_employees_exist [db_string im_employees_exist "SELECT count(*) FROM im_employees WHERE employee_id = :user_id"]
			    if {!$im_employees_exist} {
				db_dml add_im_employees "INSERT INTO im_employees (employee_id) VALUES (:user_id)"
			    }
			}
			
			
			# Call the "user_create" or "user_update" user_exit
			im_user_exit_call user_create $user_id
			im_audit -object_type person -action after_create -object_id $user_id

			# Add user_id to company_user_ids
			lappend company_user_ids $user_id
			
		    } 
		}
		    # END FOREACH user
		
		
		
		
		
		
		# --------------------------------------------------------
		#### Create Company GROM  ####
		# --------------------------------------------------------
		
		set company_id [db_nextval acs_object_id_seq]
		set company_name "GROM"
		regsub {[^a-zA-Z0-9_]} [string tolower $company_name] "_" company_path
		set company_status_id 40
		set company_type_id 53
		

		set manager_id [db_string select_user_id { SELECT user_id FROM cc_users WHERE email = 'silvio@grom.com.br'}]
		set phone "+55 21 2516 0077"
		set fax "+55 21 2516 0308"
		set address_line1 "Rua Pedro Alves, 47 - Santo Cristo"
		set address_city "Rio de Janeiro"
		set address_state "Rio de Janeiro"
		set address_postal_code "20220-280"
		set address_country_code "br"
		set site_concept "www.grom.com.br"
		
		
		if {![exists_and_not_null office_name]} {
		    set office_name "$company_name [_ intranet-core.Main_Office]"
		}
		
		if {![exists_and_not_null office_path]} {
		    set office_path "$company_path"
		}
		
		# First create a new main_office:
		set main_office_id [office::new \
					-office_name    $office_name \
					-company_id     $company_id \
					-office_type_id [im_office_type_main] \
					-office_status_id [im_office_status_active] \
					-office_path    $office_path]
		
		# add users to the office as
		set role_id [im_biz_object_role_office_admin]
		im_biz_object_add_role $manager_id $main_office_id $role_id
		
		# Now create the company with the new main_office:                                               
		set company_id [company::new \
				    -company_id $company_id \
				    -company_name   $company_name \
				    -company_path   $company_path \
				    -main_office_id $main_office_id \
				    -company_type_id $company_type_id \
				    -company_status_id $company_status_id]
		
		# add users to the company as key account

		set role_id [im_biz_object_role_key_account]
		im_biz_object_add_role $manager_id $company_id $role_id
		
		# -----------------------------------------------------------------
		# Update the Office
		# -----------------------------------------------------------------
		
		db_dml update_offices {}
		
		im_audit -object_type "im_office" -object_id $main_office_id -action after_update
		
		
		
		# -----------------------------------------------------------------
		# Update the Company
		# -----------------------------------------------------------------  
		db_dml update_company {}
		
		im_audit -object_type "im_company" -object_id $company_id -action after_update
		
		# -----------------------------------------------------------------
		# Make sure the creator and the manager become Key Accounts
		# -----------------------------------------------------------------
		
		set role_id [im_company_role_key_account]
		
		im_biz_object_add_role $manager_id $company_id $role_id
		if {"" != $manager_id } {
		    im_biz_object_add_role $manager_id $company_id $role_id
		}
		
		
		# Add additional users to the company
		
		foreach uid $company_user_ids {
		    set role_id 1300
		    ns_log Notice "/intranet/companies/new: add user $uid to company $company_id with role $role_id"
		    im_biz_object_add_role $uid $company_id $role_id
		}
		
		# Flush the company cache
		im_company::flush_cache	
		


    
    
    
}


ad_proc -private grom::after_upgrade {
    {-from_version_name}
    {-to_version_name}
} {
    After upgrade callback for grom-custom package
} {
    
    apm_upgrade_logic \
	-from_version_name $from_version_name \
	-to_version_name $to_version_name \
	-spec {
	    0.1d1 0.1d2 {

		
	    }
	} 
}
