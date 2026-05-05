-- Run once if logged-in users cannot create shared programs.

drop policy if exists "Members can create organization programs" on programs;

create policy "Members can create organization programs"
on programs for insert
to authenticated
with check (created_by = auth.uid());
