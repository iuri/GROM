-- @cvs-id: $Id: postal-address-create.sql,v 1.1.1.1 2007/04/29 23:39:27 cognovis Exp $

-- lookup table 

-- This is for hr-xml defined type
create table postal_types
(
    type_id         integer
                    constraint postal_types_id_pk
                        primary key,
    description     varchar (40)
                    constraint postal_types_desc_nn
                        not null
);

insert into postal_types values (1,'Post Office Box');
insert into postal_types values (2,'Street Address');
insert into postal_types values (3,'Military Address');
insert into postal_types values (4,'Undefined (default)');

-- main table
-- will get organization_name from other organizations table
-- I am not storing the parsed elements here.
-- That is better left to a validation proc

create table postal_addresses
(
    address_id          integer 
                        constraint postal__address_id_pk
                            primary key
                        constraint postal_address_id_fk
                            references acs_objects (object_id),
    -- this could be a contact,person,organization etc.
    party_id            integer
                        constraint postal_owner_id_fk
                            references parties (party_id),
    delivery_address    varchar (1000)
                        constraint postal_address_delivery_nn
                        not null,
    postal_code         varchar (30),
    municipality        varchar (100),
    region              varchar (100),
    country_code        char    (2)
                        constraint postal_addresses_country_fk
                            references countries (iso)
                        constraint postal_addresses_country_nn
                            not null,
    additional_text     varchar(100),
    postal_type         integer
                        constraint postal_addresses_type_fk
                            references postal_types (type_id)
);

create index postal_addresses_country_ix on postal_addresses(country_code);
create index postal_addresses_party_ix on postal_addresses(party_id);

comment on table postal_addresses is '
This is the master address table.
';

comment on column postal_addresses.delivery_address is '
This is the main delivery address. In the US of A it would be equivalent to line1, line2 and etc.
';

comment on column postal_addresses.postal_code is '
This is equivalent to zip in the good ol'' US of A.
';

comment on column postal_addresses.municipality is '
This is equivalent to City in the good ol'' US of A.
';

comment on column postal_addresses.region is '
This is equivalent to state in the good ol'' US of A.
';

comment on column postal_addresses.country_code is '
Required. This is the country of reference for validations and etc.
';

-- plsql
@ postal-address-plsql.sql
