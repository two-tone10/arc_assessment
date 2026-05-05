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
to authenticated
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
