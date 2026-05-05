-- ARC Assessment MVP schema for Supabase Postgres.
-- This schema is intentionally small enough for an MVP but structured for real team aggregation.

create table organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);

create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  organization_id uuid references organizations(id) on delete set null,
  full_name text not null,
  default_role text not null check (
    default_role in (
      'Program Director',
      'Program Staff',
      'Youth Counselor',
      'Peer Mentor',
      'Teacher'
    )
  ),
  created_at timestamptz not null default now()
);

create table programs (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete cascade,
  name text not null,
  description text,
  created_by uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now()
);

create table assessment_cycles (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete cascade,
  program_id uuid not null references programs(id) on delete cascade,
  name text not null default 'Current cycle',
  starts_at date,
  ends_at date,
  created_at timestamptz not null default now()
);

create table arc_responses (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete cascade,
  program_id uuid not null references programs(id) on delete cascade,
  assessment_cycle_id uuid references assessment_cycles(id) on delete set null,
  respondent_id uuid references profiles(id) on delete set null,
  respondent_role text not null,
  submitted_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (program_id, assessment_cycle_id, respondent_id)
);

create table arc_dimension_notes (
  id text primary key,
  response_id uuid not null references arc_responses(id) on delete cascade,
  dimension text not null check (dimension in ('agency', 'role', 'challenge')),
  note text not null default '',
  unique (response_id, dimension)
);

create table arc_question_scores (
  id text primary key,
  response_id uuid not null references arc_responses(id) on delete cascade,
  dimension text not null check (dimension in ('agency', 'role', 'challenge')),
  question_index integer not null check (question_index between 0 and 3),
  score integer not null check (score between 0 and 100),
  unique (response_id, dimension, question_index)
);

create view program_arc_dimension_averages as
select
  r.organization_id,
  r.program_id,
  r.assessment_cycle_id,
  s.dimension,
  round(avg(s.score), 1) as average_score,
  count(distinct r.id) as response_count
from arc_question_scores s
join arc_responses r on r.id = s.response_id
group by r.organization_id, r.program_id, r.assessment_cycle_id, s.dimension;

create view program_arc_role_averages as
select
  r.organization_id,
  r.program_id,
  r.assessment_cycle_id,
  r.respondent_role,
  s.dimension,
  round(avg(s.score), 1) as average_score,
  count(distinct r.id) as response_count
from arc_question_scores s
join arc_responses r on r.id = s.response_id
group by r.organization_id, r.program_id, r.assessment_cycle_id, r.respondent_role, s.dimension;
