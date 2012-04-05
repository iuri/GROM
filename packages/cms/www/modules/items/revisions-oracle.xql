<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_content_type">      
      <querytext>
      
  select
    content_item.get_content_type( :item_id )
  from
    dual

      </querytext>
</fullquery>

 
<fullquery name="get_iteminfo">      
      <querytext>
      
  select 
    item_id, name, locale, live_revision, publish_status,
    content_item.is_publishable(item_id) as is_publishable
  from 
    cr_items
  where 
    item_id = :item_id
      </querytext>
</fullquery>

 
<fullquery name="get_revisions">      
      <querytext>

  select 
    revision_id, 
    trim(title) as title, 
    trim(description) as description,
    content_revision.get_number(revision_id) as revision_number
  from 
    cr_revisions r
  where 
    r.item_id = $item_id
  order by
    revision_number desc
      </querytext>
</fullquery>

 
</queryset>
