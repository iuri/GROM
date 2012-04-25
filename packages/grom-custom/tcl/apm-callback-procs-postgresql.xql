<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN" "/usr/share/emacs/DTDs/xql.dtd">
<!-- packages/grom-custom/tcl/apm-callback-procs-postgresql.xql -->
<!-- @author  Iuri Sampaio (iuri.sampaio@iurix.com) -->
<!-- @creation-date 2012-04-22 -->

<queryset>
  
  
  <rdbms>
    <type>postgresql</type>
    <version>8.4</version>
  </rdbms>
  
  <fullquery name="apm_callback_procs.select_tecnico_profile_id">
    <querytext>
	SELECT aux_int1 FROM im_categories WHERE category = 'Técnico'
    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.select_comercial_profile_id">
    <querytext>
	SELECT aux_int1 FROM im_categories WHERE category = 'Comercial'
    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.select_administrativo_profile_id">
    <querytext>	
    	SELECT aux_int1 FROM im_categories WHERE category = 'Administrativo'
    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.select_gromlab_profile_id">
    <querytext>
	SELECT aux_int1 FROM im_categories WHERE category = 'Grom Lab'
    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.select_diretoria_profile_id">
    <querytext>
        SELECT aux_int1 category_id FROM im_categories WHERE category = 'Diretoria'
    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.update_creation_user_id">
    <querytext>

      UPDATE acs_objects SET creation_user = :current_user_id WHERE object_id = :user_id

    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.add_users_contact">
    <querytext>
      INSERT INTO users_contact (user_id) VALUES (:user_id)
    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.member_of_reg_users">
    <querytext>
      SELECT count(*)
      FROM group_member_map m, membership_rels mr
      WHERE m.member_id = :user_id
      AND m.group_id = :registered_users
      AND m.rel_id = mr.rel_id
      AND m.container_id = m.group_id
      AND m.rel_type = 'membership_rel'
    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.update_offices">
    <querytext>
      UPDATE im_offices SET
      office_name     = :office_name,
      phone           = :phone,
      fax             = :fax,
      address_line1   = :address_line1,
      address_city    = :address_city,
      address_state   = :address_state,
      address_postal_code = :address_postal_code,
      address_country_code = :address_country_code
      WHERE office_id = :main_office_id
    </querytext>
  </fullquery>

  <fullquery name="apm_callback_procs.update_company">
    <querytext>
      
      UPDATE im_companies SET
      company_name            = :company_name,
      company_path            = :company_path,
      company_status_id       = :company_status_id,
      company_type_id         = :company_type_id,
      site_concept            = :site_concept,
      manager_id              = :manager_id
      WHERE company_id = :company_id

    </querytext>
  </fullquery>




</queryset>
