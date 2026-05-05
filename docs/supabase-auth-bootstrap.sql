-- Run this if you already created the tables/policies before the app auth wiring.
-- It allows a newly authenticated user to create the first organization record
-- before their profile exists.

create policy "Authenticated users can create organizations"
on organizations for insert
with check (auth.uid() is not null);

