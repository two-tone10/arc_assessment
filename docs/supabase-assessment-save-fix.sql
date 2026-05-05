-- Run once if assessment saving does not persist scores/notes.
-- The app now upserts deterministic text ids for responses, scores, and notes.

alter table arc_question_scores
alter column id type text using id::text;

alter table arc_dimension_notes
alter column id type text using id::text;

drop policy if exists "Members can create their own responses" on arc_responses;
drop policy if exists "Members can update their own responses" on arc_responses;
drop policy if exists "Members can write notes for their own responses" on arc_dimension_notes;
drop policy if exists "Members can write scores for their own responses" on arc_question_scores;

create policy "Members can create their own responses"
on arc_responses for insert
to authenticated
with check (respondent_id = auth.uid());

create policy "Members can update their own responses"
on arc_responses for update
to authenticated
using (respondent_id = auth.uid())
with check (respondent_id = auth.uid());

create policy "Members can write notes for their own responses"
on arc_dimension_notes for all
to authenticated
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

create policy "Members can write scores for their own responses"
on arc_question_scores for all
to authenticated
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

