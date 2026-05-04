# Supabase and Vercel Setup

## 1. Create Supabase Project

1. Go to Supabase.
2. Create a new project.
3. Save the project URL and anon public key.

## 2. Create Database Tables

In Supabase SQL Editor, run these files in order:

1. `docs/supabase-schema.sql`
2. `docs/supabase-rls-policies.sql`

## 3. Add Vercel Environment Variables

In Vercel, open the ARC Assessment project:

1. Go to **Settings**.
2. Go to **Environment Variables**.
3. Add:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`

Redeploy after adding the variables.

The app's `/api/config` route should then report:

```json
{
  "storageMode": "supabase-ready"
}
```

## 4. First Production Milestone

The first shared-data milestone is not full AI. It is:

- Users can authenticate.
- Users belong to one organization.
- Programs are shared within that organization.
- Responses are stored in Supabase.
- Dashboards aggregate Supabase responses.

## 5. Privacy Note

Before real pilots, add a short consent/privacy statement explaining:

- What data practitioners enter.
- Who can see aggregated results.
- Whether qualitative notes are identifiable.
- How AI-generated summaries will be used.

