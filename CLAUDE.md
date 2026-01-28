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
- **To Deploy**:
  1. Bump version in `pubspec.yaml`
  2. Build: `flutter build web --base-href / --wasm --output ../recipe_butler_server/web/app`
  3. Deploy: `cd recipe_butler_server && scloud deploy`
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

## 11) Deployment Protocol (Follow Exactly)

> [!CAUTION]
> **READ THIS ENTIRE SECTION BEFORE DEPLOYING. Past mistakes have caused hours of debugging.**

### Project Structure (CRITICAL)
```
/Users/rishavrajjain/code/recipe_butler/     <-- Flutter app root (run flutter commands HERE)
├── lib/                                      <-- Flutter source code
├── pubspec.yaml                              <-- Version is defined HERE
├── recipe_butler_server/                     <-- Serverpod server (subdirectory, NOT sibling)
│   └── web/
│       └── app/                              <-- Web build output goes HERE
└── recipe_butler_client/                     <-- Generated client
```

**KEY INSIGHT**: `recipe_butler_server` is INSIDE `recipe_butler`, NOT a sibling folder. This affects all path references.

---

### Step 1: Version Bump (CRITICAL)
- **Why**: Serverpod Cloud caches heavily. You MUST bump the version to force users to see new changes.
- **File**: `/Users/rishavrajjain/code/recipe_butler/pubspec.yaml`
- **Action**: Increment `version`: e.g., `1.3.1+3` → `1.3.2+4`

---

### Step 2: Build Flutter Web

> [!IMPORTANT]  
> **Output path is `recipe_butler_server/web/app` (NOT `../recipe_butler_server/web/app`)**

**Command** (run from `/Users/rishavrajjain/code/recipe_butler`):
```bash
flutter build web --base-href / --wasm --no-tree-shake-icons --output recipe_butler_server/web/app
```

**VERIFY BEFORE DEPLOYING**:
```bash
cat recipe_butler_server/web/app/version.json
```
This MUST show the new version you set in pubspec.yaml. If it shows an old version:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Rebuild with the command above
4. Check version.json again

**Common Mistakes**:
| Mistake | Result | Fix |
|---------|--------|-----|
| Using `../recipe_butler_server/web/app` | Build goes to wrong location outside project | Use `recipe_butler_server/web/app` (no `../`) |
| Not running `flutter pub get` after version bump | Old version baked into build | Run `flutter clean && flutter pub get` first |
| Building from wrong directory | Path resolution fails | Always `cd /Users/rishavrajjain/code/recipe_butler` first |

---

### Step 3: Deploy to Cloud

**Command** (run from `/Users/rishavrajjain/code/recipe_butler/recipe_butler_server`):
```bash
cd recipe_butler_server && scloud deploy
```

Or from the Flutter root:
```bash
cd /Users/rishavrajjain/code/recipe_butler/recipe_butler_server && scloud deploy
```

**Check deployment status**:
```bash
scloud deployment show --project recipebutler
```

Wait until all 4 stages show ✅:
- Booster liftoff
- Orbit acceleration
- Orbital insertion
- Pod commissioning

---

### Step 4: Verify Live Deployment

1. **Check version.json online**: https://recipebutler.serverpod.space/version.json
   - Must show the new version number
   
2. **Hard Refresh the app**: https://recipebutler.serverpod.space/
   - Mac: `Cmd + Shift + R`
   - Windows: `Ctrl + Shift + R`
   - Or: Open DevTools → Right-click refresh → "Empty Cache and Hard Reload"

3. **If still seeing old version**:
   - Try incognito/private window
   - Wait 2-3 minutes for CDN propagation
   - Re-check version.json

---

### Quick Reference Commands (Copy-Paste Ready)

```bash
# Full deployment from scratch (run from /Users/rishavrajjain/code/recipe_butler)
flutter clean && flutter pub get && flutter build web --base-href / --wasm --no-tree-shake-icons --output recipe_butler_server/web/app && cat recipe_butler_server/web/app/version.json && cd recipe_butler_server && scloud deploy
```

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
- AI (Butler):
  - Model: gpt-5-mini. Use Responses API first, fallback to Chat Completions.
  - Supported params: no `temperature`; use `max_output_tokens` / `max_completion_tokens` (set to 600).
  - Prompt: concise, high-value replies; JSON only.
  - Errors: return friendly message on non-200 instead of throwing 500; check Cloud logs if issues.
- **API URL (CRITICAL)**: Always use hardcoded `https://recipebutler.api.serverpod.space/` (the `.api` subdomain). Never derive URL from `Uri.base.origin` on Serverpod Cloud – the web app is served from a different subdomain than the API.

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
To check BE logs: cd /Users/rishavrajjain/code/recipe_butler && scloud log --project recipebutler --since 5m --limit 120
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
