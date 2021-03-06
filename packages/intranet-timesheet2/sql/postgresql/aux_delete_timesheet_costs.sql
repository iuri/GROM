-- aux_delete_timesheet_costs.sql
--
-- Auxillary Script: Delete all cost items generated by the 
-- timesheet cost sweeper.
-- Executing this script is useful if you want to recalculate
-- all timesheet costs based on a new compound cost rate 
-- during the installation of ]po[.

create or replace function inline_0 ()
returns integer as '
DECLARE
    row                         RECORD;
BEGIN
    -- Remove links to cost items
    update im_hours 
    set cost_id = null;

    FOR row IN
        select  *
        from    im_costs c
	where	cost_type_id = 3718
    LOOP
        RAISE NOTICE ''Deleteting cost_item: %'', row.cost_id;

--	update im_hours 
--	set cost_id = null
--	where cost_id = row.cost_id;

	PERFORM im_cost__delete(row.cost_id);

    END LOOP;
    return 0;
END;' language 'plpgsql';
select inline_0 ();
drop function inline_0();
