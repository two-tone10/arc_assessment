# Data Export Notes

The core Supabase tables are normalized. That means score rows store `response_id` and response rows store `program_id`, rather than repeating the program name in every score row.

For analysis and downloads, use the export views:

- `export_arc_question_scores`: one row per scored item, including organization name, program name, role, question text, and score.
- `export_arc_dimension_scores`: one row per respondent and ARC dimension, including organization name, program name, role, and averaged dimension score.
- `export_arc_dimension_notes`: one row per qualitative note, including organization name, program name, role, dimension, and note.

In Supabase Table Editor, change from **Tables** to **Views**, open one of these export views, and export CSV from there.

