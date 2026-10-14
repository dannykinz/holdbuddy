# Status

Read first. Update last. Keep this file under 120 lines: when "Log" grows past 10 entries, collapse the oldest into one line.

## Now

- **Phase:** U12, UI review
- **Platform:** Android only; iOS deferred
- **Next task:** U12: Android journey and light/dark phone checks (deferred); D1 follows validation
- **Blocked on:** nothing

## Last session

- 2026-10-14: Replaced the mobile Git pointer with directly tracked source files in the holdbuddy monorepo.
- Preserved the nested repository's Git metadata in a local backup outside the workspace.
- Included dev/prod VS Code launch profiles; excluded Flutter state, Windows caches, builds and local environment files.
- Format check: 470 files, zero changes; flutter analyze: zero issues; both bootstrap/startup widget tests passed.
- U12 Android journeys, dark/1.3× and real-phone checks remain next; D1 follows that validation.

---

## Phase plan

UI first, with fake data, so every screen can be tested on a phone before any backend exists. Repositories are interfaces; fakes in `lib/core/fakes` power the UI until the real data phases replace them.

### UI phases (fake data, no backend)

- [x] **U0 Setup**
  - [x] U0.1 Scaffold Flutter project, flavors (dev, prod), folder structure, lints, packages from AGENTS.md section 8
  - [x] U0.2 `tokens.dart` and `ThemeData` for light and dark from `docs/DESIGN.md`
  - [x] U0.3 Router shell: go_router with every route stubbed, tab shell with `HbNavBar`
  - [x] U0.4 Fake repositories and seed data (one learner, Learning Dart plan, Elvis and Amaka as partners, 3 deadlines)
- [x] **U1 Shared widgets** (DESIGN.md section 3), each with a widget test in light and dark
- [x] **U2 First run:** Splash, onboarding ×3, Get started
- [x] **U3 Account:** sign up, sign in, verify, forgot, reset, and section 07 states
- [x] **U4 Contract:** Scope (with material card), Rhythm, Consequence, Witness, Contract with hold to commit (UI implemented; verification deferred)
- [x] **U5 Daily loop:** Today and its states, Session, Session saved, Missed, Welcome back (UI implemented; verification deferred)
- [x] **U6 Around the session:** Plan path, Chapter, tasks, Notes, note detail and recall, Alerts, Progress, Create sheet, Plan switch (UI implemented; verification deferred)
- [x] **U7 Settings and plan changes:** Settings, Appearance, section 08 and the U9 screens (UI implemented; verification deferred)
  - [x] Settings hub, Appearance, reminder states, privacy/legal and backup/removal previews (UI only; verification deferred)
  - [x] Witness management, renegotiate/adjust, recommit, archive and updated Plan states (UI only; verification deferred)
- [x] **U8 People:** Profile, Partners, their plan, hold each other, safety flow, account delete (UI implemented; verification deferred)
- [x] **U9 Deadlines:** list, new, swipe, done, detail (UI implemented; verification deferred)
- [x] **U10 Material and focus:** add, library, PDF reader shell, audio player shell, choose mode, focus permission, focus session (UI implemented; verification deferred)
- [x] **U11 Pro:** paywall, welcome, Today with ad placeholder (UI implemented; verification deferred)
- [ ] **U12 UI pass:** walk every journey in the flow map on a real phone, light and dark, fix gaps
  - [x] Source slice: selected plan/chapter, task/note isolation and unfinished-session guard
  - [x] Receipt/Today aggregate context review
  - [x] Analyzer diagnostic cleanup and existing-suite verification with targeted failure reruns
  - [x] Android dev APK build and emulator startup smoke check
  - [ ] Android phone checklist in docs/UI_REVIEW.md, including light/dark and 1.3× text

### Data and backend phases

- [ ] **D1 Local data:** Drift tables, DAOs, real repositories replacing fakes, domain logic with tests
- [ ] **D2 Notifications:** local scheduling for sessions, missed, return, deadlines
- [ ] **D3 Supabase:** schema, RLS, auth (Google, email OTP), offline user adoption
- [ ] **D4 Sync:** outbox, push, pull, conflict rules, backoff
- [ ] **D5 Partners:** partnerships, witness links, Edge Functions, push
- [ ] **D6 Material and focus:** file linking, PDF, audio, Do Not Disturb
- [ ] **D7 Safety and account:** block, report, delete account, deletion requests
- [ ] **D8 Backup and restore**
- [ ] **D9 Pro:** purchases, verification, AdMob
- [ ] **D10 Release:** performance targets, Crashlytics, flavors, store builds

---

## Decisions log

Newest first, one line each.

- 2026-10-13: Finish an unfinished session before starting a different plan; keep its timer and notes.

- 2026-10-12: Danny approved building all remaining Android UI now; tests, Gradle builds and runtime review are deferred.
- 2026-10-12: Add 18+ confirmation before account creation/Google/offline entry; resend reset links stays on confirmation.

- 2026-10-12: No .gitkeep placeholders; add actual files as each task needs them.
- 2026-10-12: Android only for now; defer all iOS work, Apple sign-in and iOS-specific checks.
- 2026-10-12: Mobile only; website and browser witness implementation excluded from this work.
- 2026-10-12: Approved screen-name route paths with Splash at `/`; state screens stay inside their bases.
- 2026-10-12: Missing pages may use matching app styling; broken links offer a return to Today.
- 2026-10-12: Active Figma Theme colours match DESIGN.md; published Inter styles and glassActive supersede the old text table.
- 2026-10-12: Bundle IDs: `com.holdbuddy.app` (prod), `com.holdbuddy.app.dev` (dev), approved by Danny.
- 2026-10-12: UI uses fakes before backend work; native flavors select environments, with empty JSON config until needed.

## Open questions

- Should an unresolved missed session auto-fire the consequence after a grace period?
- Rate limits for nudges and invites (ARCHITECTURE.md section 12).
- Packages still to choose: PDF, offline Word, file linking, Do Not Disturb, secure session storage, email.

## Deferred work

- Additional U4–U11 feature coverage, real-phone light/dark review and prod/release builds remain deferred; dev debug build and emulator startup were verified on 2026-10-14.
- U7/U8 delivery, safety actions and account deletion are in-memory previews; real integration remains in D5/D7. Finish-date recalculation remains in D1.
- U7 notifications, backup/restore and device data deletion are labelled previews; platform and storage integration remains in D1/D2/D8.
- U9 edits and status changes remain in memory; notification scheduling and persistence remain in D1/D2.
- U10 material, reader/player controls and focus are in-memory previews; real file linking/rendering, playback, position persistence and Do Not Disturb remain in D1/D6.

- U11 purchases, restore and ad removal are in-memory previews; real store billing, entitlement verification, reports and AdMob remain in D9.

- iOS implementation, Apple sign-in UI, signing and device validation will resume when Danny brings iOS into scope.
