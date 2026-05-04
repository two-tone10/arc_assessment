# Deployment Plan

## What Can Be Free

- Vercel can host the current prototype on a free Hobby account.
- Supabase can support an early pilot on its free plan.
- GitHub can host the source repository for free.

## What May Cost Money Later

- A custom domain name.
- Higher Supabase usage, backups, or production-grade reliability.
- OpenAI API usage for generated qualitative and quantitative insights.
- Email delivery if the app sends invitations, reminders, or reports.

## Suggested First Deployment

Start with a Vercel deployment of the current prototype. This gives you a shareable URL for feedback while we build the real backend.

Then add Supabase in this order:

1. Create Supabase project.
2. Run `docs/supabase-schema.sql`.
3. Enable Row Level Security policies.
4. Add login and organization membership.
5. Replace `localStorage` reads/writes with Supabase queries.
6. Add server-side AI insight generation.

## Production Data Principle

The browser should never be the source of truth for team data. The browser can cache data, but the authoritative record should live in Supabase/Postgres.

