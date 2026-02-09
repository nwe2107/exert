# Account + Personalization Issue Pack

This document contains copy-paste-ready issue drafts for the account and personalization work.

## Recommended build order
1. [Feature] Login workflow (auth state + route protection)
2. [Feature] Today tab account entry + account screen navigation
3. [Feature] Settings screen + delete account confirmation flow
4. [Feature] Personal information workflow (weight, height, age, gender)

Reasoning: auth state should exist before account/settings routes are finalized, and profile data flow should be built after account surfaces exist.

---

## Issue 1: [Feature] Login workflow (auth state + route protection)

## Problem
The app currently opens directly into the main shell (`/today`) and has no login flow, authenticated session state, or protected route handling.

## Proposed solution
Add an auth workflow that can gate entry into the app shell:
- Introduce auth domain contracts (for example `AuthRepository`, session model, and auth state stream).
- Add auth presentation flow (`LoginScreen`) with core credential sign-in path.
- Add auth state provider in Riverpod and surface `loading/authenticated/unauthenticated` states.
- Add `GoRouter` redirect/guard rules:
  - Unauthenticated user trying to access app shell routes -> redirect to `/login`.
  - Authenticated user visiting `/login` -> redirect to `/today`.
- Add logout API hook for future Settings integration.
- Keep implementation provider-agnostic so backend auth can be swapped without rewriting UI flow.

## Acceptance criteria
- [ ] App launches to login when there is no authenticated session.
- [ ] Successful login routes user to `/today` shell.
- [ ] App shell routes are blocked/redirected when signed out.
- [ ] Auth loading and failure states are visible in UI.
- [ ] Basic widget or integration tests cover redirect behavior and login success/failure path.

## Out of scope
- Social login providers.
- Password reset and email verification.
- Multi-factor authentication.

## Additional context
Current router is defined in `lib/app/app_router.dart` and main shell uses `StatefulShellRoute.indexedStack`.

---

## Issue 2: [Feature] Today tab account entry + account screen navigation

## Problem
There is no account entry point in the Today tab and no account hub screen for profile/account actions.

## Proposed solution
Create a top-left circular account button in Today and wire navigation to a dedicated account screen:
- Add a circular profile/account `IconButton` at the top-left of Today app bar.
- On tap, push to `/account`.
- Build `AccountScreen` with:
  - Header/profile summary section.
  - Primary button to open Settings (`/account/settings`).
  - Top-left back/return action that takes user back to Today.
- Ensure route placement works with existing shell router behavior so back navigation is predictable.

## Acceptance criteria
- [ ] Today app bar displays a circular profile/account button in the top-left position.
- [ ] Tapping the button navigates to an account screen.
- [ ] Account screen contains a button that navigates to Settings.
- [ ] Top-left return action from account screen returns user to Today tab.
- [ ] Navigation is covered by at least one widget/navigation test.

## Out of scope
- Editing profile fields directly in this issue.
- Delete account flow (handled in separate Settings issue).

## Additional context
`TodayScreen` currently has a simple `AppBar(title: Text('Today'))` in `lib/features/today/presentation/today_screen.dart`.

---

## Issue 3: [Feature] Settings screen + delete account confirmation flow

## Problem
There is no settings page and no safe destructive flow for deleting an account.

## Proposed solution
Implement a settings screen reachable from account and a guarded delete-account action:
- Add `SettingsScreen` route under account flow (`/account/settings`).
- Include standard settings sections (account/app placeholders are fine initially).
- Place `Delete account` button at the bottom of the settings view.
- Tapping delete opens a destructive warning alert that clearly states the action is permanent.
- Require explicit confirmation before execution.
- On confirm:
  - Delete account via auth repository.
  - Clear user-scoped local data (at minimum profile/account records; expand as needed).
  - Route user to login/unauthenticated state.
- On failure, show clear error and keep account intact.

## Acceptance criteria
- [ ] Settings is reachable from Account screen.
- [ ] Delete account button appears at the bottom of Settings.
- [ ] A warning dialog explicitly states account deletion is permanent.
- [ ] Cancel path exits safely with no data loss.
- [ ] Confirm path deletes account and returns user to unauthenticated/login flow.
- [ ] Error path preserves account/data and surfaces feedback.

## Out of scope
- Data export/download before deletion.
- Delayed deletion grace period.

## Additional context
This issue depends on login/auth state being available so post-deletion routing and session invalidation are deterministic.

---

## Issue 4: [Feature] Personal information workflow (weight, height, age, gender)

## Problem
There is no workflow for collecting or persisting personal information needed for account personalization.

## Proposed solution
Add a user profile data model and input workflow for personal metrics:
- Add a profile model/repository (for example Isar-backed `UserProfileModel`) with fields:
  - Weight
  - Height
  - Age
  - Gender
  - Optional unit preferences (kg/lb, cm/in)
- Build personal info form screen with validation and save state.
- Entry points:
  - First-login onboarding prompt when profile is missing.
  - Edit path from Account screen.
- Persist profile data and show a brief success state after save.
- Display profile completion status in account view (simple complete/incomplete is sufficient for first pass).

## Acceptance criteria
- [ ] User can input and save weight, height, age, and gender.
- [ ] Validation prevents invalid values (empty required fields, out-of-range numeric values).
- [ ] Saved values persist across app restarts.
- [ ] Missing-profile users are prompted into the workflow at first login (or clearly prompted from account entry).
- [ ] Existing users can reopen and edit their personal information.

## Out of scope
- Advanced health calculations (BMI, calorie estimates).
- Nutrition targets or training recommendations.
- Syncing profile to remote backend.

## Additional context
Current data layer is Isar-first and already used by workout/template repositories, which makes profile persistence a natural extension.
