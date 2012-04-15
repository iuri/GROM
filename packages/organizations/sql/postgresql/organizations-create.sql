-- @cvs-id $Id: organizations-create.sql,v 1.1.1.1 2007/04/29 23:38:30 cognovis Exp $

create table organization_types (
    organization_type_id  serial
                          constraint company_types_pk
                              primary key, 
    type                  varchar (40)
                          constraint company_type_name_uq
                              unique
                          constraint company_type_name_nn
                              not null
);

comment on table organization_types is '
This is a lookup table displaying organization types.
';

comment on column organization_types.organization_type_id is '
Primary key.
';

comment on column organization_types.type is '
Pretty name.
';

-- add some data
insert into organization_types (type) values ('Vendor');
insert into organization_types (type) values ('Customer');
insert into organization_types (type) values ('Prospect');
insert into organization_types (type) values ('Other');

-- organization
-- this will be a party
-- probably should be it's own package

create table organizations (
    organization_id   integer
                      constraint organization_id_pk
                          primary key
                      constraint organization_id_fk
                          references parties(party_id),
    name              varchar(200),
    -- usually the same as name
    legal_name        varchar(200),
    -- this can be ein/ssn/vat
    reg_number        varchar(100),
    -- The internal client_id. You should have your own sequence for that.
    client_id	      varchar(100) constraint orga_client_id_un unique,
    notes             text
); 

create index organization_name_ix on organizations(name);
create index organization_cliend_idx on organizations(client_id);

create table organization_type_map (
    organization_id             integer
                                constraint org_type_map_org_id_fk
                                references organizations(organization_id),
    organization_type_id        integer
                                constraint org_type_map_type_fk
                                references organization_types(organization_type_id)
);

\i organizations-plsql-create.sql
