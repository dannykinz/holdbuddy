# Design

Figma file key: `1gTk4iExUjC5IwfAZNJNBG`
Pages: `01 · App / Light` (28:121), `02 · App / Dark` (28:122), `03 · Design system` (28:123), `04 · Website` (184:1183).
Screen node IDs: `docs/SCREENS.md`.

---

## 1. Figma protocol (saves tokens)

1. Find the screen's node ID in `docs/SCREENS.md`. Never search the Figma file.
2. Call `get_design_context` for that one screen node. Never a page or a section.
3. Call `get_screenshot` for the same node only if the context leaves something unclear.
4. The design context is a reference, not code to paste. Rebuild it with tokens and shared widgets.
5. Tokens are already in `app/theme/tokens.dart`. Call `get_variable_defs` only when creating or updating that file.
6. Build from the **light** page. Dark mode is a theme switch. Look at the dark page only to verify.
7. Icons and avatars: export once into `assets/`, then reference the asset. Never re-export per screen.
8. If two screens differ only by state (for example Today and Today / Rest day), build one screen with states, not two screens.

## 2. Tokens

Generate `app/theme/tokens.dart` from these. Light | Dark.

**Core colours**

| Token | Light | Dark | Role |
| --- | --- | --- | --- |
| bg | #FAFBFD | #101113 | Page background |
| surface | #FFFFFF | #1B1C1F | Cards, sheets |
| soft | #F0F2F6 | #24262B | Fields, inactive chips, secondary buttons |
| line | #E3E6EC | #303239 | 1 px borders, dividers |
| text | #12151C | #F7F8FA | Primary text |
| muted | #616A79 | #A5AAB5 | Body, labels |
| subtle | #8992A2 | #8A919F | Meta, placeholders |
| primary | #316DEB | #FFFFFF | Primary buttons |
| onPrimary | #FFFFFF | #16181D | Text on primary |
| primaryEdge | #225BD3 | #AFB3BB | 3D button edge |
| accent | #2F66D4 | #9ABEFF | Links, focus, headline accent word |
| tint | #EBF2FF | #182538 | Info panels, glows |
| tintLine | #CFDFFF | #2F4667 | Info panel border |
| nav | #EBEDF1 | #1A1C20 | Nav fallback |
| navActive | #FFFFFF | #34373E | Active nav pill |
| glass | #F1F3F6 @ 90% | #1C1D20 @ 88% | Nav glass fill |
| glassEdge | #FFFFFF @ 90% | #FFFFFF @ 8% | Nav glass border |
| glassActive | #FFFFFF | #FFFFFF @ 14% | Active glass nav pill |
| error | #BC3445 | #FF9BA7 | Destructive only |
| errorBg | #FFF0F2 | #321D23 | Destructive background |
| success | #216C56 | #9CCBB8 | Success text |
| successBg | #EDF7F2 | #1A2A24 | Success background |
| shadow | #CBD1DE | #060709 | Shadow tint |

**Category colours** (always mean the same thing)

| Token | Light | Dark | Means |
| --- | --- | --- | --- |
| purple / purpleSoft | #7357F6 / #F1EDFF | #B4A3FF / #231E3B | Notes, this week |
| orange / orangeSoft | #F2742B / #FFF0E6 | #FFB184 / #33231A | Tasks, deadlines, tonight |
| green / greenSoft | #139E6B / #E5F7EF | #7EDDB4 / #14291F | Done, comebacks |
| sky / skySoft | #1A9FE0 / #E6F5FD | #82D2FF / #152838 | Upcoming, info |
| pink / pinkSoft | #E5487F / #FDEBF2 | #FF9DC0 / #331E28 | People, partners, unread |

**Spacing:** 8, 12, 16, 20, 24. Screen margin 24.
**Radius:** button 18, field 16, card 24, icon tile 15, sheet top 28, chips full.

**Type, Inter only**

| Style | Size / weight | Tracking | Line height |
| --- | --- | --- | --- |
| display | 40 Semi Bold | -0.8 px | 46 |
| headline | 30 Semi Bold, 2 lines max | -0.8 px | 36 |
| title | 22 Semi Bold | -0.8 px | 28 |
| body | 16 Regular | 0 | 24 |
| strong | 16 Semi Bold | 0 | 24 |
| small | 14 Regular | 0 | 20 |
| meta | 12 Medium, subtle | 0 | 16 |
| timer | 72 Semi Bold | -0.8 px | 84 |
| label | 14 Medium, muted | 0 | 20 |
| data label | 11 Semi Bold uppercase | +1 px | Font default |

Published Holdva 2 Inter styles verified on 2026-10-12. Label and data label remain document-defined; neither has a matching published Figma style.

## 3. Shared widgets

Build these in `core/widgets` before any screen. Screens only compose them.

| Widget | Figma source | Notes |
| --- | --- | --- |
| `HbButton` | H2 / Button (29:14): Primary, Pressed, Loading, Secondary, Ghost, Disabled | 56 tall, radius 18, 4 px solid bottom edge in `primaryEdge`. `google` flag shows the Google icon. `destructive` uses `error` |
| `HbField` | H2 / Field (29:23): Default, Focus, Error, Disabled | Soft fill, no border; focus outline in accent; label above in `label` style |
| `HbDayChip` | Calendar on Today (30:5) | 44×68 within a 48 px tap target; today inverted; missed hatched; status dot |
| `HbWeekdayChip` | H2 / Day (29:28) | 48×52 rhythm selector; selected primary fill, hatch and bottom edge |
| `HbNavBar` | H2 / Navbar (29:62) | Compact glass pill, 54 tall, active tab icon plus label, others icon only, blur 36 (Flutter sigma 18) |
| `HbCreateButton` | Next to the nav on Today | 54 round, primary, same edge as buttons |
| `HbHatch` | Pattern on bars and missed days | 45°, 1.4 px stroke, 6 px gap; colour and opacity as parameters. One `CustomPainter` |
| `HbProgressBar` | Today progress | Segments (done, this week, ahead), each striped |
| `HbIconTile` | Icon tiles everywhere | 44, radius 15, soft category fill, strong icon |
| `HbAvatar` | Faces | Image with thin surface ring; stacks of three overlap |
| `HbChip` | Status pills | Soft fill, strong label, 2 to 3 words |
| `HbSheet` | Today / Create (117:835) | 42% scrim, handle, title, content |
| `HbStepBar` | Scope (32:27) | 4 segments |
| `HbCodeInput` | Verify email (33:347) | 6 boxes, active outlined |
| `HbSegmented` | Progress (101:927) | Pill track, active filled |
| `HbPathNode` | Plan (35:79) | Done, now (with glow), ahead |
| `HbEmptyState`, `HbErrorState`, `AsyncView` | Notes / Empty (36:755), Plan / Load error (41:578) | One pattern for loading, empty and error |

Navbar effects from `29:62`: shadow `#0D121F` at 12%, offset (0, 14), blur 17; active shadow `#0F1424` at 8%, offset (0, 2), blur 8. Inactive tap slots expand to 48 px to satisfy accessibility while the visual pill remains 54 px high. Active padding reduces only when its measured label needs room on narrow screens; text still scales to 1.3×.

U1 component measurements and text styles are in `app/theme/widget_tokens.dart`, exported by `tokens.dart` to keep each file under 200 lines. Icons and faces from these nodes are bundled once under `assets/icons` and `assets/avatars`. Dark verification used Today (206:3104) and Plan (206:4475).

Field validation uses the accent outline and copy instead of Figma’s red error variant, following AGENTS.md section 9: red is reserved for destructive actions.

U2 first-run screens use native Flutter illustration cards, localized labels and demo values from `core/fakes/fake_onboarding_data.dart`. Their measurements are in `app/theme/onboarding_tokens.dart`, exported by `tokens.dart`. Bundled Figma portrait exports already contain friend opacity; SVG glow filters are rendered with Flutter blur at their original sigma. Android uses native system bars, with readable icons in both themes.

The Return slide omits “No streak to lose” to follow AGENTS.md section 9. Dark verification used Splash (206:3819), Contract (206:3835), Witness (206:3943), Return (206:3991) and Get started (206:4068).

U3 account screens use `app/theme/auth_tokens.dart`, the shared fields, buttons and code input, and bundled light/dark SVGs and Google portraits. Form labels use the screen-specific 24 px line height. Validation and expired-code messages use accent; the sign-in notice uses tint, reserving red for destructive actions.

Danny approved the 18+ checkbox before account creation, Google entry and continuing offline. He also approved resending reset links while staying on confirmation; Reset password is entered from the emailed link. During the UI phase, every account screen displays “Account preview. Nothing is sent.” The added checkbox and disclosure are deliberate additions to Figma.

Account fakes live in `core/fakes`, run without network access and keep changes in memory only. Demo email `danny@example.com`, password `HoldbuddyDemo1` and code `482169` are fixtures, not credentials. Verify, validation and sign-in failure remain states of their base screens. Signed-out study repositories are preserved; temporary account details are cleared.

Dark verification covered Signup (206:4265), Signin (206:4312), Verify (206:4355), Forgot (206:4399), Reset (206:4430), validation (206:6054), sign-in error (206:6096), loading (206:6143), Google (206:6177), cancelled (206:6216), expired (206:6245), reset sent (206:6282), password saved (206:6317), offline (206:6348) and sign-out (206:6382).

U4–U6 compose the shared widgets with feature token files exported by `tokens.dart`. Scoped Figma icons, path artwork, portraits and the navigation fade are bundled locally. Today, Session, Plan and Notes keep their alternate states inside their base screens. Runtime comparison in light and dark is deferred at Danny’s request.

Material actions say “Link” instead of Figma’s upload wording, following the product rule that files stay in place. Material selection, witness messages and Android focus permissions are labelled previews backed by in-memory fakes; no file access, delivery or phone settings changes are claimed. Native checkboxes and switches preserve interaction and semantics. The focus permission screen contains Android instructions only.

U7 Settings and Appearance reuse the shared rows with selected outlines and portrait rings. Appearance updates the active app theme immediately; the fake repository retains preferences only for the app session. Session reminder states live inside Settings, with the floating navigation hidden while a preference state is open. Assets keep their source dimensions, including 20 px notice icons and the 32 px reminder hero icon.

The Pro banner uses a plain primary fill to follow section 4’s rule that hatching is never decoration. Backup and removal previews use the approved matching style, with no file or deletion claims. The legal witness copy follows the product limit of plan name, session status and the learner’s own message. These deliberate adaptations supersede the corresponding Figma copy and decorative hatch. Light/dark runtime review remains deferred.

U7 plan edits stage their terms separately from the active contract, then require the same two-second hold to recommit. Plan confirmations, scope/target/rhythm variants and holding states remain inside their base screens. Finish dates are explicitly labelled Figma samples; the scheduler remains in D1.

U8 uses bundled Figma portraits and safety icons, native form controls, and avatar-first modal sheets. The partner detail omits chapter totals, study hours, note counts and target dates to enforce the witness privacy rule. Reports use pink; only blocking and deletion use red. Profile photos, invitations, nudges, reports and account deletion are clearly labelled in-memory previews. No camera, message delivery, server deletion or linked-file removal is claimed. Light/dark phone review remains deferred.

## 4. Visual rules

- One signature: the hatch means "not done yet". Never decoration.
- Missed is hatched grey, never red. Red only for destructive actions.
- Every key screen has one biggest number (time, timer, count, finish date).
- One coloured word per onboarding or auth headline, same font.
- The logo appears on the splash only.
- Cards sit flat with a 1 px line. Floating things (nav, create button, sheets) get one soft shadow. Buttons get only their bottom edge.
- No card inside a card. Lists are rows inside one card with dividers.
- Every state screen keeps the exact header of its base screen.
- Glass only on the nav bar, with a bottom fade behind it.
- Avatars are faces, never initials.
- Icons: one duotone set, rounded line with one shape filled at 16%. Export as SVG.

## 5. Copy

- Sentence case. Buttons are verbs: Start session, Save note, Delete my account.
- Kind about failure: no shame, no streak talk.
- Errors say what happened and what to do. Never apologise.
- No em dashes anywhere in the UI.

## 6. Motion

- Default: 280 ms, ease out.
- Splash: about 1.2 s, then dissolve.
- Hold to commit: 2 s fill.
- Sheets slide up over the scrim.
- Respect reduced motion.

## 7. Accessibility

- Touch targets 48 or larger.
- Text scales to 1.3× without clipping.
- Every icon button has a semantics label.
- Contrast AA for body text in both themes.
- No meaning carried by colour alone: missed has the hatch, done has a check.

U9 uses the same Reminders screen for Upcoming, Done, Archived and the swipe-action preview. The calendar uses real month alignment and 48 px day targets, with horizontal scrolling when a phone cannot fit seven targets. Weekly/daily stop choices follow the PRD and stay attached to a reminder after saving; delivery labels read “Passed” rather than “Sent” because the UI fake does not schedule notifications. Done retains its completion date, Archive keeps the record, and Today observes the nearest upcoming reminder. Light/dark runtime comparison remains deferred.

U11 retains the Figma Pro layouts with explicit purchase/ad preview copy. The welcome copy makes no purchase or report-delivery claim. Restore checks only the in-memory preview. Perk rows use the shared card divider pattern, and ad actions have 48 px touch targets. The welcome SVG glow uses the exported asset plus native blur because the installed SVG compiler ignores Gaussian filters. Light/dark phone review remains deferred.
