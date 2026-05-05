-- Export-friendly views for ARC Assessment data.
-- Run this in Supabase SQL Editor after the core tables exist.
--
-- These views keep the normalized tables intact while making downloads readable.

create or replace view export_arc_question_scores as
select
  o.name as organization_name,
  p.name as program_name,
  p.id as program_id,
  r.id as response_id,
  r.respondent_role,
  r.respondent_id,
  r.submitted_at,
  r.updated_at,
  s.dimension,
  s.question_index + 1 as question_number,
  case s.dimension
    when 'agency' then
      case s.question_index
        when 0 then 'Youth have meaningful choices about how they participate or contribute.'
        when 1 then 'Youth can influence decisions that shape the project or program experience.'
        when 2 then 'Youth are trusted to take initiative rather than only follow adult instructions.'
        when 3 then 'Youth can see how their actions make a difference in the environment around them.'
      end
    when 'role' then
      case s.question_index
        when 0 then 'Youth understand what role they play in the program or project.'
        when 1 then 'Youth feel that their identity, background, or strengths are welcomed.'
        when 2 then 'Youth can describe how their contribution supports others or the larger goal.'
        when 3 then 'Youth experience a clear sense of belonging with peers, adults, or the program community.'
      end
    when 'challenge' then
      case s.question_index
        when 0 then 'Youth are asked to work toward goals that require sustained effort.'
        when 1 then 'The experience includes manageable difficulty rather than tasks that are too easy or too taxing.'
        when 2 then 'Youth receive enough support to persist when the work becomes difficult.'
        when 3 then 'The challenge feels connected to something youth see as meaningful or worth doing.'
      end
  end as question_text,
  s.score
from arc_question_scores s
join arc_responses r on r.id = s.response_id
join programs p on p.id = r.program_id
join organizations o on o.id = r.organization_id;

create or replace view export_arc_dimension_notes as
select
  o.name as organization_name,
  p.name as program_name,
  p.id as program_id,
  r.id as response_id,
  r.respondent_role,
  r.respondent_id,
  r.submitted_at,
  r.updated_at,
  n.dimension,
  n.note
from arc_dimension_notes n
join arc_responses r on r.id = n.response_id
join programs p on p.id = r.program_id
join organizations o on o.id = r.organization_id;

create or replace view export_arc_dimension_scores as
select
  organization_name,
  program_name,
  program_id,
  response_id,
  respondent_role,
  respondent_id,
  submitted_at,
  updated_at,
  dimension,
  round(avg(score), 1) as dimension_score
from export_arc_question_scores
group by
  organization_name,
  program_name,
  program_id,
  response_id,
  respondent_role,
  respondent_id,
  submitted_at,
  updated_at,
  dimension;

grant select on export_arc_question_scores to authenticated;
grant select on export_arc_dimension_notes to authenticated;
grant select on export_arc_dimension_scores to authenticated;

