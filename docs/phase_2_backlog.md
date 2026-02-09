# Phase 2 Backlog

This backlog is for post-MVP stabilization and planned enhancements.

## P0 - Stabilize Core UX
- Fix body heatmap tap precision edge cases (front + back SVG paths).
- Normalize front/back SVG coordinate systems and document export constraints.
- Add regression tests for `HeatmapService` muscle mapping and recency bands.
- Add empty-state UX polish for Calendar/Today/Progress.

## P1 - Data and Reliability
- Add soft-delete and migration test coverage for Isar models.
- Add repository-level unit tests (exercise templates, workout sessions).
- Add backup/export path for local data (JSON export).

## P1 - Firestore Sync (interfaces-first)
- Keep Isar as source of truth.
- Implement sync queue model (`pending_create`, `pending_update`, `pending_delete`).
- Add `SyncRepository` implementation scaffold with no-op sync worker.
- Define conflict strategy doc (last-write-wins + manual conflict review fallback).

## P2 - Product Improvements
- Add filters in Heatmap grid (group, stale-first sorting).
- Add richer Progress cards (7/30 day trend deltas).
- Add quick templates for Minimum Workout presets.

## Suggested Initial GitHub Issues
1. `Heatmap hit-test precision and visual alignment`
2. `Isar repository unit test suite`
3. `Sync queue data model scaffold`
4. `Conflict resolution strategy doc`
5. `Calendar and Today empty-state polish`
