# CLAUDE.md
## Event Butler (Flutter Web + Serverpod) | Hackathon Build Plan (Serverpod Cloud, Serverpod 3)

IMP:
- Always use this master plan MD for reference and update it as you go with notes. Multiple AI agents and devs will use it.
- Only care about **Web**. No other platform.
- Most important: before ending any work session, ensure it builds and there are no errors.

Design:
- Use frontend design skill for frontend work.
- Keep UI clean, fast, and easy to scan.
- Use the inspiration folder when available.

Goal:
Ship a demo-ready MVP fast with minimum setup hassle.

Hosting:
Serverpod Cloud only (no local Postgres, no Docker).

---

## 1) Product goal (one sentence)
Event Butler helps users manage event **Tasks**, **Reminders**, and a shared **Shopping List**, with realtime updates and a Tasks chat that is tied to a specific shopping list.

---

## 2) Core UX (3 tabs)
### Tab 1: Shopping List
- Create or join a list
- Add items (name, qty, notes, category)
- Check off items
- Share list via invite token
- Realtime updates across users

### Tab 2: Tasks
- Tasks are linked to a specific shopping list (or a specific item inside that list)
- Each list has its own Tasks thread (simple chat style)
- Use it for coordination: “Who is buying ice?” “Add balloons”

### Tab 3: Reminders
- Create reminders for event actions
- Basic scheduling (date/time)
- Mark as done
- Optional: link reminder to a shopping list item

---

## 3) Hackathon demo success (2 to 3 minutes)
A judge should see this flow fast:
1) Sign in (or guest mode)
2) Create an Event Shopping List called “Birthday Party”
3) Add items: Cake, Candles, Plates
4) Share list via invite token with User B
5) Realtime: User B checks “Candles”, User A sees it instantly
6) Go to Tasks tab: open the chat for “Birthday Party” list
7) Send message: “I will get the cake. Can you pick candles?”
8) Go to Reminders tab: create reminder “Buy cake today 6pm”
9) Optional: show that reminder links to “Cake” item

---

## 4) Non-negotiable engineering rules
### Flutter (Web only)
- Use Provider only (ChangeNotifier + ChangeNotifierProvider).
- Widgets never call Serverpod endpoints directly.
- Widget -> Provider -> Service -> Serverpod client.
- Every screen must support these UI states:
  - loading
  - empty
  - error (human readable)

### Serverpod
- Never edit generated code.
- Keep all server/client/flutter package versions aligned.
- Every endpoint must check permissions for shared lists.
- All list-scoped data must be validated against membership.

---

## 5) Data model (minimum viable)
Keep this simple and ship.

### Entities
- User (built-in auth or simple guest identity)
- EventList
  - id, title, createdBy, createdAt
- EventListMember
  - listId, userId, role (owner/member)
- ShoppingItem
  - id, listId, title, qty (string), notes, isDone, updatedAt
- TaskMessage
  - id, listId, optional itemId, senderId, message, createdAt
- Reminder
  - id, listId, title, dueAt, isDone, optional itemId

### Key rule
- Tasks tab shows chat for a specific shopping list.
- If you have time: allow chat at item level too.
- For MVP: list-level chat is enough.

---

## 6) Permissions and sharing
### Invite token flow (simple)
- Owner generates invite token for a list
- User B enters token to join list
- Server validates token, adds member

### Permissions checks on every endpoint
- CanRead(listId): user must be a member
- CanWrite(listId): user must be a member
- OwnerOnly(listId): only owner can rotate invite token (optional)

---

## 7) Realtime (MVP)
Primary realtime target:
- Shopping list updates (add, toggle done, edit)
Nice to have:
- Tasks chat messages realtime
- Reminders realtime

Approach:
- Use Serverpod streams for list-scoped updates.

---

## 8) Cloud-first development workflow (least hassle)
We will not run Postgres locally.

### Initial setup (one-time)
- Claim hackathon Cloud plan (if applicable)
- Install CLIs:
  - `dart pub global activate serverpod_cli`
  - `dart pub global activate serverpod_cloud_cli`
- Login:
  - `scloud auth login`

### Day-to-day loop
- Code locally (Flutter Web + Serverpod server)
- Deploy backend when needed:
  - `scloud deploy`
- Use Cloud logs for debugging:
  - `scloud logs` (or Cloud dashboard)

---

## 9) Project structure (keep it predictable)
### Flutter
- /lib
  - /ui (screens, widgets)
  - /providers (ChangeNotifiers)
  - /services (API wrappers, stream helpers)
  - /models (UI models if needed)

### Server
- /server
  - /endpoints
    - list_endpoint
    - shopping_endpoint
    - tasks_endpoint
    - reminders_endpoint
  - /services
    - auth_service
    - permissions_service
    - invite_service

---

## 10) Screen checklist (MVP)
### Shopping List tab
- List picker: create list, join via token
- List details screen:
  - add item
  - toggle done
  - edit notes (optional)
  - share token button

### Tasks tab
- If no list selected: show empty state “Select a list”
- If list selected:
  - chat UI for that list
  - send message
  - show recent messages

### Reminders tab
- Create reminder form (title, date/time)
- List reminders
- Mark done

---

## 11) Build and quality gates (every session)
Before stopping:
- `flutter build web --base-href / --wasm --no-tree-shake-icons --output ../recipe_butler_server/web/app` (serve at root; preserves icons/fonts)
- no analyzer errors
- basic happy-path manual test:
  - create list
  - add item
  - toggle item
  - send task message
  - create reminder

---
## 12) Notes log (keep updated)
- Date:
- What changed:
- Issues:
- Next steps:

### Serverpod
- Never edit generated code.
- Keep all server/client/flutter package versions aligned.
- Every endpoint must check permissions for shared shopping lists.

---

## 4) Docs and setup links
- Serverpod: https://pub.dev/packages/serverpod
- Docs: https://docs.serverpod.dev/
- Serverpod Cloud: https://docs.serverpod.cloud/

Cloud CLI:
```bash
dart pub global activate serverpod_cloud_cli
scloud auth login
scloud launch
scloud deploy

Navigate to your serverpod project and run the following command.

```bash
scloud launch
```
Check Deployment Status
Verify the deployment by:

scloud deployment show

## 4) Cloud-first development workflow (least hassle)
We will not run Postgres locally.

### Initial setup (one-time)
- Claim hackathon Cloud plan: https://serverpod.dev/flutterbutler25
- Install CLIs:
  - `dart pub global activate serverpod_cli`
  - `dart pub global activate serverpod_cloud_cli`
- Login:
  - `scloud auth login`

### Day-to-day loop
- Code locally (Flutter + Serverpod server)
- Deploy backend when needed:
  - `scloud deploy`
- Use Cloud logs for debugging:
  - `scloud logs` (or Cloud dashboard)

Docs:
- Serverpod Cloud Getting Started: https://docs.serverpod.cloud/getting-started
- Serverpod main docs: https://docs.serverpod.dev/
- Streams (realtime): https://docs.serverpod.dev/concepts/streams
- Upgrade to v3: https://docs.serverpod.dev/upgrading/upgrade-to-three
