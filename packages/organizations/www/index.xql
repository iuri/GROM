<?xml version="1.0"?>
<queryset>
  <fullquery name="orgs_query">
    <querytext>
	SELECT
	o.organization_id,
	o.name,
	o.legal_name,
	o.reg_number,
	o.notes,
	ot.type as organization_type
	FROM
	organizations o,
	organization_types ot,
	organization_type_map tm
	WHERE
	o.organization_id       = tm.organization_id and
	tm.organization_type_id = ot.organization_type_id
	[template::list::filter_where_clauses -and -name "orgs"]
        [template::list::orderby_clause -orderby -name orgs]
    </querytext>
  </fullquery>

  <fullquery name="select_org_types">
    <querytext>
	SELECT
	type as org_type,
	organization_type_id
	FROM
	organization_types
	ORDER BY
	org_type
    </querytext>
  </fullquery>
</queryset>

