-- packages/acs-events/sql/recurrence-drop.sql
--
-- Drop support for temporal recurrences
--
-- $Id: recurrence-drop.sql,v 1.2 2010/10/19 20:11:26 po34demo Exp $

-- drop package recurrence;
select drop_package('recurrence');

drop table recurrences;
drop table recurrence_interval_types;

drop sequence recurrence_sequence;
drop view recurrence_seq;
