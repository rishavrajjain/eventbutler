# AGENTS.md
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
After deploy, use Cloud logs for debugging. 

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
- `flutter build web --base-href / --wasm --no-tree-shake-icons --output ../recipe_butler_server/web/app` (serve at root with icons/fonts intact)
- no analyzer errors
- basic happy-path manual test:
  - create list
  - add item
  - toggle item
  - send task message
  - create reminder

---
## 12) Notes log (keep updated)
- Date: 2026-01-27
- What changed: Shopping list categories are now user-managed (add/rename/remove, persisted locally). Category shelf moved above add bar; add button now “+”. Dynamic sections built from user categories; default “My Items”. Added Reminders tab (middle): list upcoming/completed reminders across lists, create via + modal (title, list, date/time), toggle done, delete. Backend: new `reminder` table + RemindersEndpoint CRUD deployed to Serverpod Cloud.
- Issues: Category presets remain client-local; reminders currently list-only notifications (no push/cron).
- Next steps: Consider server-backed category presets & ordering; add realtime reminders stream or push; link reminders to specific items; add snooze.

- Date: 2026-01-27
- What changed: Tasks chat now listens to Serverpod message streams for realtime updates; added “add to shopping list” icon + modal inside Task chat screen; noted Redis/Upstash requirements.
- Issues: Streams stay silent until Redis is enabled/configured in Serverpod Cloud (Upstash host/port/password not yet applied).
- Next steps: Configure Redis env (host, port, password) in Cloud, redeploy server, and smoke-test multi-user chat & item adds.

- Date: 2026-01-27
- What changed: Enabled Redis in production/staging configs to point at Upstash (`settling-eagle-57111.upstash.io:6379`, TLS, password = `$REDIS_PASSWORD`). No secret committed; expects Cloud secret.
- Issues: Must set secret before deploy or server startup will fail.
- Next steps: Run `scloud secret create --name REDIS_PASSWORD --from-value <token>` then `scloud deploy` so message streams (tasks + shopping) work in cloud.

- Date: 2026-01-27
- What changed: Created Cloud secret `REDIS_PASSWORD` with provided Upstash token and deployed project `recipebutler` to Serverpod Cloud (includes Redis-enabled configs).
- Issues: None observed; verify runtime connectivity in Cloud logs to ensure Redis TLS connection succeeds.
- Next steps: Smoke-test realtime chat and shopping updates with two users; monitor Cloud logs for Redis connection; add reconnection handling if needed.

- Date: 2026-01-27
- What changed: Client now opens Serverpod streaming connection during init and TasksProvider auto-retries stream subscriptions with backoff if the socket closes/errors, so chat/list updates should stay live without reopening screens.
- Issues: `dart format` failed locally due to sandbox write limits (engine.stamp). Not rerun.
- Next steps: Validate realtime chat across two clients; if formatter still blocked, run `dart format lib/services/serverpod_client_service.dart lib/providers/tasks_provider.dart` outside sandbox or after fixing permissions.

- Date: 2026-01-27
- What changed: Added fallback polling in TasksProvider (5s) whenever streams fail/close, stopping once realtime events arrive. This keeps chat updating even if Redis/websocket is flaky.
- Issues: Need to confirm Serverpod Cloud Redis connectivity to eliminate stream errors altogether.
- Next steps: Check cloud logs for Redis errors and redeploy if needed; otherwise the client will still auto-poll.

- Date: 2026-01-27
- What changed: Server `_postEvent` for shopping and tasks now uses Redis only when a Redis controller is available; otherwise broadcasts locally (single-instance friendly). Prevents crashes when Redis is disabled/misconfigured while keeping global fan-out when Redis is up.
- Issues: Redis still not connecting in Cloud (log shows “Redis needs to be enabled”). Need to set prod Redis password/enable in Cloud or accept single-instance local broadcasts.
- Next steps: Add `REDIS_PASSWORD` secret in Cloud and redeploy; or keep single-instance mode.

- Date: 2026-01-27
- What changed: Deployed project `recipebutler` to Serverpod Cloud (deploy id 3a710854-bf75-46b2-8172-11a15f4b8a8a finished SUCCESS 18:09 IST). Redis secret already exists in Cloud (`REDIS_PASSWORD`); runtime logs after deploy show clean startup (no Redis-disabled warnings).
- Issues: None observed post-deploy; need live chat test to confirm streams.
- Next steps: Smoke-test chat with two browsers; watch `scloud log --project recipebutler --tail` for any Redis publish errors during chat.

- Date: 2026-01-27
- What changed: Added Butler AI toggle in task chat; integrates Gemini to suggest shopping items/reminders. AI replies encoded as `[BUTLER_JSON]{...}` are rendered as action cards with add-to-cart and add-reminder buttons. New `GeminiService` calls Gemini flash with structured prompt. Build succeeded after changes.
- Issues: AI key is inline for hackathon; move to secret if hardening. `dart format` not run (sandbox block).
- Next steps: Live test AI flow with two browsers; consider persisting AI userId or badge; move Gemini key to env/secret.

- Date: 2026-01-27
- What changed: Ran flutter analyze (clean) and dart analyze on server (clean). Built web bundle. Deployed latest build to Serverpod Cloud (deploy id bd64732e-575c-4963-80a6-c2d0b8285d90, finished 18:41 IST).
- Issues: Insights serviceSecret warning persists (known; Insights disabled). Gemini key still inline client-side.
- Next steps: Promote Gemini key to cloud secret; live test AI cards + realtime add-to-cart/reminder; consider fixing serviceSecret if Insights needed.

- Date: 2026-01-27
- What changed: Verified deployment success for build 1.0.5+6.
- Issues: None.
- Next steps: Live test web app.

- Date: 2026-01-27
- What changed: Butler AI toggle icon switched to magic wand (no Butler logo). Client now falls back to calling Gemini directly when server returns 500, using `--dart-define=GEMINI_API_KEY=...` during `flutter run` to keep AI working in local web runs without server secrets.
- Issues: None observed locally; fallback requires supplying the dart-define.
- Next steps: Run `flutter run -d chrome --dart-define=GEMINI_API_KEY=your_key` to validate AI cards; consider moving key to Serverpod password/secret for cloud use.

- Date: 2026-01-27
- What changed: AI endpoints and client fallback now return a friendly Butler card instead of error when Gemini rate limits (429). Butler AI cards also use the magic-wand icon. `flutter analyze` and `dart analyze recipe_butler_server` are clean.
- Issues: 429 still indicates quota/rate-limit; user must wait or use a higher-quota key.
- Next steps: Validate AI card rendering after 429, monitor Cloud logs for remaining AI errors, and consider client-side throttling.

- Date: 2026-01-27
- What changed: Premium Butler AI UX overhaul. Created `OPENAI_API_KEY` secret on Serverpod Cloud. Enhanced task chat with: animated typing indicator while AI works, empty state with contextual hints, AI-mode composer (warm background, wand send button, mode banner), premium Butler cards (gradient header, shadow, "Add all" batch button for shopping, green checkmark states for added items/reminders, tappable suggestion tiles). Upgraded AI system prompts on server and client to elite event-planner persona with current UTC time context. Auto-scroll on new messages. Both analyzers clean, web build succeeded.
- Issues: None; redeploy needed for server prompt improvements to take effect.
- Next steps: `scloud deploy` to push updated server AI prompts; live-test AI flow end-to-end with OpenAI; verify "Add all" batch operations.

- Date: 2026-01-27
- What changed: Removed all Gemini fallbacks. Server AI endpoint now OpenAI-only with clearer logging and descriptive errors when the OpenAI response is non-200 or the key is missing. Client ButlerService no longer tries local Gemini; only local OpenAI fallback remains.
- Issues: `dart format` on touched files failed due to Flutter engine.stamp permission (sandbox); code left formatted manually.
- Next steps: Confirm `OPENAI_API_KEY` secret exists in Serverpod Cloud, remove any `GEMINI_API_KEY` secrets, redeploy (`scloud deploy`), and smoke-test AI chat to ensure the rate-limit message now references OpenAI only.

- Date: 2026-01-27
- What changed: Added JSON-parse guard in AiEndpoint to return a friendly message instead of 500 when OpenAI returns malformed JSON. Uploaded Firebase service account to Serverpod Cloud password store as `firebaseServiceAccountKey`. New deploy (87973a5e-b01a-4dc8-a0ed-0c57c7a92dd2) running to pick up the secret.
- Issues: Deployment still progressing at time of note; Firebase IdP errors expected to clear once pods restart with the secret.
- Next steps: After deploy finishes, tail logs to confirm “Firebase Service Account Key present” and that `firebaseIdp.login` no longer errors; re-test Firebase login.

- Date: 2026-01-27
- What changed: Switched OpenAI model to `gpt-5-mini` for both server AI endpoint and client local fallback.
- Issues: None in analyzers/build; deployment in progress.
- Next steps: Verify deploy success, smoke-test Butler AI responses with new model.

- Date: 2026-01-27
- What changed: Butler AI now calls OpenAI Responses API first, falls back to Chat Completions. Removed unsupported params for gpt-5-mini (no `temperature`; token fields: `max_output_tokens` / `max_completion_tokens`). Increased token budgets to 600 and tightened prompt to concise, high-value replies. Added graceful error messages instead of 500s on non-200 responses.
- Issues: Insights serviceSecret warning persists (expected with Insights off).
- Next steps: If AI errors reappear, check logs for params; ensure `OPENAI_API_KEY` quota is sufficient.

- Date: 2026-01-27
- What changed: Fixed critical auth 404 bug. The web client was deriving API URL from `Uri.base.origin`, which returned `recipebutler.serverpod.space` (web-serving domain) instead of `recipebutler.api.serverpod.space` (Serverpod API). Changed `_resolveBaseUrl()` in `auth_provider.dart` to always return the fixed `.api` subdomain URL.
- Issues: None after fix.
- Next steps: Always use the hardcoded API URL; never derive from browser origin on Serverpod Cloud.

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
