# Holdbuddy

Offline-first study accountability app. Current development targets Android only;
iOS implementation and validation are deferred.
Light/dark tokens and the mobile router shell are implemented. Screen bodies
remain stubs until their UI phases; normal launch begins at Splash.

Bootstrap binds read-only fake repositories through Riverpod overrides for the
UI phase. Fixtures in lib/core/fakes include Danny, a committed Learning Dart
plan, Elvis and Amaka, and three deadlines. These demo records are in memory;
their dates share the launch day's local date, injectable in tests.

## Toolchain

Flutter 3.47.7 stable, with its bundled Dart 3.13.5.
Direct pub.dev dependencies are pinned in pubspec.yaml; resolution is in pubspec.lock.
Flutter, flutter_localizations, and flutter_test come from the pinned SDK.

## Run

Local configuration stays in git-ignored env/dev.json and env/prod.json.
For a fresh checkout, copy env/example.json to each file. These JSON objects
are empty until a later task introduces configuration. Native --flavor selects
dev or prod; Flutter supplies its flavor define and rejects setting that
reserved key manually. No backend config is needed yet.
Dart defines are compiled into the app and must never contain secrets.

    flutter pub get
    flutter run --flavor dev --dart-define-from-file=env/dev.json
    flutter run --flavor prod --dart-define-from-file=env/prod.json

Preview the four-tab router shell:

    flutter run --flavor dev --dart-define-from-file=env/dev.json --route=/today

| Flavor | Android application ID | Display name |
| --- | --- | --- |
| dev | com.holdbuddy.app.dev | Holdbuddy Dev |
| prod | com.holdbuddy.app | Holdbuddy |

The starter Android release signing configuration still uses a debug key;
store signing belongs to D10.

## Checks

    dart format .
    flutter analyze
    flutter test --dart-define-from-file=env/dev.json
    flutter test --dart-define-from-file=env/prod.json

Localization generates into lib/core/l10n/generated from app_en.arb.
Inter is bundled from the [Google Fonts Inter directory](https://github.com/google/fonts/tree/main/ofl/inter)
under the included SIL Open Font License.

## Layout

lib/app contains the application, router, and theme.
lib/core contains shared infrastructure and widgets.
lib/features/<feature> separates domain, data, logic, and ui.
test mirrors lib. Empty folders gain tracked files as their tasks are implemented.
Backend folders remain reserved; current work is Android only.
Read AGENTS.md and docs/STATUS.md before the next task.
