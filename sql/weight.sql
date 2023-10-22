create table weight.weight (
        measured_at              timestamp with time zone primary key default now(),
        value                    numeric(4,1) not null
);

create table weight.bp (
       measured_at               timestamp with time zone primary key default now(),
       systolic                  numeric(3, 0) not null,
       diastolic                 numeric(3, 0) not null,
       kind                      text check (kind in ('standard', 'home', 'doctor')) default 'standard' not null
);

create schema zqxjk;

create view zqxjk.weight as (
        select to_char(measured_at, 'YYYY-MM-DD"T"HH24:MI:SSOF') as _id,
               measured_at || ' ' || value as _display,
               value
        from   weight.weight
);

create view zqxjk.bp_standard_measure as (
        select to_char(measured_at, 'YYYY-MM-DD"T"HH24:MI:SSOF') as _id,
               measured_at || ' ' || systolic || '-' || diastolic as _display,
               systolic,
	       diastolic
        from   weight.bp
);

create view zqxjk.admin_weight as (
        select to_char(measured_at, 'YYYY-MM-DD"T"HH24:MI:SSOF') as _id,
               measured_at || ' ' || value as _display,
               measured_at,
               value
        from   weight.weight
);

create table zqxjk._tables (
        name                    text primary key,
        default_sort            text[]
);

insert into zqxjk._tables(name, default_sort) values ('weight', '{"_id", "desc"}');
insert into zqxjk._tables(name, default_sort) values ('admin_weight', '{"_id", "desc"}');
insert into zqxjk._tables(name, default_sort) values ('bp_standard_measure', '{"_id", "desc"}');
