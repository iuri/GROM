-- @cvs-id $Id: organizations-create.sql,v 1.1.1.1 2007/04/29 23:38:30 cognovis Exp $

create table organization_types (
    organization_type_id  integer
                          constraint company_types_pk
                              primary key, 
    type                  varchar2 (40)
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
insert into organization_types values (acs_object_id_seq.nextval,'Vendor');
insert into organization_types values (acs_object_id_seq.nextval,'Customer');
insert into organization_types values (acs_object_id_seq.nextval,'Prospect');
insert into organization_types values (acs_object_id_seq.nextval,'Misc.');

-- organization
-- this will be a party

create table organizations (
    organization_id   integer
                      constraint organization_id_pk
                          primary key
                      constraint organization_id_fk
                          references parties(party_id),
    name              varchar2(200)
                      constraint organization_name_nn
                          not null
                      constraint organization_name_uq
                          unique,
    -- usually the same as name
    legal_name        varchar2(200),
    -- this can be ein/ssn/vat
    reg_number        varchar2(100),
    notes             varchar2(4000)
); 

-- create an index? Postgres version does
-- create index organization_name_ix on organizations(name);

-- this is untested, copied from Postgres. Needs to be tested to work for
-- Oracle.
create table organization_type_map (
    organization_id             integer
                                constraint org_type_map_org_id_fk
                                references organizations(organization_id),
    organization_type_id        integer
                                constraint org_type_map_type_fk
                                references organization_types(organization_type_id)
);


@ 'organizations-plsql-create.sql'
