# Architecture

Read only the section your task needs. Items marked **Proposed** are not decided; confirm before building them.

---

## 1. System overview

```
 Phone (Flutter)                          Supabase                         Web
 ┌───────────────────────────┐           ┌─────────────────────────┐      ┌──────────────────┐
 │ UI → providers → repos    │           │ Auth (Google, Apple,    │      │ Astro site       │
 │ Drift (source of truth)   │──sync────▶│  email OTP)             │      │  legal, delete   │
 │ Outbox queue              │◀─pull─────│ Postgres + RLS          │◀─────│ Nuxt witness page│
 │ Local notifications       │           │ Edge Functions          │      │  (token links)   │
 │ Linked files (PDF, audio) │           │ pg_cron jobs            │      └──────────────────┘
 └───────────────────────────┘           └───────────┬─────────────┘
          ▲                                          │
          │ push (FCM, APNs via FCM)                 │ email (link-only witnesses)
          └──────────────────────────────────────────┘
```

The phone does nearly all the work. The server stores account and partnership data, relays messages between people, and runs a few scheduled jobs. That keeps server cost and load tiny at any scale.

## 2. Layers and flow

`ui → logic → domain ← data`

| Layer | Holds | May import |
| --- | --- | --- |
| domain | Entities, repository interfaces, pure functions | Dart only |
| data | Drift tables and DAOs, Supabase sources, repository implementations | domain, drift, supabase |
| logic | Riverpod providers and notifiers | domain |
| ui | Screens and widgets | logic, core widgets, theme |

- No use-case classes that only forward a call. A use case exists only when it combines repositories or holds real logic.
- Pure logic lives in `domain/` as top-level functions or small classes, fully unit tested:
  - `recalculateFinishDate(plan, contract, sessions, today)`
  - `reminderStops(dueAt, now)` (weekly over 21 days, daily otherwise, plus the day itself)
  - `isRequestExpired(invitedAt, now)` (10 days)
  - `missedSessions(contract, sessions, now)`
- Providers expose `AsyncValue` state. Screens handle loading, data and error once, through a shared `AsyncView` widget.

## 3. Offline-first data and sync

Drift is the source of truth. The app never waits on the network to show or save anything.

**Writes:**

1. Write to the Drift table.
2. In the same transaction, append a row to `outbox` with `{id, table, row_id, op, payload, created_at, attempts}`.
3. The sync worker drains the outbox when online.

**Sync worker:**

- Runs on app start, on connectivity regained, after any write (debounced 2 s), and on a periodic background task where the OS allows.
- Push: send outbox rows in creation order, in batches of 50. Each row carries a client-generated UUID, so retries are idempotent (upsert on `id`).
- Pull: per table, fetch rows where `updated_at > last_cursor`, in pages of 200, and store the new cursor.
- Conflicts: last write wins on `updated_at` set by the server. Session outcomes are append-only and never conflict.
- Deletes are soft: `deleted_at`. A nightly server job hard-deletes rows soft-deleted more than 30 days ago.
- Failure: exponential backoff (2 s doubling to 5 min), max 8 attempts, then mark the row failed and surface a quiet "Some changes haven't synced" notice.

**IDs:** UUID v4 generated on the device for every row, so rows exist before the server knows about them.

**Never synced:** `note`, `material`. They exist only in Drift.

## 4. Data model

Postgres mirrors the Drift tables for everything except notes and material. Every server table has `id uuid pk`, `created_at`, `updated_at` (trigger-set), `deleted_at`.

| Table | Key fields |
| --- | --- |
| profile | user_id (auth.users), display_name, avatar_url, studying, locale, quiet_hours, tier |
| plan | user_id, title, total_units, unit_name, units_done, start_date, target_date, status |
| contract | plan_id, days int[], time, duration_min, units_per_session, consequence_message, committed_at |
| session | plan_id, chapter, scheduled_at, started_at, ended_at, mode, focus_on, outcome |
| task | plan_id, chapter, label, is_default, done_at |
| partnership | learner_id, witness_user_id null, witness_name, witness_email, witness_phone, status, invited_at, reminded_at, expires_at, mutual_with |
| plan_witness | plan_id, partnership_id |
| witness_link | partnership_id, token_hash, revoked_at |
| message | partnership_id, type, body, channel, delivery, sent_at |
| reminder | user_id, title, category, due_at, cadence, stops jsonb, status, done_at |
| entitlement | user_id, product, store, status, expires_at |
| block | blocker_id, blocked_id |
| report | reporter_id, reported_id, reason, message_id, details, status |
| deletion_request | email, reason, status (from the website form) |
| device | user_id, fcm_token, platform, last_seen_at |

Local only (Drift): `note`, `material`, `outbox`, `sync_cursor`, `app_settings`.

No streak column, anywhere, ever.

## 5. Authentication

One account type for everyone. No parent, child, admin or witness account types.

| Who | How they authenticate |
| --- | --- |
| Learner (and app witness) | Supabase Auth: Google first, email and password with a 6-digit OTP, Sign in with Apple on iOS |
| Offline user | No account. Local profile in Drift; on first sign-in, local rows are adopted by the new user ID |
| Link-only witness | No account. A random 32-byte token in the invite link; only its SHA-256 hash is stored in `witness_link` |
| Website deletion form | No account. Writes a `deletion_request` row through an Edge Function with rate limiting |
| Me (admin) | Supabase dashboard only. No admin role in the app |

**Rules:**

- Google uses native sign-in and `signInWithIdToken`. Never a web redirect inside the app.
- **iOS needs Sign in with Apple** next to Google; App Store review expects it when another social login is offered. The Figma has no Apple button yet. Flag this before building iOS auth.
- Sessions refresh automatically through supabase_flutter. Store the session securely (package not chosen yet).
- Sign-out clears the session, the FCM token row, and in-memory caches. It does not delete local notes or material.
- Account deletion runs the `delete_account` Edge Function: deletes the auth user, cascades all server rows, then the app clears Drift.

**Witness link flow:**

1. Learner creates a partnership; the app generates the token, stores the hash via RPC, and shares `https://<domain>/w/<token>` through the share sheet.
2. The Nuxt page calls the `witness_view` Edge Function with the token. It returns only the plan name, recent session outcomes and the learner's messages.
3. Nudge and stop actions go through Edge Functions with the same token. Revoking sets `revoked_at`.
4. The token never appears in logs.

## 6. Authorization (RLS)

RLS on every table, deny by default.

- A user reads and writes only rows where `user_id = auth.uid()`, or rows reachable through their own plans.
- Partnerships: readable by the learner and by `witness_user_id`. Writable by the learner; the witness can only change `status` to `active`, `declined` or `stopped`.
- A witness reads another user's plan only through the `partner_plan_view` RPC, which returns the allowed fields and checks there is no block.
- `block` rows are enforced in every partner RPC and in message sending, not only hidden in the UI.
- `report` is insert-only for users. `entitlement` is written only by the purchase-verification function.
- Security-definer functions stay small, set `search_path`, and validate every argument.
- Index every column RLS filters on (`user_id`, `plan_id`, `learner_id`, `witness_user_id`).

## 7. Server functions and jobs

| Name | Trigger | Does |
| --- | --- | --- |
| send_message | Outbox push of a `message` row | Fan out to each witness: push if they have the app, email if link-only. Skips blocked pairs |
| witness_view | Nuxt page | Token in, allowed plan data out |
| witness_action | Nuxt page | Nudge or stop, by token |
| verify_purchase | App after purchase | Verify with Google Play or the App Store, write `entitlement` |
| delete_account | App | Delete everything for the caller |
| deletion_request | Website form | Store request, rate limited |
| expire_requests | pg_cron daily | Pending partnerships past `expires_at` become `expired` |
| purge_deleted | pg_cron nightly | Hard-delete soft-deleted rows older than 30 days |

Every function: validate input, check auth or token, be idempotent, return typed errors, never log secrets or message bodies.

## 8. Notifications

| Kind | Scheduled by | Works offline |
| --- | --- | --- |
| Session due (15 min before) | Device | Yes |
| Session missed (1 h after end, cancelled if started) | Device, scheduled in advance | Yes |
| Return after 3 silent days (once) | Device | Yes |
| Deadline stops | Device | Yes |
| Plan complete | Device | Yes |
| Partner request, nudge, partner let a session go | Server push | Needs network |

- After any change to a contract, plan or reminder, cancel and reschedule only that entity's notifications. Use stable notification IDs derived from the entity ID.
- Respect quiet hours.
- Android 12+ exact alarms need permission; ask before choosing exact versus inexact scheduling.
- Tapping a notification deep-links through go_router to the screen in the PRD notification table.

**Open product question:** if a learner never resolves a missed session, the consequence never fires. Confirm whether it should auto-fire after a grace period before building it.

## 9. Material and files

- Material is linked, never copied. Store the platform file reference, display name, last seen path and reading position.
- On open, if the reference fails, show Material unavailable with Find it again; relinking keeps the position.
- Render PDFs page by page, lazily. Never load a whole file into memory.
- Audio streams from the file with just_audio; save the position every 5 s and on pause.

## 10. Backup and restore

- Export: one file containing Drift data (notes included) as JSON, compressed, written in an isolate, handed to the system share sheet.
- Restore: pick the file, validate the schema version, preview what will be replaced, then import in one transaction.
- Material references are included but may need relinking on a new phone.

## 11. Performance

Targets on a 2 GB RAM Android phone:

| Metric | Target |
| --- | --- |
| Cold start to first frame | Under 2 s |
| Scrolling | 60 fps, no jank on Today, Plan and Notes |
| Release APK per ABI | Under 25 MB |
| Memory in the PDF reader | Under 200 MB |

How:

- Show the first screen from Drift immediately. Initialize Firebase, ads, purchases and sync after the first frame.
- `const` widgets, small widgets, and `ref.watch(provider.select(...))` so only what changed rebuilds.
- `ListView.builder` or slivers for every list. Never a `Column` of unknown length.
- Drift queries indexed, paged, and run as streams so the UI updates without refetching.
- Heavy work in isolates: backup export, restore, large JSON parsing.
- Avatars cached and resized to their display size.
- Glass blur only on the nav bar; never stack blurs.
- Profile with DevTools before and after any performance task, and record the numbers in STATUS.

## 12. Scaling

The design scales by doing almost nothing on the server.

- Reads are local, so server load grows with writes and messages only.
- Pulls are cursor-based and paged; no full-table syncs.
- Push fan-out is batched; failed tokens are pruned from `device`.
- Rate limits (**Proposed**, confirm numbers): nudges per partnership per day, invites per user per day, deletion and report requests per IP.
- No Realtime subscriptions; partner updates arrive by push. This keeps connection counts flat.
- Postgres indexes on every foreign key and on `(user_id, updated_at)`.
- Start on the Supabase free tier; move up when usage requires it.

## 13. Security

- No secrets in the app. Only the Supabase anon key and URL, passed through `--dart-define-from-file`.
- Service role key exists only in Edge Function environment variables.
- Message length capped (**Proposed** 280 characters) and escaped on the web.
- Tokens and message bodies never reach logs or Crashlytics.
- Dependency review before adding any package.

## 14. Observability

- Crashlytics for crashes and non-fatal errors. Catch `FlutterError.onError` and `PlatformDispatcher.instance.onError`.
- A single logger with levels; debug logs stripped from release.
- Upload debug symbols for every release build.
- The product metric is return-after-absence, computed from `session` rows. No analytics SDK is chosen yet.

## 15. Environments and release

- Flavors: `dev` and `prod`, each with its own Supabase project, Firebase app and bundle ID.
- Config through `--dart-define-from-file=env/dev.json`; env files are git-ignored, with `env/example.json` committed.
- CI: format check, analyze, tests on every push.
- Google Play staged rollout; watch crash-free users before widening.

## 16. Testing

| Level | What |
| --- | --- |
| Unit | Every domain function, sync worker edge cases, repository mapping |
| Widget | Each shared widget in light and dark; key screens with fake repositories |
| Golden | Shared widgets and the five core screens, light and dark |
| Integration | First run through to Today; start and end a session offline |

Tests use fakes from `core/fakes` and `mocktail`. No test touches the network.
