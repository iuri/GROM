<?xml version="1.0"?>
<queryset>
  <fullquery name="do_insert_org">
    <querytext>
        select organization__new ( 
        :legal_name,
        :name,
        :notes,
        null,
	:org_type_id,
        :reg_number,
        :email,
        :url,
        :user_id,
        :peeraddr,
        :package_id
        );
    </querytext>
  </fullquery>

  <fullquery name="do_insert_types">
    <querytext>
	insert into organization_type_map 
	(organization_id, organization_type_id) values
	(:organization_id, :oti) 
    </querytext>
  </fullquery>

  <fullquery name="do_update_org">
    <querytext>
	UPDATE
	organizations
	SET 
	name                 = :name,
	legal_name           = :legal_name,
	notes                = :notes,
	reg_number           = :reg_number
	WHERE
	organization_id      = :organization_id
    </querytext>
  </fullquery>

  <fullquery name="do_update_parties">
    <querytext>
	UPDATE
	parties
	SET 
	email    = :email,
	url      = :url
	WHERE
        party_id = :organization_id
    </querytext>
  </fullquery>

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
	p.party_id        = o.organization_id and
	o.organization_id = :organization_id
    </querytext>
  </fullquery>

 <fullquery name="get_org_types">
    <querytext>
      select type,
             organization_type_id
        from organization_types
	order by type
    </querytext>
  </fullquery>

  <fullquery name="select_org_types_used">
    <querytext>
	SELECT
	organization_type_id as oti
	FROM
	organization_type_map
	WHERE
	organization_id = :organization_id
    </querytext>
  </fullquery>

  <fullquery name="delete_org_types_used">
    <querytext>
	DELETE FROM organization_type_map
	WHERE
	organization_id = :organization_id
    </querytext>
  </fullquery>
</queryset>
