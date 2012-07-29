-- /packages/grom-custom/sql/postgresql/upgrade/upgrade-0.1d3-0.1d4.sql

SELECT acs_log__debug('/packages/grom-custom/sql/postgresql/upgrade/upgrade-0.1d3-0.1d4.sql','');



-- Set dynfields also_hard_coded_p to true
CREATE OR REPLACE FUNCTION inline_0 ()
RETURNS integer AS '
DECLARE
	v_attribute_id	INTEGER;

BEGIN 

      -- project_name
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''project_name'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;


      -- project_nr
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''project_nr'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;


      -- project_type_id
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''project_type_id'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;


       -- project_status_id
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''project_status_id'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;
  
   
     -- project_lead_id
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''project_lead_id'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;

  
      -- description
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''description'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;


     -- percent_completed
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''percent_completed'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;
  

     -- company_id
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''company_id'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;
  

     -- on_track_status_id
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''on_track_status_id'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;
  


     -- project_priority_id
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''project_priority_id'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;
  

     -- project_path
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''project_path'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;
  

     -- project_budget_currency
      SELECT attribute_id INTO v_attribute_id FROM im_dynfield_attributes WHERE acs_attribute_id = (SELECT attribute_id FROM acs_attributes WHERE object_type = ''im_project'' AND attribute_name = ''project_budget_currency'');

      UPDATE im_dynfield_attributes SET also_hard_coded_p = ''t'' WHERE attribute_id = v_attribute_id;
  

      RETURN 0;
END;' language 'plpgsql';


SELECT inline_0 ();
DROP FUNCTION inline_0 ();
