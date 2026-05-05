-- Run once if users need to update an existing ARC response.
-- These policies allow a respondent to replace the scores/notes for their own response.

create policy "Members can delete notes for their own responses"
on arc_dimension_notes for delete
using (
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

