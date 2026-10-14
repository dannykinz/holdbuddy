# Holdbuddy

**A little structure. A real finish line.**

Holdbuddy is a study accountability app that helps learners turn a learning goal into a plan they can actually keep. It brings together study sessions, chapter progress, tasks, private notes and accountability partners, with room to return after a missed session.

This monorepo contains the Flutter mobile app and the Astro landing page.

## Repository structure

```text
holdbuddy/
├── apps/
│   ├── landing/    Astro landing page
│   └── mobile/     Flutter Android app
└── README.md
```

## The mobile experience

- **Make a commitment:** define your learning scope, study rhythm, consequence and optional witness.
- **Know what comes next:** see upcoming sessions, chapter progress and tasks from Today.
- **Study with focus:** start a session, pause when needed and record what you completed.
- **Keep your learning together:** use chapter tasks, notes and recall screens.
- **Stay accountable:** explore witness invitations, partner updates and missed-session recovery.
- **Make it yours:** switch between light and dark themes and manage your preferences.

Progress is built around completed sessions and comebacks, without streak pressure.

## Demo status

The Android app is an interactive UI prototype powered by in-memory fake repositories. The dev build has been installed and verified on an Android emulator.

Account actions, partner delivery, notifications, material playback, purchases and other integrations currently use previews. Demo data is not persisted across app restarts.

Persistent local storage, backend authentication, sync and native integrations are planned. iOS development is deferred.

The Astro app contains the product landing page.

## Technology

| Area             | Stack                                                  |
| ---------------- | ------------------------------------------------------ |
| Mobile app       | Flutter and Dart                                       |
| State management | Riverpod                                               |
| Navigation       | go_router                                              |
| Design system    | Shared tokens, Inter typography, light and dark themes |
| Landing page     | Astro                                                  |
| Testing          | Flutter unit, widget and golden tests                  |

The mobile app uses feature-first architecture with separate UI, logic, domain and data layers. Repository interfaces allow the demo fakes to be replaced with real implementations.

## Run locally

### Landing page

Requires Node.js 22.12.0 or newer and npm.

```bash
cd apps/landing
npm ci
npm run dev
```

Build and preview the production site:

```bash
npm run build
npm run preview
```

The production output is generated in `apps/landing/dist`.

### Android app

Requires the Flutter SDK pinned in `apps/mobile/.fvmrc`, FVM, and an Android emulator or connected device.

Copy `env/example.json` to `env/dev.json` inside the mobile app before running. Local environment files are git-ignored.

```bash
cd apps/mobile
fvm flutter pub get
fvm flutter run --flavor dev --dart-define-from-file=env/dev.json
```

The app has `dev` and `prod` flavors. Always specify the flavor when launching or building.

In VS Code, open `apps/mobile` and select **Holdbuddy dev** from the Run and Debug configurations.

## Mobile checks

Run from `apps/mobile`:

```bash
fvm dart format .
fvm flutter analyze
fvm flutter test
```

## Next steps

- Complete Android journey checks in light, dark and larger text sizes.
- Add persistent local storage.
- Connect authentication, partner updates and background sync.
- Implement notifications, linked materials and focus integrations.
- Prepare production builds.

See [mobile project status](apps/mobile/docs/STATUS.md) for the detailed roadmap.

---

Created by **Danny Kinz**.
