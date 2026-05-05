-- Run once to support the current first-user bootstrap flow.
-- The app creates an organization, reads the inserted organization id/name,
-- then creates the first profile attached to that organization.

drop policy if exists "Authenticated users can create organizations" on organizations;
drop policy if exists "Authenticated users can read organizations during bootstrap" on organizations;

create policy "Authenticated users can create organizations"
on organizations for insert
to authenticated
with check (true);

create policy "Authenticated users can read organizations during bootstrap"
on organizations for select
to authenticated
using (true);

