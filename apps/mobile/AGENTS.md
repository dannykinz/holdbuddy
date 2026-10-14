# AGENTS.md: Holdbuddy

Offline-first study accountability app. Flutter (Android for now), Supabase, Figma MCP for UI.
iOS implementation and validation are deferred.
Project rules. Where they conflict with any global instructions, this file wins.

---

## 1. Start and end every session the same way

**Start:**

1. Read `docs/STATUS.md`. It says what is done, what is next, and where the last session stopped.
2. Read only the doc section the next task needs. Do not re-scan the codebase to find your place.

**End:**

1. Update `docs/STATUS.md`: tick what finished, set the next task, write a "Last session" note of 5 lines or fewer.
2. Report in 5 lines or fewer: files changed, analyze and test results, open questions.

If STATUS.md and the code disagree, trust the code, fix STATUS.md, and say so.

## 2. Where everything lives

| Need | Read |
| --- | --- |
| Where we are, what is next | `docs/STATUS.md` (always first) |
| What a feature must do | `docs/PRD.md`, only the relevant section |
| Data, auth, sync, backend, performance, scaling | `docs/ARCHITECTURE.md`, only the relevant section |
| Tokens, components, visual rules, Figma protocol | `docs/DESIGN.md` |
| Figma node ID for any screen | `docs/SCREENS.md` |

Sources of truth, in order: the user's message, this file, STATUS, PRD, ARCHITECTURE and DESIGN, existing code, Figma.
If a decision is in none of them, it is not decided. Ask one short question. Never fill the gap with a guess.

---

## 3. The smallest correct solution

The most important rule in this file.

Before writing code, find the simplest correct way, then write only that.

- If Flutter or an installed package already does it, use it. A themed `FilledButton` beats a button built from scratch.
- If it fits in 5 lines, do not write 20. No wrapper widgets that only pass props through.
- No abstraction for a single caller. Extract on the third repeat, not the first.
- No catch-all "manager", "helper" or "utils" classes.
- Composition over inheritance. Small widgets over long build methods.
- Delete before you add. If a change makes old code unnecessary, remove it in the same task.

About to write a large block? Stop and look for the shorter path first.

## 4. Clean code limits

- Files under 200 lines. Functions under 30. A widget's `build` under 60.
- One public class per file; file name is the class in snake_case.
- Two levels of nesting at most. Early returns.
- Names say what things are: `missedSessions`, `isFocusOn`, `recalculateFinishDate`.
- Comments explain why, never what.
- Sound null safety: no `dynamic`, no `!` unless the previous line proves non-null.
- `const` everywhere it compiles.
- Immutable models and state with `copyWith`.
- Every failure path is handled: the user sees a next step and the error is logged. Nothing is swallowed.
- Validate and sanitize input at the boundary where it enters.

## 5. Never do this

- Import a package not in `pubspec.yaml`. Ask first: name, reason, one alternative.
- Use an API, method or parameter you have not confirmed in the installed version. Check the package source or ask.
- Write fake logic that claims to work. Fakes live only in `lib/core/fakes/` and are labelled as fakes.
- Say done without `dart format .`, `flutter analyze` and the feature's tests passing.
- Edit outside the task's scope. No drive-by refactors, renames or reformatting.
- Invent env vars, keys, table names, routes or bundle IDs.
- Put a Supabase service role key or any secret in client code.
- Use `print`. Use the logger in `core/logging`.

## 6. Save tokens

- Search with `rg`; open only files you will touch.
- Read a file before editing it, then edit the smallest region.
- Output diffs or changed functions only. Never reprint unchanged code.
- No restating the request. Plan in 5 bullets or fewer, then work.
- Pull one Figma node per screen, never a whole page or section (`docs/DESIGN.md`, Figma protocol).
- One task per session. If it grows, finish a clean slice and log the rest in STATUS.

---

## 7. Architecture in brief

Full detail: `docs/ARCHITECTURE.md`.

Feature-first clean architecture. Dependencies point inward only: `ui → logic → domain ← data`.

```
lib/
  main.dart               bootstrap, flavors, global error handlers
  app/                    app widget, router, theme, tokens
  core/                   db, sync, auth, notifications, logging, errors, l10n, widgets, fakes
  features/<feature>/
    domain/               entities, repository interfaces, pure logic (no Flutter imports)
    data/                 drift tables and DAOs, supabase sources, repository implementations
    logic/                riverpod providers and notifiers
    ui/                   screens and widgets
supabase/                 migrations, functions, seed
web/site/                 Astro website and legal pages
web/witness/              Nuxt witness page
docs/
test/                     mirrors lib/
```

Features: onboarding, auth, contract, today, session, plan, tasks, notes, material, focus, deadlines, partners, safety, profile, settings, pro.

- UI never touches Drift or Supabase. UI watches providers; providers call repositories.
- Domain is pure Dart and unit tested: recalculation, reminder schedule, request expiry, missed detection.
- Drift on the device is the source of truth. Writes go to Drift plus the outbox; sync runs in the background.
- Every repository has an interface in `domain/`. Phase 1 binds fakes; later phases bind real implementations through provider overrides. The UI never changes.

## 8. Stack

Chosen. Change only with my approval. Pin exact versions; never guess one, check pub.dev.

| Need | Use |
| --- | --- |
| State | flutter_riverpod, riverpod_annotation, riverpod_generator |
| Models | freezed, json_serializable |
| Navigation | go_router |
| Local database | drift, sqlite3_flutter_libs |
| Backend and auth | supabase_flutter, google_sign_in, sign_in_with_apple (iOS) |
| Push and crashes | firebase_messaging, firebase_crashlytics |
| Local notifications | flutter_local_notifications |
| Audio | just_audio |
| Icons | flutter_svg |
| Ads, purchases | google_mobile_ads, in_app_purchase |
| Tests | flutter_test, mocktail |

Not chosen yet. Bring two options with trade-offs and wait:
PDF rendering, offline Word rendering (there may be no reliable pure-Flutter option; say so if true), persistent file access in place, Android Do Not Disturb control, secure session storage, transactional email.

---

## 9. Product rules that must never break

- No streak anywhere: no field, counter or UI. Comebacks are counted instead.
- Missed is hatched grey. Never red. Red only for destructive actions.
- Offline first: every feature works with no connection. Partner messages queue and send when online.
- Notes never leave the device, except in a backup file the user exports.
- Material is linked in place, never copied or uploaded.
- A witness sees only the plan name, whether a session happened, and the learner's own message.
- Declined and expired requests both read "This invite didn't go through."
- A blocked person is never told.
- No ads during a session, focus mode, onboarding or the contract.
- Every feature is free. Pro removes ads and adds the monthly report, icons and themes.
- Minimum age 18. No parent or child account types; a parent can be a witness like anyone else.
- Partner updates are instant for everyone.
- Every new plan goes through Scope, Rhythm, Consequence, Witness and Contract.

## 10. Design in brief

Full detail: `docs/DESIGN.md`.

- Every colour, space, radius and text style comes from `app/theme/tokens.dart`. Never a raw hex or magic number in a widget.
- Light is default; dark is the same widgets with the dark token set.
- Inter only. Hierarchy from size, weight and colour.
- Build the shared widgets in `core/widgets` first; screens only compose them.
- Match the Figma screen. If a state is missing in Figma, ask. Never invent a layout.
- All user-facing strings live in ARB files.
- Touch targets 48 or larger. Text scales to 1.3× without overflow. Every icon button has a semantics label.

---

## 11. Definition of done

- `dart format .` clean, `flutter analyze` zero issues, feature tests pass.
- Light and dark match Figma.
- Works offline, unless the feature only sends.
- Strings in l10n. No new package, secret or out-of-scope file.
- Section 9 still holds.
- `docs/STATUS.md` updated.
