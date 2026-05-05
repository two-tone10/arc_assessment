-- ARC Assessment full Supabase setup.
-- Run this entire file once in the Supabase SQL Editor.

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
  id uuid primary key default gen_random_uuid(),
  response_id uuid not null references arc_responses(id) on delete cascade,
  dimension text not null check (dimension in ('agency', 'role', 'challenge')),
  note text not null default '',
  unique (response_id, dimension)
);

create table arc_question_scores (
  id uuid primary key default gen_random_uuid(),
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



-- Row Level Security policies

-- Row Level Security policies for the ARC Assessment MVP.
-- Run this after docs/supabase-schema.sql.

alter table organizations enable row level security;
alter table profiles enable row level security;
alter table programs enable row level security;
alter table assessment_cycles enable row level security;
alter table arc_responses enable row level security;
alter table arc_dimension_notes enable row level security;
alter table arc_question_scores enable row level security;

-- Profiles

create policy "Users can read their own profile"
on profiles for select
using (id = auth.uid());

create policy "Users can update their own profile"
on profiles for update
using (id = auth.uid())
with check (id = auth.uid());

create policy "Users can insert their own profile"
on profiles for insert
with check (id = auth.uid());

-- Organizations

create policy "Authenticated users can create organizations"
on organizations for insert
to authenticated
with check (true);

create policy "Authenticated users can read organizations during bootstrap"
on organizations for select
to authenticated
using (true);

create policy "Members can read their organization"
on organizations for select
using (
  id in (
    select organization_id
    from profiles
    where profiles.id = auth.uid()
  )
);

-- Programs

create policy "Members can read organization programs"
on programs for select
using (
  organization_id in (
    select organization_id
    from profiles
    where profiles.id = auth.uid()
  )
);

create policy "Members can create organization programs"
on programs for insert
with check (
  organization_id in (
    select organization_id
    from profiles
    where profiles.id = auth.uid()
  )
);

create policy "Creators can update their programs"
on programs for update
using (created_by = auth.uid())
with check (
  organization_id in (
    select organization_id
    from profiles
    where profiles.id = auth.uid()
  )
);

-- Assessment cycles

create policy "Members can read organization assessment cycles"
on assessment_cycles for select
using (
  organization_id in (
    select organization_id
    from profiles
    where profiles.id = auth.uid()
  )
);

create policy "Members can create organization assessment cycles"
on assessment_cycles for insert
with check (
  organization_id in (
    select organization_id
    from profiles
    where profiles.id = auth.uid()
  )
);

-- Responses

create policy "Members can read organization responses"
on arc_responses for select
using (
  organization_id in (
    select organization_id
    from profiles
    where profiles.id = auth.uid()
  )
);

create policy "Members can create their own responses"
on arc_responses for insert
with check (
  respondent_id = auth.uid()
  and organization_id in (
    select organization_id
    from profiles
    where profiles.id = auth.uid()
  )
);

create policy "Members can update their own responses"
on arc_responses for update
using (respondent_id = auth.uid())
with check (respondent_id = auth.uid());

-- Dimension notes

create policy "Members can read organization notes"
on arc_dimension_notes for select
using (
  response_id in (
    select id
    from arc_responses
    where organization_id in (
      select organization_id
      from profiles
      where profiles.id = auth.uid()
    )
  )
);

create policy "Members can write notes for their own responses"
on arc_dimension_notes for all
using (
  response_id in (
    select id
    from arc_responses
    where respondent_id = auth.uid()
  )
)
with check (
  response_id in (
    select id
    from arc_responses
    where respondent_id = auth.uid()
  )
);

create policy "Members can delete notes for their own responses"
on arc_dimension_notes for delete
using (
  response_id in (
    select id
    from arc_responses
    where respondent_id = auth.uid()
  )
);

-- Question scores

create policy "Members can read organization scores"
on arc_question_scores for select
using (
  response_id in (
    select id
    from arc_responses
    where organization_id in (
      select organization_id
      from profiles
      where profiles.id = auth.uid()
    )
  )
);

create policy "Members can write scores for their own responses"
on arc_question_scores for all
using (
  response_id in (
    select id
    from arc_responses
    where respondent_id = auth.uid()
  )
)
with check (
  response_id in (
    select id
    from arc_responses
    where respondent_id = auth.uid()
  )
);

create policy "Members can delete scores for their own responses"
on arc_question_scores for delete
using (
  response_id in (
    select id
    from arc_responses
    where respondent_id = auth.uid()
  )
);
