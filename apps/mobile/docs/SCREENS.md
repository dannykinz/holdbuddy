# Screens

Figma file `1gTk4iExUjC5IwfAZNJNBG`, light page `28:121`. 136 screens.
Pass one node ID at a time to the Figma MCP. `state of X` means build it as a state inside screen X, not a new screen. `sheet` means a bottom sheet over the screen behind it.

Phase column: the UI build order in `docs/STATUS.md`.

## 01 / A quieter kind of accountability

Section `33:47` · Phase U1

| Screen | Node | Build as |
| --- | --- | --- |
| Splash | `33:50` | screen |
| Onboarding / Contract | `33:82` | screen |
| Onboarding / Witness | `33:126` | screen |
| Onboarding / Return | `33:170` | screen |
| Get started | `33:214` | screen |

## 02 / Your account

Section `33:255` · Phase U2

| Screen | Node | Build as |
| --- | --- | --- |
| Sign up | `33:258` | screen |
| Sign in | `33:304` | screen |
| Verify email | `33:347` | screen |
| Forgot password | `33:387` | screen |
| Reset password | `33:423` | screen |

## 03 / Make a contract

Section `32:24` · Phase U3

| Screen | Node | Build as |
| --- | --- | --- |
| Scope | `32:27` | screen |
| Rhythm | `32:74` | screen |
| Consequence | `32:139` | screen |
| Choose witness | `32:178` | screen |
| Contract | `32:223` | screen |
| Scope / Material added | `173:1238` | state of Scope |

## 04 / The daily loop

Section `30:2` · Phase U4

| Screen | Node | Build as |
| --- | --- | --- |
| Today | `30:5` | screen |
| Session | `30:83` | screen |
| Session saved | `30:125` | screen |
| Missed session | `30:177` | screen |
| Welcome back | `30:225` | screen |

## 05 / Everything around the session

Section `35:76` · Phase U5

| Screen | Node | Build as |
| --- | --- | --- |
| Plan | `35:79` | screen |
| Notes | `35:299` | screen |
| Renegotiate | `35:365` | screen |
| Witness view | `35:430` | screen |
| Settings | `35:469` | screen |

## 06 / Daily states and recovery

Section `36:105` · Phase U6

| Screen | Node | Build as |
| --- | --- | --- |
| Today / First session | `36:108` | state of Today |
| Session / First | `36:176` | state of Session |
| Session / First saved | `36:212` | state of Session |
| Today / Rest day | `36:259` | state of Today |
| Today / Empty | `36:318` | state of Today |
| Today / Offline | `36:368` | state of Today |
| Today / Loading | `36:429` | state of Today |
| Session / Paused | `36:475` | state of Session |
| Session / Leave confirmation | `36:516` | state of Session |
| Material / Unavailable | `36:550` | screen |
| Session / No units | `36:588` | state of Session |
| Missed / Rescheduled | `36:627` | state of Missed session |
| Missed / Let go confirmation | `36:674` | state of Missed session |
| Missed / Message queued | `36:713` | state of Missed session |
| Notes / Empty | `36:755` | state of Notes |
| Note / Detail | `36:805` | screen |
| Note / Recall | `36:840` | screen |
| Plan / History | `118:863` | state of Plan |
| Plan / Complete | `118:1009` | state of Plan |
| Today / All done | `36:1036` | state of Today |

## 07 / Account states

Section `37:227` · Phase U7

| Screen | Node | Build as |
| --- | --- | --- |
| Sign up / Validation | `37:230` | state of Sign up |
| Sign in / Error | `37:274` | state of Sign in |
| Account / Loading | `37:320` | screen |
| Google / Handoff | `37:352` | screen |
| Google / Cancelled | `37:392` | screen |
| Verify email / Expired | `37:423` | state of Verify email |
| Password / Email sent | `37:460` | screen |
| Password / Saved | `37:495` | screen |
| Account / Offline | `37:527` | screen |
| Sign out / Confirm | `37:561` | screen |

## 08 / Preferences, witnesses and changing the plan

Section `38:249` · Phase U8

| Screen | Node | Build as |
| --- | --- | --- |
| Appearance | `38:252` | screen |
| Settings / Session reminders | `38:308` | state of Settings |
| Settings / Reminders denied | `38:357` | state of Settings |
| Witness / Manage | `38:391` | screen |
| Witness / Pending | `38:440` | screen |
| Witness / Nudge sent | `38:484` | screen |
| Witness / Acknowledged | `38:516` | screen |
| Witness / Stop sharing | `38:548` | screen |
| Witness / Access ended | `38:579` | screen |
| Privacy & local data | `38:610` | screen |
| Adjust / Rhythm | `38:662` | screen |
| Adjust / Scope | `38:720` | screen |
| Adjust / Target date | `38:764` | screen |
| Adjust / Other | `38:802` | screen |
| Recommit | `38:862` | screen |
| Archive / Confirm | `38:899` | screen |
| Archive / Saved | `38:936` | screen |
| Data / Remove confirmation | `38:970` | screen |
| Witness / Remove confirmation | `38:1007` | screen |
| Witness / Invite | `38:1039` | screen |

## 09 / Validation and confirmations

Section `41:301` · Phase U9

| Screen | Node | Build as |
| --- | --- | --- |
| Contract / Holding | `41:304` | state of Contract |
| Recommit / Holding | `41:343` | state of Recommit |
| Recommit / Scope | `41:380` | state of Recommit |
| Recommit / Target | `41:417` | state of Recommit |
| Plan / Updated | `41:454` | state of Plan |
| Scope / Validation | `41:486` | state of Scope |
| Notes / No results | `41:524` | state of Notes |
| Plan / Load error | `41:578` | state of Plan |
| Witness / Offline invite | `41:610` | screen |
| Missed / Message sent | `41:642` | state of Missed session |
| Reminders / Enabled | `41:674` | state of Reminders |
| Legal & privacy | `41:706` | screen |
| Plan / Updated rhythm | `41:742` | state of Plan |

## 10 / Flow continuity

Section `44:327` · Phase U9

| Screen | Node | Build as |
| --- | --- | --- |
| Recommit / Scope holding | `44:330` | state of Recommit |
| Recommit / Target holding | `44:367` | state of Recommit |
| Contract / No witness | `44:404` | state of Contract |
| Contract / No witness holding | `44:442` | state of Contract |
| Session / Two units | `44:480` | state of Session |
| Today / Two units done | `44:532` | state of Today |
| Today / First done | `44:590` | state of Today |
| Plan / Updated scope | `44:648` | state of Plan |
| Plan / Updated target | `44:868` | state of Plan |
| Recommit / Other | `44:1088` | state of Recommit |
| Recommit / Other holding | `44:1125` | state of Recommit |
| Plan / First week | `44:1162` | state of Plan |
| Witness / Removed | `44:1427` | screen |

## 11 / Study tasks and notes

Section `89:492` · Phase U5

| Screen | Node | Build as |
| --- | --- | --- |
| Chapter | `89:495` | screen |
| Session / Tasks | `89:555` | state of Session |
| Note / New | `89:618` | screen |
| Chapter / Add task | `89:662` | sheet |

## 12 / Alerts and progress

Section `101:805` · Phase U5

| Screen | Node | Build as |
| --- | --- | --- |
| Alerts | `101:808` | screen |
| Progress | `101:927` | screen |

## 13 / Plans and creating

Section `117:832` · Phase U5

| Screen | Node | Build as |
| --- | --- | --- |
| Today / Create | `117:835` | sheet |
| Plan / Switch | `117:1033` | sheet |

## 14 / Profile and partners

Section `147:1099` · Phase U10

| Screen | Node | Build as |
| --- | --- | --- |
| Profile / Edit | `147:1102` | screen |
| Partners | `147:1179` | screen |
| Partner / Their plan | `147:1283` | screen |
| Partner / Hold each other | `147:1419` | sheet |
| Account / Delete | `191:1183` | screen |
| Account / Deleted | `191:1269` | screen |

## 15 / Reminders

Section `148:1108` · Phase U10

| Screen | Node | Build as |
| --- | --- | --- |
| Reminders | `148:1111` | screen |
| Reminder / New | `148:1239` | screen |
| Reminders / Swipe actions | `169:1142` | sheet |
| Reminders / Done | `169:1260` | state of Reminders |
| Reminder / Detail | `169:1386` | screen |

## 16 / Material and focus

Section `150:1113` · Phase U11

| Screen | Node | Build as |
| --- | --- | --- |
| Material / Add | `150:1116` | sheet |
| Material / Library | `150:1221` | screen |
| Reader / PDF | `150:1354` | screen |
| Player / Audio | `150:1433` | screen |
| Session / Choose mode | `150:1557` | sheet |
| Focus / Permission | `150:1647` | screen |
| Session / Focus on | `150:1720` | state of Session |

## 17 / Holdbuddy Pro

Section `170:1141` · Phase U12

| Screen | Node | Build as |
| --- | --- | --- |
| Pro / Paywall | `170:1144` | screen |
| Pro / Welcome | `170:1262` | screen |
| Today / Free with ad | `170:1326` | state of Today |

## 18 / Safety: mute, block, report

Section `206:1188` · Phase U10

| Screen | Node | Build as |
| --- | --- | --- |
| Safety / Options | `206:1196` | sheet |
| Safety / Report | `206:1342` | screen |
| Safety / Report sent | `206:1437` | screen |
| Safety / Block confirm | `206:1520` | sheet |
| Settings / Blocked people | `206:1648` | state of Settings |

## Components and pages

| Item | Node |
| --- | --- |
| H2 / Button | `29:14` |
| H2 / Field | `29:23` |
| H2 / Day | `29:28` |
| H2 / Navbar | `29:62` |
| Design system page | `28:123` |
| Dark page (verify only) | `28:122` |
| Flow map | `179:1183` |
| Website page | `184:1183` |
