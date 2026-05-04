# Backend Build Tasks

## Step 1: Shared Data

- Create a Supabase project.
- Run `docs/supabase-schema.sql` in Supabase SQL Editor.
- Add Row Level Security policies so users only see their organization's data.
- Create seed organization and first admin profile.

## Step 2: Authentication

- Add login and signup screens.
- Support organization invite links.
- Store each user's default role.
- Allow role override per assessment response if needed.

## Step 3: Replace Local Storage

- Replace `localStorage` program creation with Supabase `programs` inserts.
- Replace saved response storage with `arc_responses`, `arc_question_scores`, and `arc_dimension_notes`.
- Replace dashboard calculations with Supabase queries or database views.
- Keep local demo data as a separate non-production demo mode.

## Step 4: Team Dashboard

- Add filters for organization, program, assessment cycle, and role.
- Add role comparison charts.
- Add CSV export for raw scores and qualitative notes.
- Add printable/PDF team review view.

## Step 5: AI Insights

- Add a server-side API route for insight generation.
- Send only the selected program's aggregate scores and qualitative notes.
- Store generated insight snapshots for review meetings.
- Let administrators regenerate insights after new responses are submitted.

## Step 6: Pilot Hardening

- Add consent/privacy text.
- Add basic audit fields for created/updated records.
- Add backups/export workflow.
- Test on mobile devices used by practitioners.

