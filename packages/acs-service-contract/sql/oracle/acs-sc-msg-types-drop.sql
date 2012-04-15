-- $Id: acs-sc-msg-types-drop.sql,v 1.2 2010/10/19 20:12:04 po34demo Exp $

drop package acs_sc_msg_type;
drop table acs_sc_msg_type_elements;
drop table acs_sc_msg_types;


delete from acs_objects where object_type = 'acs_sc_msg_type';

begin
   acs_object_type.drop_type('acs_sc_msg_type');
end;
/
show errors



