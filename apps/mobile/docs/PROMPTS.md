# Codex prompts

Copy one prompt per session. Each one is short on purpose: AGENTS.md and STATUS.md carry the context.

---

## 1. Kickoff (first session only)

```
Read AGENTS.md and docs/STATUS.md. Then do task U0.1 only.

Create the Flutter project "holdbuddy" in this repo:
- Folder structure exactly as AGENTS.md section 7.
- Flavors dev and prod. Config through --dart-define-from-file with env/dev.json, env/prod.json (git-ignored) and env/example.json committed.
- Add only the packages in AGENTS.md section 8 that U0 to U12 need: flutter_riverpod, riverpod_annotation, riverpod_generator, freezed, json_serializable, build_runner, go_router, flutter_svg, intl, flutter_localizations, mocktail. Check pub.dev for current stable versions and pin them. Do not add backend, ads or purchase packages yet.
- Strict lints (analysis_options.yaml with strict-casts, strict-inference, strict-raw-types).
- Inter as the app font, bundled in assets/fonts.
- l10n setup with an app_en.arb file.
- main.dart that runs an empty app with the light theme placeholder.

Bundle ID: ask me before choosing one.

Finish with: flutter analyze clean, the app runs, STATUS.md updated, 5-line report.
```

## 2. Tokens and theme (U0.2)

```
Read AGENTS.md and docs/STATUS.md. Do the next task: U0.2.

Use the Figma MCP. Call get_variable_defs once on file 1gTk4iExUjC5IwfAZNJNBG, node 28:123, and confirm the values match docs/DESIGN.md section 2. If they differ, Figma wins; tell me which ones.

Create lib/app/theme/tokens.dart (light and dark colour sets, category colours, spacing, radius, text styles) and lib/app/theme/app_theme.dart building ThemeData for light and dark from those tokens. Use a ThemeExtension for anything ThemeData has no slot for (soft, line, subtle, tint, glass, category colours).

No widget may ever use a raw colour after this. Add a test that builds both themes.

Finish with analyze, tests, STATUS.md, 5-line report.
```

## 3. Any following task (reuse every session)

```
Read AGENTS.md and docs/STATUS.md. Do the next task listed under "Now" only.

For each screen, take its node ID from docs/SCREENS.md and call get_design_context for that node only. Build it from the shared widgets and tokens, with fake data from lib/core/fakes. Build "state of" screens as states inside their base screen. Wire navigation to match the flow map in docs/PRD.md.

If Figma is missing a state or the PRD is silent, ask me instead of guessing.

Finish with: dart format, flutter analyze clean, tests for this task, light and dark checked, STATUS.md updated, 5-line report.
```

## 4. Review after each phase

```
Read AGENTS.md and docs/STATUS.md. Review the code from the phase just finished against AGENTS.md sections 3, 4, 9 and 10.

List only real problems: oversized files or functions, duplicated widgets, raw colours or sizes, inline strings, missing tests, product-rule violations. For each: file, line, fix in one sentence.
Then fix them, smallest change first. Do not refactor anything that passes.
```

## 5. Resume after a break

```
Read docs/STATUS.md only. Tell me in 3 lines where we are and what the next task is. Wait for my go.
```
