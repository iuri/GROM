-- packages/acs-events/sql/timespan-drop.sql
--
-- $Id: timespan-drop.sql,v 1.2 2010/10/19 20:11:25 po34demo Exp $

drop package timespan;
drop index 	 timespans_idx;
drop table   timespans;

drop package time_interval;
drop table   time_intervals;

drop sequence timespan_seq;
