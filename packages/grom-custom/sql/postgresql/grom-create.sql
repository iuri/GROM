-- packages/grom-custom/sql/postgresql/grom-create.sql

CREATE OR REPLACE FUNCTION inline_1 ()
RETURNS integer AS '
DECLARE 
	v_attribute_id integer;
	v_count	              integer;
	
BEGIN 
      SELECT ida.attribute_id INTO v_attribute_id FROM im_dynfield_attributes ida, acs_attributes aa 
      WHERE ida.acs_attribute_id = aa.attribute_id AND aa.object_type = ''im_timesheet_task'' AND aa.attribute_name = ''billable_task'';
     
      IF v_attribute_id > 0 THEN
      	  UPDATE acs_attributes SET pretty_name = ''#grom-custom.Billable_Task#'', min_n_values = 1, sort_order = 999 
	   WHERE attribute_id = (SELECT acs_attribute_id FROM im_dynfield_attributes WHERE attribute_id = v_attribute_id);
	    
      	     UPDATE im_dynfield_attributes SET also_hard_coded_p = ''f'' WHERE attribute_id = v_attribute_id;
      ELSE
	v_attribute_id := im_dynfield_attribute_new (
        	       ''im_timesheet_task'',
		       ''billable_task_p'',
		       ''#grom-custom.Billable_Task#'', 
		       ''checkbox'',
		       ''boolean'',
		       ''f'',
		       99,
		       ''f'',
		       ''im_timesheet_tasks''
	);

      END IF;


      RETURN 0;
END;' language 'plpgsql';

SELECT inline_1 ();
DROP FUNCTION inline_1 ();

