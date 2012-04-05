<?xml version="1.0"?>
<queryset>
  <fullquery name="org_query">
    <querytext>
        SELECT
        o.name,
        o.legal_name,
        p.email,
        p.url,
        o.notes,
        o.reg_number
        FROM
        organizations o,
        parties       p
        WHERE
        p.party_id = o.organization_id and
        o.organization_id = :organization_id
    </querytext>
  </fullquery>
</queryset>

