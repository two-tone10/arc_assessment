# ARC Assessment MVP Roadmap

## Goal

Turn the current single-file prototype into a deployable assessment app where practitioners can:

- Join an organization or network.
- Create and select shared programs.
- Submit one ARC assessment per program, role, and assessment cycle.
- View aggregate charts by program, role, question, and ARC dimension.
- Generate brief quantitative, qualitative, and next-step insights for team review.

## Recommended Stack

- Frontend: Next.js or React with a mobile-first responsive interface.
- Hosting: Vercel.
- Database and auth: Supabase Postgres plus Supabase Auth.
- Charts: Chart.js or Recharts.
- AI summaries: server-side OpenAI API call, optional for early pilots.

## MVP Phases

### Phase 1: Real Data Foundation

- Replace browser localStorage with Supabase.
- Add sign up, login, and organization membership.
- Store users, roles, organizations, programs, assessments, scores, and notes.
- Keep the current UI mostly intact while swapping the data layer.

### Phase 2: Team Dashboards

- Add program-level aggregate charts.
- Add results by role when 2 or more roles have responded.
- Add response counts and score distributions.
- Add CSV export for research or workshop facilitation.

### Phase 3: AI Insight Layer

- Generate short quantitative summaries from ARC score patterns.
- Synthesize qualitative notes into 3-5 themes.
- Suggest ARC optimization next steps.
- Keep all AI outputs reviewable, editable, and clearly labeled.

### Phase 4: Pilot Readiness

- Add organization invite links.
- Add assessment cycles, such as pre-workshop, post-workshop, mid-year review, or program revision cycle.
- Add privacy language and consent text.
- Add PDF export for team meetings.

## Cost Strategy

Start on free tiers for design, pilot testing, and low-volume use. Move to paid hosting/backend only when the app needs reliability, no project pausing, production backups, custom domains, or higher usage limits.

