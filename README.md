# Zaczątek App

Operational app for a multi-location restaurant: inventory, deliveries, staff hours, announcements, scheduling and basic analytics.

## Product deck (Canva)
👉 **Presentation:** https://www.canva.com/design/DAGrNM-oDWc/Vyq9kqkbf2IS19WpAtAOHA/view?utm_content=DAGrNM-oDWc&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=had3404fca5

## Key features
- **Multi-location support** (separate state per location)
- **Inventory**
  - categories, quick overview
  - critical stock highlighting
  - admin: add/edit/delete products
- **Deliveries**
  - categorized forms
  - history per location
- **Staff hours**
  - per-day entries (location + start/end time)
  - admin overview and summaries
- **Announcements**
  - internal posts, read status (and reactions/comments as the module evolves)

## Tech stack
- Flutter / Dart
- Local storage (offline-first patterns)
- Cloud sync (selected modules / in progress): **Supabase**
- Backend: Supabase (auth + database) 

## Roadmap
- Full sync + conflict strategy
- Push notifications
- Role-based permissions polish


