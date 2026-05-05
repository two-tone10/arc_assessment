-- Run once if first login reports a profiles Row Level Security error.
-- This keeps profile creation scoped to the authenticated user's own auth id,
-- while allowing the bootstrap organization_id to be attached.

drop policy if exists "Users can insert their own profile" on profiles;

create policy "Users can insert their own profile"
on profiles for insert
to authenticated
with check (id = auth.uid());

