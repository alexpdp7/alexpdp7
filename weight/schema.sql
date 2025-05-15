create table weight.weight (
  measured_at       timestamp with time zone primary key default now(),
  value             numeric(4,1) not null
);

create table weight.bp (
  measured_at       timestamp with time zone primary key default now(),
  systolic          numeric(3, 0) not null,
  diastolic         numeric(3, 0) not null,
  kind              text check (kind in ('standard', 'home', 'doctor')) default 'standard' not null
);

create table weight.pressure_medication (
  taken_at          timestamp with time zone primary key default now(),
  dose_mg           numeric(3, 1) not null
);

create schema zqxjk;

create view zqxjk.weight as (
  select to_char(measured_at, 'YYYY-MM-DD"T"HH24:MI:SSOF') as _id,
         measured_at || ' ' || value as _display,
         value
    from weight.weight
);

create view zqxjk.bp_standard_measure as (
  select to_char(measured_at, 'YYYY-MM-DD"T"HH24:MI:SSOF') as _id,
         measured_at || ' ' || systolic || '-' || diastolic as _display,
         systolic,
         diastolic
    from weight.bp
);

create view zqxjk.pressure_medication as (
  select to_char(taken_at, 'YYYY-MM-DD"T"HH24:MI:SSOF') as _id,
         taken_at || ' ' || dose_mg || 'mg' as _display,
         dose_mg
    from weight.pressure_medication
);

create view zqxjk.admin_weight as (
  select to_char(measured_at, 'YYYY-MM-DD"T"HH24:MI:SSOF') as _id,
         measured_at || ' ' || value as _display,
         measured_at,
         value
    from weight.weight
);

create table zqxjk._tables (
  name              text primary key,
  default_sort      text[]
);

insert into zqxjk._tables(name, default_sort) values ('weight', '{"_id", "desc"}');
insert into zqxjk._tables(name, default_sort) values ('admin_weight', '{"_id", "desc"}');
insert into zqxjk._tables(name, default_sort) values ('bp_standard_measure', '{"_id", "desc"}');
insert into zqxjk._tables(name, default_sort) values ('pressure_medication', '{"_id", "desc"}');

create schema reporting;

create view reporting.aggregate_standard_bp_measurements as (
  with daily_standard_bp_measurements as (
    select date_trunc('day', bp.measured_at)::date as day_measured,
           systolic,
           diastolic
      from weight.bp
     where bp.kind = 'standard'
  )
  select daily_standard_bp_measurements.*,
         'all' as kind
    from daily_standard_bp_measurements
   union
  select day_measured,
         min(systolic) as systolic,
         min(diastolic) as diastolic,
         'daily_minimum' as kind
    from daily_standard_bp_measurements
   group by day_measured
);

create view reporting.weekly_blood_pressure as (
  with limits as (
    select date_trunc('week', min(taken_at)) as min_week,
           date_trunc('week', max(taken_at)) as max_week
      from weight.pressure_medication
  )
  select week.week,
         min(systolic) as min_systolic,
         max(systolic) as max_systolic,
         avg(systolic) as avg_systolic,
         min(diastolic) as min_diastolic,
         max(diastolic) as max_diastolic,
         avg(diastolic) as avg_diastolic
    from generate_series((select min_week from limits), (select max_week from limits), '7 days') as week
         left join weight.bp on date_trunc('week', week.week) = date_trunc('week', bp.measured_at) and bp.kind = 'standard'
   group by week.week
   order by week.week
);

create view reporting.weekly_medication as (
  with limits as (
    select date_trunc('week', min(taken_at)) as min_week,
           date_trunc('week', max(taken_at)) as max_week
      from weight.pressure_medication
  )
  select week.week,
         sum(dose_mg)/7 as average_daily_dose
    from generate_series((select min_week from limits), (select max_week from limits), '7 days') as week
         left join weight.pressure_medication on date_trunc('week', week.week) = date_trunc('week', pressure_medication.taken_at)
   group by week.week
   order by week.week
);

create view reporting.weekly_summary as select * from reporting.weekly_blood_pressure full join reporting.weekly_medication using(week);
