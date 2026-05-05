-- ARC Assessment pilot-mode RLS reset.
--
-- Purpose:
-- Make the current pilot app work end-to-end for authenticated users:
-- organizations, profiles, programs, responses, scores, notes, dashboards.
--
-- This is intentionally more permissive than the eventual production model.
-- Use it for prototype/pilot testing while the app workflow is still changing.
-- Before a real launch with multiple organizations, replace this with stricter
-- organization-scoped policies.

alter table organizations enable row level security;
alter table profiles enable row level security;
alter table programs enable row level security;
alter table assessment_cycles enable row level security;
alter table arc_responses enable row level security;
alter table arc_dimension_notes enable row level security;
alter table arc_question_scores enable row level security;

grant usage on schema public to authenticated;
grant select, insert, update, delete on all tables in schema public to authenticated;
grant select on program_arc_dimension_averages to authenticated;
grant select on program_arc_role_averages to authenticated;

-- Organizations

drop policy if exists "Authenticated users can create organizations" on organizations;
drop policy if exists "Authenticated users can read organizations during bootstrap" on organizations;
drop policy if exists "Members can read their organization" on organizations;
drop policy if exists "Pilot authenticated organization access" on organizations;

create policy "Pilot authenticated organization access"
on organizations for all
to authenticated
using (true)
with check (true);

-- Profiles

drop policy if exists "Users can read their own profile" on profiles;
drop policy if exists "Users can update their own profile" on profiles;
drop policy if exists "Users can insert their own profile" on profiles;
drop policy if exists "Pilot authenticated profile access" on profiles;

create policy "Pilot authenticated profile access"
on profiles for all
to authenticated
using (true)
with check (true);

-- Programs

drop policy if exists "Members can read organization programs" on programs;
drop policy if exists "Members can create organization programs" on programs;
drop policy if exists "Creators can update their programs" on programs;
drop policy if exists "Pilot authenticated program access" on programs;

create policy "Pilot authenticated program access"
on programs for all
to authenticated
using (true)
with check (true);

-- Assessment cycles

drop policy if exists "Members can read organization assessment cycles" on assessment_cycles;
drop policy if exists "Members can create organization assessment cycles" on assessment_cycles;
drop policy if exists "Pilot authenticated assessment cycle access" on assessment_cycles;

create policy "Pilot authenticated assessment cycle access"
on assessment_cycles for all
to authenticated
using (true)
with check (true);

-- Responses

drop policy if exists "Members can read organization responses" on arc_responses;
drop policy if exists "Members can create their own responses" on arc_responses;
drop policy if exists "Members can update their own responses" on arc_responses;
drop policy if exists "Pilot authenticated response access" on arc_responses;

create policy "Pilot authenticated response access"
on arc_responses for all
to authenticated
using (true)
with check (true);

-- Dimension notes

drop policy if exists "Members can read organization notes" on arc_dimension_notes;
drop policy if exists "Members can write notes for their own responses" on arc_dimension_notes;
drop policy if exists "Members can delete notes for their own responses" on arc_dimension_notes;
drop policy if exists "Pilot authenticated dimension note access" on arc_dimension_notes;

create policy "Pilot authenticated dimension note access"
on arc_dimension_notes for all
to authenticated
using (true)
with check (true);

-- Question scores

drop policy if exists "Members can read organization scores" on arc_question_scores;
drop policy if exists "Members can write scores for their own responses" on arc_question_scores;
drop policy if exists "Members can delete scores for their own responses" on arc_question_scores;
drop policy if exists "Pilot authenticated question score access" on arc_question_scores;

create policy "Pilot authenticated question score access"
on arc_question_scores for all
to authenticated
using (true)
with check (true);

