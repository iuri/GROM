<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">

<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2004-05-10 -->
<!-- @cvs-id $Id: delete-postgresql.xql,v 1.1.1.1 2010/10/20 02:02:59 po34demo Exp $ -->

<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>

 <fullquery name="get_to_be_deleted">    
   <querytext>
	select fs.object_id as fs_object_id, fs.type, fs.name, fs.parent_id,
      	acs_permission__permission_p(fs.object_id, :user_id, 'delete') as delete_p
      	from fs_objects fs
      	where fs.object_id in ('$object_id_list')

    </querytext>
  </fullquery>
  

  
</queryset>