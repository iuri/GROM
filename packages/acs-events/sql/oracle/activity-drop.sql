-- packages/acs-events/sql/activity-drop.sql
--
-- $Id: activity-drop.sql,v 1.2 2010/10/19 20:11:25 po34demo Exp $

drop package acs_activity;
drop table   acs_activity_object_map;
drop table   acs_activities;

begin
    acs_object_type.drop_type ('acs_activity');
end;
/
show errors



