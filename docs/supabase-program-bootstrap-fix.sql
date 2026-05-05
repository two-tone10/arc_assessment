-- Run once if shared program creation reports:
-- "new row violates row-level security policy for table programs".
--
-- This keeps creation tied to the logged-in user as created_by, while allowing
-- the app to attach the selected organization_id during the early pilot flow.

drop policy if exists "Members can create organization programs" on programs;

create policy "Members can create organization programs"
on programs for insert
to authenticated
with check (created_by = auth.uid());

