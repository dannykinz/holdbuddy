# Holdbuddy: Product Requirements Doc

Oct 4, 2026 · @Daniel Akinleye

Holdbuddy is a mobile accountability app for self-taught learners and students: you commit to a plan, one person witnesses it, and missing a day moves your finish date instead of ending the plan. Version 2 matches the Figma design as of 4 October 2026: 136 connected app screens in 18 sections, light and dark, a flow map, and a five-page website. Andela capstone, Track 2 (Engagement), crossing into Track 3.

**The name.** Holdbuddy, renamed from Holdva. A buddy who holds you to it is the mutual-accountability idea in one word. Holdmate was rejected: two phone-accessory brands already use it, one with the ® mark and a product called Holdmate Pro, which would clash with our Pro plan. A web search found no Holdbuddy conflicts, but that is not a clearance; check USPTO, EUIPO and the Nigerian trademark registry before filing. Nearest neighbour is an older student focus app called Hold.

## The problem

Learners do not quit because they cannot find materials. They quit because nobody notices when they stop.

Access has mostly been solved. Free courses, PDFs, YouTube lectures and open curricula are already on the average learner's phone. The failure happens later, in week three, when the material is still there and the person is not.

The drop-off has a shape, and it is always the same:

1. The learner misses one session. Nothing happens.
2. They miss two more. Now they are behind.
3. Opening the app means seeing proof of their own failure.
4. So they stop opening the app.
5. The tool built to help them becomes the thing they avoid.

Most study apps make step 3 worse. Streaks, progress rings and red missed-day markers are designed for the perfect week. Break a 40-day streak and the honest reaction is not to try harder. It is to delete the app. The product punishes the exact moment it was supposed to catch.

Reminders do not fix this either. A push notification assumes the problem is forgetting. It almost never is. The learner knows they should study. They remember at 9pm and decide not to. Nothing in the app is strong enough to change that decision.

So the real question is not how to remind someone. It is this: **what does the product do on day four, after three days have already been missed?** That moment is where learners are lost, and almost nothing on the market is designed for it.

## Who it is for

Primary user: the self-taught learner. Someone working through a course, a curriculum or a skill with no lecturer, no deadline, and nobody checking whether they showed up today.

This is the harder user, and that is the point. A university student already has external pressure. Exam dates, fees, lecturers, fear of failing. A study app for them is a nicer calendar sitting on top of pressure that already exists.

The self-taught learner has none of that. No consequence for quitting on a Tuesday. No one who notices. If the product can keep that person moving, it will comfortably keep a university student moving. The reverse is not true, which is why most study apps fail outside a semester structure.

**Secondary user:** the university or bootcamp student with a fixed syllabus. Same product, no changes. They simply import a deadline instead of inventing one.

**The witness, who may or may not be a learner.** A friend, sibling, parent or mentor who holds the learner to their word. They can follow a plan from a web link with no app at all. If they install Holdbuddy, they get the full app like anyone else.

**Everyone is both.** There is one account type. A user can have their own plans and be someone else’s witness at the same time, and two users can witness each other. Being Amaka’s witness never changes your own courses, sessions or notes.

## The core mechanic: the Contract

The product is a commitment device, not a reminder app.

The insight it runs on: the person who makes the plan and the person who has to follow it are not the same person. Sunday You is rested, motivated and serious. Wednesday You at 10pm is tired and looking for a reason to skip. Every study app is designed to be used by Sunday You and then abandoned by Wednesday You.

The Contract lets Sunday You bind Wednesday You.

At setup, while motivation is high, the learner locks in five things:

| Term | What the learner sets | Why it is set now |
| --- | --- | --- |
| Scope | What they are learning and how much of it | Gives the finish line a real number |
| Rhythm | Which days, what time, how long per session | Removes the daily decision to study |
| Deadline | Target finish date, or none | Creates pressure where none existed |
| Consequence | What happens when a session is missed | Chosen freely, so it is fair later |
| Witness | Who gets told, and in what words | Makes the consequence real |

Once committed, those terms are not casually editable. Changing them requires going through the renegotiation flow, which is deliberately slower than simply doing the session.

The consequence is never invented by the app. The learner writes it themselves, in their own words, during the serious moment. Something like: *if I skip, tell Elvis I'm slacking again.* When it fires later, it is not software nagging. It is past-you calling out present-you through someone who matters.

That single detail is the product. Everything else supports it.

## Four design principles

These are rules, not preferences. Any feature that breaks one gets cut.

**1. Built for failure, not the perfect week.**

No streaks. No red marks. No broken-chain graphics. When a learner misses sessions, the plan recalculates and shows them a new finish line. Missing becomes arithmetic, not a verdict.

The measure of this product is not how many people complete a plan. It is how many people come back after missing three days. That is the only number worth tracking.

**2. Accountability is a person, not a notification.**

You can ignore an app forever. It is much harder to ignore someone waiting on you. Every plan has at least one witness, and each witness is told what the learner asked them to be told.

An invited person beats an assigned stranger every time. Shame only works when the person matters. That is why there is no stranger matching.

**3. Friction on quitting, zero friction on continuing.**

Most apps have this backwards. Starting a session should be one tap from the lock screen. Abandoning the plan should take four taps and an honest answer about why.

The app never blocks the exit. It just refuses to make it effortless.

**4. Free stays complete, and study time stays clean.**

Every feature works on the free plan. Ads pay for it, but never during a session, focus mode, onboarding or the contract. An ad that interrupts studying would undo the product.

## Product map

The app is 136 screens in 18 sections, every one reachable from Splash with no dead ends, in light and dark. The Figma file holds the source of truth: page `01 · App / Light` for screens, `02 · App / Dark` as the synced mirror, and section `00 / Flow map` for every journey end to end.

| # | Section | What it covers | Screens |
| --- | --- | --- | --- |
| 01 | A quieter kind of accountability | Splash, three onboarding screens, Get started | 5 |
| 02 | Your account | Sign up, sign in, verify email with six-box code, forgot and reset password | 5 |
| 03 | Make a contract | Scope with material, rhythm, consequence, witness, contract, material attached | 6 |
| 04 | The daily loop | Today, session, session saved, missed, welcome back | 5 |
| 05 | Everything around the session | Plan path, notes, renegotiate, witness view, settings | 5 |
| 06 | Daily states and recovery | Today states, paused and leave, rescheduled, plan history and complete | 20 |
| 07 | Account states | Sign-up validation, sign-in error, Google cancelled, offline | 10 |
| 08 | Preferences and changing the plan | Appearance, session reminders, witness management, adjust plan, archive, data | 20 |
| 09 | Validation and confirmations | Field errors, recommit, plan updated, load errors | 13 |
| 10 | Flow continuity | First week, message sent and queued, edge returns | 13 |
| 11 | Study tasks and notes | Chapter, session with tasks, new note, add task | 4 |
| 12 | Alerts and progress | Alerts inbox, progress | 2 |
| 13 | Plans and creating | Create sheet, plan switcher | 2 |
| 14 | Profile and partners | Edit profile, partners, their plan, hold each other, delete account and done | 6 |
| 15 | Reminders | Deadlines list, new, swipe actions, done tab, detail | 5 |
| 16 | Material and focus | Add material, library, PDF reader, audio player, choose mode, focus permission, focus session | 7 |
| 17 | Holdbuddy Pro | Paywall, welcome, Today with an ad | 3 |
| 18 | Safety | Mute, block and report sheet, report, report sent, block confirm, blocked people | 5 |

Tabs are Today, Plan, Notes and Settings in a compact glass bar, with a floating + beside it that opens Create: new plan, add a task, write a note, add a reminder.

## Flows

&#91;embedded content: core loop · 7 states, 1 decision, 3 return paths\]

There is no terminal state except finishing the plan. Missing a session routes back into the loop within one screen, and a run of missed days routes through Welcome back rather than dropping the learner on an unchanged Today screen.

Nine journeys cover the whole app. Each one is wired as a clickable prototype; press play from Splash in Figma to walk any of them.

| # | Journey | Ways in | Path |
| --- | --- | --- | --- |
| 1 | First run | Install | Splash → onboarding ×3 → Get started → sign up or Google → verify email → Scope → add material → Rhythm → Consequence → Witness → Contract (hold 2 s) → Today |
| 2 | A study session | Today, Chapter | Start session → choose study or task mode → Do Not Disturb permission (first time) → focus session → PDF reader or audio → write a note → end → session saved → Today |
| 3 | Missing a session | Alert, Today | Missed → do it now, move it, or let it go → message sent (queued if offline) → Welcome back with the new finish date |
| 4 | Partners, both ways | Today partners strip, Alerts, Settings | Partners → Requests → invite detail → Accept → Hold each other? → their plan → send a nudge |
| 5 | Witness with no app | SMS or WhatsApp link | Witness view in the browser → I’ve seen the plan → nudge or stop witnessing |
| 6 | Course material | Scope, Chapter, Settings | Add your material → PDF, Word, audio or link → attached on Scope, or the library → reader or player → note |
| 7 | Deadlines | Today “Coming up”, the + sheet, Settings | Reminders → new reminder → detail → mark done or archive → Done tab |
| 8 | Plans | Plan tab | Plan path → chapter → tasks; ⋯ menu → renegotiate → recommit → plan updated; course switcher → new plan → Scope; finish → plan complete → start another |
| 9 | Pro | Ad on Today, Settings banner | Paywall → monthly or lifetime → welcome → Today without ads |

The setup rule still holds: every new plan goes through Scope, Rhythm, Consequence, Witness and Contract. Nothing skips the commitment. Scope has a Later option for people not ready yet; Witness has Continue without a witness.

## Notifications

Nine notification types exist, and nothing else ever fires. Each one opens the screen that resolves it, and every one also appears in the Alerts inbox behind the bell.

| Trigger | Timing | Copy | Opens |
| --- | --- | --- | --- |
| Session due | 15 min before | Chapter 7 in 15 minutes. You set this. | Today |
| Session missed | 1 hr after start time | You missed Chapter 7. Three options. | Missed |
| Message sent | When you let a session go | Elvis has been told. | Today |
| Nudge received | On arrival | Elvis: *their words* | Today |
| Return after absence | 3 days silent, once only | 3 sessions missed. New finish date inside. | Welcome back |
| Partner request | On arrival | Zainab wants you as her witness | Invite detail |
| Partner let a session go | Instant | Elvis let Wednesday go | Their plan |
| Deadline | 3, 2, 1 weeks or days before, and on the day | ENT 201 assignment is due in 3 days. | Reminder detail |
| Plan complete | On the final session | Done. 24 chapters, start to finish. | Plan complete |

Rules:

1. **No motivational messages.** No quotes, no “you can do it”. Encouragement as a feature means the system underneath isn’t working.
2. **The return notification fires once.** If ignored, the app goes quiet.
3. **Quiet hours are absolute** and come from the times the user set in Rhythm.
4. **Partner updates are instant for everyone.**

## Partners and witnesses

Witnessing is a relationship between two accounts of the same type, and it can run both ways. Partners is the one screen where both directions live: “Holding you” and “You’re holding”, with a Mutual tag when it goes both ways.

**Becoming someone’s witness.** The learner shares an invite link from their own phone, by WhatsApp, SMS or email. The invitee chooses one of two paths:

1. **Link only.** They follow the plan in a browser, no account, no install. This stays the default promise of the product.
2. **In the app.** They accept inside Holdbuddy, and a sheet asks “Hold each other?” One tap makes it mutual.

**Finding a request without the notification.** A pending request shows in three places, so a missed push never loses it:

- A Partners strip on Today with faces, one line of partner activity, and a pink “1 request” pill.
- A Requests section at the top of Partners, with Accept and Decline on the card.
- The Alerts inbox.

| The witness | Detail |
| --- | --- |
| Sees | The plan name, whether a session happened, and the message the learner wrote. Never notes, files or other plans. |
| Can do | Open the plan, send a nudge, stop witnessing. Link-only witnesses do the same from the witness page. |
| Cannot do | Verify that studying happened. They witness; the app reports. |

A witness never affects their own plans. Being Amaka’s witness changes nothing about your Dart plan. There is no limit on how many people you hold, and a plan can have several witnesses; the consequence message goes to each of them. All of it is free.

**Pending requests.** A request stays open for 10 days. The inviter can check its status on the pending witness screen and send one reminder. After 10 days it expires and the app suggests inviting someone else.

**Declines stay quiet.** A declined request and an expired one look identical to the inviter: “This invite didn’t go through.” Nobody finds out they were turned down.

**How messages travel.** No SMS provider at launch.

| Message | Witness has the app | Link-only witness |
| --- | --- | --- |
| The invite | Sent from the learner’s phone through the share sheet: WhatsApp, SMS or anything else | Same |
| Consequence, nudges, updates | Push notification, instantly | Email, instantly, plus the live witness page |

The invite comes from someone the witness knows, which is more trusted than a shortcode and costs nothing. This needs an email for link-only witnesses, so the witness screen asks for email first and phone second. Paid SMS can be added later for witnesses with phone only.

Stranger matching from v1 is dropped: guilt scales with the relationship, and partners covers the real need.

## Tasks and notes

Every chapter says what its session is for, so 45 minutes is never just a timer. Tapping a chapter on the Plan path opens it: the date and time, a checklist of tasks, your material, and your note for that chapter.

- **Tasks.** Each chapter starts with sensible defaults (read the chapter, run the examples, write one note) and the learner can add their own from a three-element sheet. The checklist stays under the timer during a session in task mode.
- **Notes, any time.** Notes are written mid-session, from the reader, from the audio player, or from the + button on any tab. Each note belongs to a chapter and carries that chapter’s colour, so a purple note on Today is purple in Notes too.
- **Recall.** Note detail offers an optional recall: the learner tries to remember before the note is revealed. No score, no timer.

Notes stay on the phone. The only way they leave is a backup file the user exports themselves.

## Course material

Holdbuddy is a viewer, not a store. A learner’s 30 MB PDF stays exactly where they keep it; Holdbuddy remembers where it is and opens it from there, offline, with no copy and no upload. We host no content, so there is no storage cost and no copyright exposure.

| Type | Opens in | Remembers |
| --- | --- | --- |
| PDF | The in-app reader, with highlights | The page you were on |
| Word document | The same reader | The page you were on |
| Audio | The player, with speed control and 15-second skips | The minute you paused at |
| Link | The reader’s web view | Nothing; it needs a connection |

**How a file is linked.** On Android, the app keeps a persistent permission to the file the user picked. On iPhone, it keeps a bookmark to the file from the Files picker. Either way, the original file is the only copy.

**Where it’s added.** On Scope, an “Add your material” card shows the four types and opens the picker; the file then sits on Scope with remove and Add another. Once a plan exists, material lives on each chapter and in the library, which lists every linked file with its own progress bar.

**During a session.** Study mode opens the material with the timer. The reader carries the session time in a glass bar; a focus session shows Continue listening to resume audio where it paused.

**When a file moves.** If the user moves, renames or deletes the original, the link breaks. The app shows Material unavailable with Find it again, which reopens the picker and relinks it; reading position is kept. The screen shows where the file was last seen. A link that can’t load offline gets the same treatment.

## Focus mode

Every Start session opens one sheet with one decision: how to work, and whether to silence the phone.

| Choice | What changes |
| --- | --- |
| Study mode | Your material opens with the timer |
| Task mode | Your checklist stays on screen |
| Silence other apps (on by default) | Notifications from other apps stop until you end the session |

**Android.** The app asks once for Do Not Disturb access, explains it on its own screen, then turns Do Not Disturb on at session start and off at the end. Starred contacts still get through.

**iPhone.** Apple doesn’t let apps switch Focus on themselves. Holdbuddy reminds the user to start their own Study Focus instead, and the permission screen says so plainly rather than overpromising.

While focus is on, the session shows “Focus on · apps silenced”. No ads ever show in focus mode.

## Deadlines

Reminders are for things that are not study sessions but cannot be missed: an assignment, a deferment form, exam registration. The schedule sets itself from how far away the deadline is.

| Due date is | Reminders go out |
| --- | --- |
| More than 3 weeks away | 3 weeks, 2 weeks and 1 week before, and on the day |
| 3 weeks or less away | 3 days, 2 days and 1 day before, and on the day |

The add screen shows the rule as you pick the date, for example “Due in 24 days, so we’ll remind you weekly”, and each stop can be switched off. A deadline has a title, a date and a category (School, Admin or Personal).

**Finishing them.** Swipe a card to reveal Done and Archive, or open it and use Mark as done. The list has three tabs: Upcoming, Done and Archived. Done keeps when you finished, such as “3 days early”. Archived hides a reminder without deleting it.

**Where they show.** The nearest deadline sits on Today as a Coming up row. Reminders are also reachable from the + sheet and from Settings.

## Profile and account

**Sign in.** Google is the primary path, email the second. Sign up asks for name, email and password; verification uses six separate code boxes. Get started also offers Continue offline.

**Profile.** Your avatar sits in every Today header and opens Edit profile: photo with a camera badge, name, email, and what you’re studying. Avatars appear wherever a person does: partners, alerts, the witness view.

**Settings** is a door to everything: the Pro banner, profile, Appearance (light by default), Session reminders, Partners, Deadlines and reminders, Focus during sessions, Files on this phone, Backup and restore, Privacy and local data, and Sign out. Backup and restore exports one file of notes and app data to wherever the user picks, and restores it on a new phone; the existing Privacy and local data screen already prompts this before changing phones.

**Deleting an account.** Both stores require deletion inside the app. Edit profile → Delete account opens a confirmation listing what goes, with “Type DELETE to confirm”, then a done screen. The same request can be made on the website, which Google Play also requires.

## Safety

Anyone who can message you can be muted, blocked or reported, lightest action first. Entry points: the ⋯ on a partner’s plan and “Report or block” on Witness manage.

| Action | Effect | The other person sees |
| --- | --- | --- |
| Mute nudges | Partnership stays; their nudges stop | Nothing |
| Block | They can’t message you or see your plans; both partnership directions stop | The partnership end, nothing more |
| Report | One of four reasons, optional last message attached, “Also block” on by default | Nothing |

Blocked people are listed in Settings with Unblock; unblocking does not restore the partnership. Reports are private and land in a Supabase table that is reviewed in the Supabase dashboard. There is no admin panel; build a small Nuxt dashboard only when support is handed to someone non-technical or reports exceed a few a week.

## Free and Pro

Every feature is free and ads pay for it. Pro removes ads and adds conveniences, never core features.

|  | Free | Pro |
| --- | --- | --- |
| Price | ₦0 | ₦2,500 a month, or ₦12,000 once for lifetime |
| Plans, partners, focus, material, deadlines | All included | All included |
| Partner updates | Instant | Instant |
| Backup to a file | Included | Included |
| Ads | Google AdMob, outside study time | None |
| Monthly progress report | None | Your month on one page, shareable or saved as PDF |
| App icons and themes | Default | Alternate icons and colour themes |

**Ad rules.** Never during a session, focus mode, onboarding or the contract. One native ad on Today, below the work, labelled Sponsored with a Remove ads link to the paywall. Free users land on that version of Today after sign-in.

**Billing.** Through Google Play and the App Store only, which take a share of each payment. The paywall pre-selects lifetime as the better deal and offers Restore purchase. Entry points: the Remove ads link and the Pro banner at the top of Settings.

**Pro is mostly ad removal, and that’s fine.** Every core feature stays free on purpose. The report and themes are small extras; the honest pitch is a clean app and supporting the product. Backup is free for everyone because losing your notes should never be a paid problem.

## Design system

All colour lives in one Figma variable collection with Light and Dark modes; dark mode is the same screens with the mode switched, never hand-picked hex. Light is the default.

| Element | Rule |
| --- | --- |
| Type | Inter only. Display 30 to 40 px, tight tracking; one accent word per hero headline in blue |
| Primary button | 56 px tall, 18 px radius, a 4 px solid bottom edge. Blue in light, white with dark text in dark |
| Grid | 24 px gutters, 8 px rhythm, one container depth, never a card inside a card |
| Categorical colour | Purple notes and this week, orange tasks and deadlines, green done and comebacks, sky upcoming, pink partners and unread |
| Hatch pattern | Diagonal lines that always mean “not done yet”: the road ahead on progress bars, a missed day, a selected study day |
| Navigation | A compact glass pill (54 px, 36 px background blur) hugging four tabs, with a 54 px + beside it, over a 170 px fade |
| Icons | One custom duotone set: rounded line icons with one shape filled at 16%, stroke tuned per size (1.5 px at 16, 2.3 px at 36) |
| People | Real avatars with a coloured ring, never initials; the six character avatars in the file are placeholders |

**Never red for a missed session.** Missed is hatched grey everywhere. Red is reserved for destructive actions such as deleting an account.

**Google sign-in** uses the button component’s Google icon toggle, not a separate button.

## Operating constraints

The brief lists seven constraints. Each one is answered below, and each answer is a build decision, not a statement of intent.

**Low bandwidth and limited data.** The app is offline-first. Plans, sessions, notes and the schedule live on the device. Nothing needs a connection to start or finish a session. The only outbound traffic is the witness signal, which is a few hundred bytes. With no data, it waits in a queue and sends when a connection returns.

**Basic devices.** No video and no heavy bundled assets. PDFs and audio are the learner’s own files, opened where they live. Target install size under 15MB and usable on a 2GB-RAM Android phone.

**Quality and credibility.** The app hosts no learning content, so it cannot serve bad content. The learner brings their own material, linked in place on their own phone, as described in Course material. Hosting nothing is also what keeps it light.

**Accessibility and inclusion.** Minimum 16px body text, scaling with system settings. Full screen-reader labels. Touch targets 48px minimum. The core daily action is one button, which keeps it usable at low digital confidence. No feature depends on reading a graph.

**Personalization without exclusion.** The plan adapts to the learner's own pace, which they set themselves. There is no profile type, no placement test, no algorithm deciding who gets what. Nobody can be excluded by a model because no model is making decisions about people.

**Privacy and security.** Notes stay on the device and material is opened where it lives; nothing is uploaded. The only way notes leave is a backup file the user exports to a place they choose. A witness sees the plan name, whether a session happened, and the learner’s own message, never notes or files. Free users see AdMob ads, which use device identifiers, and the privacy policy says so. The learner can remove a witness at any time, and can delete their account in the app or on the website.

**Multilingual access.** All strings externalised from the first commit. English at launch. The consequence message is free text, so a learner writes it in Yoruba, Pidgin, French or anything else and it is delivered exactly as typed. The most emotionally loaded text in the product is already multilingual by design.

## Data model

Fourteen entities. The phone’s SQLite database is the source of truth and the app works fully offline; changes sync to Supabase when a connection returns. Notes and material never leave the device.

| Entity | Key fields | Lives on |
| --- | --- | --- |
| user | id, display\_name, email, avatar\_url, studying, locale, quiet\_hours, tier (free, pro) | Device, synced |
| plan | id, user\_id, title, total\_units, unit\_name, units\_done, start\_date, target\_date, status (active, paused, renegotiated, archived, complete) | Device, synced |
| contract | plan\_id, days, time, duration\_min, consequence\_message, committed\_at | Device, synced |
| plan\_witness | plan\_id, partnership\_id | Device, synced |
| session | plan\_id, chapter, scheduled\_at, started\_at, ended\_at, mode (study, task), focus\_on, outcome (done, moved, missed, let\_go) | Device, synced |
| task | id, plan\_id, chapter, label, is\_default, done\_at | Device, synced |
| partnership | id, learner\_id, witness\_user\_id (null for link-only), witness\_name, witness\_email, witness\_phone, status (pending, active, declined, expired, stopped), invited\_at, reminded\_at, expires\_at (invited\_at + 10 days), mutual\_with | Server, cached on device |
| message | id, partnership\_id, type (consequence, nudge, update), channel (push, email), delivery (queued, sent), sent\_at | Queued on device, sent by server |
| reminder | id, user\_id, title, category, due\_at, cadence (weekly, daily), stops, status (upcoming, done, archived), done\_at | Device, synced |
| entitlement | user\_id, product (monthly, lifetime), store (play, app\_store), status, expires\_at | Server, cached on device |
| note | id, plan\_id, chapter, body, created\_at | Device only; leaves only in a user-exported backup file |
| material | id, plan\_id, type (pdf, doc, audio, link), file\_reference (Android persisted permission or iOS bookmark) or url, display\_name, last\_seen\_path, position (page or second) | Device only; the file itself is never copied |
| block | blocker\_id, blocked\_id, created\_at | Server, cached on device |
| report | id, reporter\_id, reported\_id, reason, message\_id (optional), details, status (open, reviewed, actioned), created\_at | Server only |

**Still no streak field.** Not hidden, not computed at read time. If it isn’t in the schema, nobody can add it back in a weak moment.

**Mutual is two rows.** Holding each other is two partnership rows pointing at each other through `mutual_with`, so either side can stop without ending the other.

## Stack

Two honest options. The decision turns on one thing: scheduled local notifications.

**Option A: Nuxt PWA plus Supabase.** Fastest to ship, matches existing skill, offline-first via service worker and IndexedDB, installable to the home screen. The problem is that a PWA cannot schedule a local notification. Reminders must be sent as server push, which means the reminder itself needs a connection. For an app whose whole promise is working on bad networks, that is a real hole.

**Option B: Flutter.** True local notifications fired by the device with no network involved. Real background scheduling, real offline behaviour, smaller install, and it runs properly on cheap Android. The cost is learning curve inside a sprint.

**Recommendation: Flutter for the app, Supabase for the backend, Astro for the website, Nuxt for the witness view.**

The reason is not preference. A device-scheduled notification is the one technical detail that proves the offline claim, and the offline claim is what separates this from every study app that assumes good wifi. Building it as a PWA means standing in front of judges and explaining that the reminders need internet.

Flutter is also already on the roadmap, so the sprint doubles as the start of that.

| Layer | Choice | Why |
| --- | --- | --- |
| App | Flutter | Device-scheduled notifications, offline by default, Android and iPhone from one codebase |
| Local data | SQLite on the device as the source of truth, with a sync queue | Every screen works offline; changes sync when a connection returns |
| Material | Files linked in place: Android persisted permissions, iPhone security-scoped bookmarks | No copies, no storage cost; a 30 MB PDF opens from where it lives |
| Backup | Export and import of one backup file through the system share sheet | The user picks where it goes; we never hold their notes |
| Backend | Supabase | Postgres, auth with Google, row-level security for partnerships |
| Notifications | Local scheduling for sessions and deadlines; push for partner events | Reminders fire with no network; partner events need one |
| Witness messages | Share sheet for invites; push for app witnesses; transactional email for link-only witnesses | Free to run; no SMS provider at launch |
| Focus | Android Do Not Disturb access | The only platform that allows it; iPhone gets a Focus prompt |
| Ads | Google AdMob through the official Flutter plugin | Free tier revenue, never in study screens |
| Billing | Google Play and App Store in-app purchases | Monthly subscription and a lifetime one-time product |
| Web | Astro for marketing and legal pages; Nuxt for the live witness page | Matches your stack; the witness page needs live plan data |
| Crash reporting | Firebase Crashlytics, plus Play Console Android vitals and App Store Connect | Free and mobile-first; reports queue offline and send on next launch. Upload debug symbols every release |

One flag: email to link-only witnesses needs a transactional email service and a verified sending domain, so it waits on the domain decision. Until then, the witness page and the shared invite link carry the experience.

## Website and store readiness

The website is five desktop pages on the Figma page `04 · Website`, all linked: the landing page, Privacy Policy, Terms of Service, Support and Delete account. It follows one rule from the reference video: one idea per section, and the phone is always the hero, using real Holdbuddy screens.

**Landing page, top to bottom:**

1. **Hero.** “Study plans you actually finish.” with three real avatars set inside the headline, three feature points, one dark pill button, and three tilted phones (Plan, Today, Progress) on a hatched stage.
2. **Built for the day you miss.** The Welcome back screen with floating chips: plan recalculated, Elvis was told, no streak lost.
3. **Everything a study plan needs.** Five real screens in a row: focus, PDFs, audio, deadlines, partners.
4. **Three minutes to set up.** The three steps.
5. **Pricing.** Free against Pro.
6. **FAQ.** Six questions, including how to delete an account.
7. **Closing band.** “Your next chapter starts tonight.”, the app in dark mode, and store buttons.

| Requirement | Google Play | App Store | Covered by |
| --- | --- | --- | --- |
| Privacy policy URL | Required | Required | Privacy Policy page |
| Support URL | Contact email required | Required | Support page |
| Delete account inside the app | Required | Required | Edit profile → Delete account |
| Web page to request deletion | Required | Not required | Delete account page |
| Data and privacy declarations | Data safety form | App privacy labels | Must match the Privacy Policy exactly |
| Ad verification | AdMob checks app-ads.txt | AdMob checks app-ads.txt | A file on the website’s domain |

**Before submitting:** fill the bracketed placeholders in the legal copy (company, address, emails, the 30-day window) and have it reviewed, since it is a draft and not legal advice. Swap the layout store buttons for the official badges from Google and Apple’s brand guidelines. Design the mobile version of the site, since most visitors arrive from a phone, especially witnesses tapping an invite link.

## Out of scope

This is an invention sprint, not a launch. Every cut below was made on purpose and each one has a reason that survives being asked about.

| Cut | Why |
| --- | --- |
| AI tutoring or chat | Needs constant data, breaks the offline claim, and joins the most crowded lane |
| Hosting course content | Learners bring their own material; hosting it adds cost and copyright risk |
| Group or cohort study | Partners covers one-to-one accountability; groups dilute it |
| Stranger matching | Dropped in v2; guilt only works with someone who matters |
| Career pathways | A strong Track 3 extension, not provable in a sprint |
| Streaks, points, badges, leaderboards | Contradicts principle 1; milestones count chapters and comebacks instead |
| Cross-device note sync | Notes stay local; a backup file the user exports restores them on a new phone |
| Web app for learners | The web is only for witnesses, marketing and legal pages |

**Moved into scope since v1:** Holdbuddy Pro and ads, deadline reminders, course material with a reader and player, focus mode, and an iPhone build alongside Android.

## Build order and demo

**Build in this order.** Each stage is demonstrable on its own, so a sprint that runs out of time still has something that works.

1. The contract flow, Scope to Contract, writing to local SQLite. This alone demos the commitment.
2. Today and the session, with a device-scheduled notification firing in airplane mode.
3. Missed and Welcome back, including the recalculation logic. This is the actual idea.
4. The witness link: a web page plus a partnership row. First time a second person is involved.
5. Tasks and notes on each chapter.
6. Course material: local PDF and audio, the reader and the player.
7. Focus mode with Android Do Not Disturb.
8. Deadlines and their schedule rule.
9. Partners both ways: requests, Hold each other, their plan.
10. Account deletion, Privacy, Support and the website, since stores reject without them.
11. Pro, billing and AdMob, after the free product is proven.

If time runs out, stages 1 to 4 are the capstone demo. Stages 5 to 9 make it a product, 10 makes it publishable, and 11 makes it pay.

**The demo script, five minutes**

1. *Thirty seconds of setup.* Create a plan on screen, including writing the consequence message out loud. The judges watch a real person write *if I skip, tell Elvis I'm slacking.* That sentence does more work than any slide.
2. *Put the phone in airplane mode.* Start a session. Finish it. Everything works. Say nothing about offline. Let them see it.
3. *Skip forward three days.* Open the app. It lands on Welcome back, not Today. New finish date, one button, no red marks, no guilt.
4. *Show the second phone.* The witness device, which has no app installed, receives the message the learner wrote. In their own words.
5. *Close with one line:* most study apps are built for the week you don't miss. This one is built for day four.

**The one number to claim**

Do not claim completion rates. There is no data and inventing one would be the fastest way to lose credibility in the room.

Claim the metric instead: *return-after-absence*. State plainly that this is what the product optimises for, that nobody else measures it, and that it is measurable from day one with the schema above. A team that names the right metric and admits it has no numbers yet reads as more serious than a team with a fabricated chart.

## Decisions

Eight product rules were settled on 4 October 2026; three stay open and none of them block the build.

| Topic | Decision |
| --- | --- |
| Partner updates | Instant for everyone. No free daily summary |
| Witness requests | Pending for 10 days. The inviter sees the status and can send one reminder; after 10 days it expires |
| Declined requests | Declined and expired look the same to the inviter: “This invite didn’t go through.” Nobody learns they were turned down |
| Witness limits | None. Hold as many people as you like |
| Witnesses per plan | Several allowed, for everyone. The consequence message goes to each one |
| Minimum age | 18 and over. Avoids parental-consent and child-ad rules; confirm with a lawyer |
| Backup | No cloud backup. Backup to a file, free for everyone: export to a place the user picks, restore on a new phone |
| Messages to witnesses | No SMS provider for now. Invites go through the phone’s share sheet; ongoing messages go by push, or email for link-only witnesses |

Still open:

- [ ] **Pricing.** ₦2,500 monthly and ₦12,000 lifetime for launch, revisited once real usage is known.
- [ ] **Domain and emails.** The site, support and privacy addresses are placeholders.
- [ ] **Trademark.** Clear Holdbuddy on the USPTO, EUIPO and Nigerian registers before filing.
