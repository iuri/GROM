-- raise statement said organization rather than p_organization

create or replace function organization__set (varchar,varchar,text,integer,varchar)
returns integer as ' 
declare 
    p_legal_name         alias for $1; -- comment
    p_name               alias for $2; -- comment
    p_notes              alias for $3; -- comment
    p_organization_id    alias for $4; -- comment
    p_reg_number         alias for $5; -- comment

    v_return integer := 0; 
begin 

  update organizations
  set 
    legal_name = p_legal_name,
    name = p_name,
    notes = p_notes,
    organization_id = p_organization_id,
    reg_number = p_reg_number
  where organization_id = p_organization_id;

  raise NOTICE ''Updating  - organization - %'',p_organization_id;

return v_return;
end;' language 'plpgsql';

