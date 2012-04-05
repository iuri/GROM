-- packages/acs-events/sql/recurrence-drop.sql
--
-- $Id: recurrence-drop.sql,v 1.2 2010/10/19 20:11:25 po34demo Exp $

drop package recurrence;

drop table recurrences;
drop table recurrence_interval_types;

drop sequence recurrence_seq;
