# ARC Purpose Development Assessment

Mobile-friendly web prototype for practitioners evaluating youth programs through the ARC model:

- Agency
- Role Clarity
- Challenge

The current version runs as a deployable static/Vercel app and stores data in browser local storage. The next production step is to connect Supabase Auth and Postgres using the schema in `docs/supabase-schema.sql`.

## Local Preview

```bash
npm run start
```

Then open:

```text
http://127.0.0.1:4173/index.html
```

## Deploy to Vercel

1. Create a GitHub repository for this folder.
2. Push the project to GitHub.
3. In Vercel, choose **Add New Project**.
4. Import the GitHub repository.
5. Deploy with the default settings.

The current app can deploy without environment variables. When Supabase is added, set these Vercel environment variables:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `OPENAI_API_KEY` only when AI generation is ready

See `docs/supabase-vercel-setup.md` for the backend setup sequence.

If the database was created before the first auth wiring pass, run `docs/supabase-auth-bootstrap.sql` once in Supabase SQL Editor.

If the database was created before response-update policies were added, run `docs/supabase-delete-policies.sql` once in Supabase SQL Editor.

If first login reports an organization Row Level Security error, run `docs/supabase-bootstrap-fix.sql` once in Supabase SQL Editor.

If first login then reports a profile Row Level Security error, run `docs/supabase-profile-bootstrap-fix.sql` once in Supabase SQL Editor.

## Current Storage Mode

Right now, programs and responses are stored in browser `localStorage`. That means the prototype is useful for design review and local demos, but it is not yet a shared team repository.

For a real pilot, connect Supabase so data is shared by organization, program, role, and assessment cycle.
