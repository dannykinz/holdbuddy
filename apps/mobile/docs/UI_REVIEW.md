# Android UI review

U12 is still open. This source review does not replace running the app on a phone.
Analyze, tests, builds and visual review remain deferred at Danny's request.

## Source findings fixed

| Location | Problem | Fix |
| --- | --- | --- |
| Chapter, Session, Focus permission | Navigation dropped the selected chapter; sessions always used the seed plan. | Carry chapter IDs through routes and build the preview from the selected plan. |
| Chapter, Today, Session checklists | Toggling or adding tasks affected unrelated chapters. | Own each checklist by plan and chapter. |
| Notes, Chapter links | Notes appeared under another plan or chapter; a short plan could break the chapter dropdown. | Filter notes by plan, match chapter links and validate the initial selection. |
| Note cards, detail and recall | Colours depended on list order and changed when inserting/searching notes. | Store the category with the note and preserve it for the same chapter. |
| Reader and audio note actions | A note could use the material's default chapter during another chapter's session. | Prefer the active session chapter for material belonging to that plan. |
| Session start | An unfinished session could silently replace the intended plan context. | Require returning to the unfinished session before starting another one. |
| Today and plan switcher | Chapter title, duration and view state belonged to the previous plan. | Read the selected plan for session cards and reset views on a different selection. |
| Receipts and next-session rows | Seed chapter labels, dates and default navigation pointed to the wrong chapter. | Resolve the receipt plan and next chapter explicitly; final chapters lead to the completed plan. |
| Receipt privacy and recovery | Copy named a seed witness even for plans with no active witnesses. | Filter the plan's active witnesses and use private copy when none remain. |
| Today progress and first-week Plan | Seed totals or a different contract draft replaced the selected plan's progress. | Save receipts into the shared in-memory plan preview and read its totals and dates. |
| Today calendar | Selecting a date dropped it, and weeks used an old fixture year. | Keep the selected date, align its week, and reset selection when changing plans. |

Five focused regression test files cover session/receipt context, checklist isolation, note ownership/category and Today context.
They have been added but have not been executed.

## Phone checklist

Repeat each Android journey in light and dark, then at 1.3× text size.
Check Android back, keyboard dismissal, scrolling, touch targets and icon labels.
Use airplane mode for the private/local previews. Restarting clears in-memory changes.

| PRD journey | Check |
| --- | --- |
| 1 First run | Splash, onboarding, 18+ gate, account/offline entry, verification, every contract step, hold to commit, Today. |
| 2 Study session | Choose a chapter, study/task modes, focus permission, reader/audio, note, pause/resume/leave, end, save, Today. |
| 3 Missing a session | Missed choices, queued message preview and Welcome back. |
| 4 Partners | Requests, acceptance, hold each other, their plan, nudge, mute/block/report. |
| 6 Material | Scope attachment, library, each material kind, reader/player controls and chapter note. |
| 7 Deadlines | Create, detail, edit, swipe actions, done/archive and both tabs. |
| 8 Plans | Path, chapter/tasks, course switching, full new-plan contract, renegotiate/recommit, archive and complete states. |
| 9 Pro | Lifetime default, monthly selection, purchase/restore previews, welcome, ad removal. |

Journey 5 is the browser witness page and remains outside the Android scope.
Also check note search/edit/recall, settings/appearance, reminder states, privacy and account removal.

## Context regressions to exercise

- Pause Learning Dart chapter 7, switch to Flutter animations, try to start a session, then return to the original paused session. Confirm timer, note and mode remain intact.
- Toggle a task in chapter 7 and add one in chapter 6. Switch plans and back. Confirm every checklist stays separate.
- Save two notes in Functions, search for one, then open detail/recall. Confirm both retain the Functions colour.
- Create a plan with fewer than seven units. Open Chapter, add a task, write a note and start a session. Confirm valid chapter choices and the chosen contract duration.
- Save one or two units and then zero units. Confirm only that plan's preview totals change and the next-session row opens its displayed chapter.
- Finish the last chapter. Confirm the next-session row leads to the completed plan and Start another still opens Scope.
- Remove/block all of a plan's witnesses. Check receipt and missed-session copy makes no sharing or message-delivery claim.
- Select a different week from Today, then switch plans. Confirm the date and week update and the old selection resets.

## Remaining limits

Real persistence, schedule/progress recalculation and platform integrations are still data-phase work.
Recovery date offsets and weekly history remain labelled fixtures. Real recalculation and historical aggregation remain in D1.
Do not treat billing, delivery, file access or Do Not Disturb previews as device integrations.
