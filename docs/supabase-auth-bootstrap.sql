-- Run this if you already created the tables/policies before the app auth wiring.
-- It allows a newly authenticated user to create/read the first organization record
-- before their profile exists.

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

drop policy if exists "Users can insert their own profile" on profiles;

create policy "Users can insert their own profile"
on profiles for insert
to authenticated
with check (id = auth.uid());
