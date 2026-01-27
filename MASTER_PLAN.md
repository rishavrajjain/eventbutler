# Event Butler (formerly Recipe Butler) - Master Implementation Plan (Web Only)

> **Status**: In Progress  
> **Last Updated**: 2026-01-27  
> **Rule**: Use ✅ for completed tasks

---

## MVP Scope (locked)
- Auth (sign in) OR Guest mode with device id if auth slows us down
- 3 tabs: Recipes, Butler Chat, Shopping (opens directly to active list detail, no list index)
- Recipe save + list + detail
- Import recipe from URL (server endpoint)
- Butler chat (simple MVP ok)
- Shopping lists:
  - create list
  - add items manually
  - add items from recipe
  - checkbox items
  - open directly into active list detail (auto-create default list on first open)
  - **categorize items into sections**
  - **default “My items” section at top**
- Share shopping list via invite token
- Realtime shopping list updates (Serverpod Streams)
  - **realtime must preserve category sections + ordering**
  - **two users see changes instantly without refresh**

Out of scope:
- Collections
- Reminders
- Comments chat attached to shopping list
- iOS/Android specific work (this plan is Web only)

---

## Event Butler pivot (2026-01-27)
- Product goal: pair shared shopping lists with per-list **Task Chats** (one chat thread per list) for fast event coordination.
- Scope change: Recipes tab replaced by **Tasks**; branding now Event Butler.
- Backend: `task_message` table + `TasksEndpoint` (migration `20260127062037516`) broadcasting `taskAdded` over shopping list stream.
- Frontend: Tasks tab renders one chat per shopping list with send composer; shopping tab unchanged.
- Deployment: new migration + endpoint need cloud deploy.

## Reminders (2026-01-27)
- Backend: `reminder` table + `RemindersEndpoint` (list/add/toggle/delete) deployed to Serverpod Cloud.
- Frontend: Middle nav tab “Reminders” shows upcoming & completed reminders across lists; + button opens sheet (title, list picker, date/time); toggle done, swipe to delete.
- Sorting: upcoming by dueAt, completed after upcoming.
- Persisted per shopping list; permissions follow list membership/edit rules.

---

## UI Target (Shopping List)
- Sectioned list with badges; **My Items** always present; other categories are user-created and ordered by creation.
- Category shelf sits above the add-item composer (chips with add/rename/remove).
- Add composer shows “Adding to <category>” and a big `+` button; category picker moved out of the text field row for more space.
- Each section shows items with check circles; badge shows unchecked count.
- Optional later: collapse/expand sections.

---

## Category System (current)
- Default category key: `my`.
- Additional categories are **user-managed client-side**, persisted locally (SharedPreferences) and synced onto items when used.
- Users can add, rename, and remove categories; removing reassigns affected items to `my`.
- Item payload still stores `category` string; server accepts any string (validated by membership only).
- Sorting inside a category: unchecked first, then checked, then by id (current implementation).

---

## PHASE 0: Project Setup (Serverpod Cloud)
- [✅] **0.1** Install Serverpod CLI (`serverpod_cli`, `serverpod_cloud_cli`)
- [✅] **0.2** Create Serverpod project, move `recipe_butler_server/` and `recipe_butler_client/` into project root
- [✅] **0.3** Configure `generator.yaml` (`client_package_path: ../recipe_butler_client`)
- [✅] **0.4** Deploy to Cloud: `scloud auth login && scloud launch` (project: `recipebutler`)
- [✅] **0.5** Record deployed server URL for Flutter client config  
  - API: https://recipebutler.api.serverpod.space/

---

## PHASE 1: Flutter Web Scaffolding (3 tabs)
- [✅] **1.1** Update `pubspec.yaml` dependencies (provider + serverpod + http + firebase)
- [✅] **1.2** Create `lib/theme/app_theme.dart`
- [✅] **1.3** Create `lib/services/serverpod_client_service.dart` (Client init + session manager)
- [✅] **1.4** Create `lib/providers/auth_provider.dart`
- [✅] **1.5** Create stub providers for MVP: `recipes`, `shopping_lists`, `butler_chat`
- [✅] **1.6** Create stub services for MVP: `recipe`, `shopping_list`, `invite`, `butler_chat`
- [✅] **1.7** Common widgets: `LoadingWidget`, `EmptyStateWidget`, `ErrorStateWidget`
- [✅] **1.8** Create `lib/app.dart` (theme + auth gated routing)
- [✅] **1.9** Create `HomeScreen` with BottomNavigationBar: Recipes, Butler Chat, Shopping Lists
- [✅] **1.10** Rewrite `main.dart` (Firebase.init + MultiProvider)
- [✅] **1.11** Auth UI: `AuthScreen` (email, Google, guest)

---

## PHASE 2: Auth (Firebase + Serverpod 3) + Web sanity
- [✅] **2.1** Add `serverpod_auth_idp_server` (template)
- [✅] **2.2** Configure server auth init (`initializeAuthServices`) with JWT + Email IDP + Firebase IDP
- [✅] **2.3** Implement endpoint classes: JwtRefreshEndpoint, EmailIdpEndpoint, FirebaseIdpEndpoint
- [✅] **2.4** Configure `config/passwords.yaml` secrets (JWT, peppers, refresh peppers)
- [✅] **2.5** Generate + migrate + deploy
- [✅] **2.6** Client auth flow implemented:
  - Firebase sign-in -> get idToken -> `firebaseIdp.login` -> `authManager` updated
  - Sign out hooks added
  - Guest mode supported
- [✅] **2.7** Set `firebaseServiceAccountKey` in Serverpod Cloud secrets (recipebutler)
- [ ] **2.8** Web test checklist:
  - [ ] Email sign-up works on web
  - [ ] Email sign-in works on web
  - [ ] Google sign-in works on web
  - [ ] Sign out clears sessions properly


## PHASE 5: Shopping Lists (Models + Endpoints + UI)
### 5A: Core shopping list
- [✅] **5.1** Models: ShoppingList, ShoppingItem, ShoppingListMember
- [✅] **5.2** Generate + migrate + deploy
- [✅] **5.3** ShoppingEndpoint:
  - createShoppingList
  - listMyShoppingLists (owned + shared)
  - listShoppingItems
  - addShoppingItem
  - toggleShoppingItem
  - permission checks: view/edit/owner
- [✅] **5.4** Flutter: ShoppingListService + ShoppingListsProvider
- [✅] **5.5** UI:
  - Shopping tab now opens directly to ShoppingListDetail (no list index)
  - Auto-creates default list on first open, can switch lists inline
  - Items render with add, toggle, category change, share/join actions

### 5B: Categorization (fix broken list UX)
Goal: list is sectioned like the reference screenshot and stays correct in realtime.

Backend:
- [✅] **5.8** Add `category` field to `ShoppingItem` (string key)
  - default: `my` (server-side fallback)
- [ ] **5.9** Generate + migration + deploy

Endpoints:
- [✅] **5.10** Update `addShoppingItem(listId, text, category?)`
  - if null -> `my`
- [✅] **5.11** Add `updateShoppingItemCategory(listId, itemId, category)`
- [ ] **5.12** Update `addItemsFromRecipe(listId, recipeId)` to assign category (simple keyword mapping)
  - dairy keywords: milk, cheese, butter, yogurt
  - produce keywords: onion, garlic, tomato, spinach, etc
  - spices keywords: salt, pepper, cumin, chilli, etc
  - else other
- [ ] **5.13** Deploy categorization endpoints changes

Flutter UI:
- [✅] **5.14** Add category picker to “Add item” UI (chips or dropdown)
  - default selected: `my`
- [✅] **5.15** Render items grouped by category sections with header + count badge (client-side heuristic grouping until backend category field ships)
  - “My items” must always be first
- [✅] **5.16** Add “Change category” action on an item (optional but recommended)
  - uses `updateShoppingItemCategory`

---

## PHASE 6: Sharing (Invite Tokens) + UI
- [✅] **6.1** Model: Invite (token unique, role, expiry, acceptedAt)
- [✅] **6.2** Generate + migrate + deploy
- [✅] **6.3** Endpoints:
  - createInvite(listId, role) -> token
  - acceptInvite(token) (idempotent membership upsert)
- [✅] **6.4** Share UI:
  - add a share button to the shopping list detail screen
  - generate token
  - copy to clipboard
  - simple “Share this token” section in list detail
- [✅] **6.5** Accept invite UI:
  - token input screen
  - join success -> open list

---

## PHASE 7: Realtime Shopping List (Serverpod Streams) - MUST HAVE
Goal: two users see the same list update instantly, including category section placement + item ordering.

Stream channel:
- One channel per list: `shopping_list_<listId>`

Event types (keep payload small but sufficient):
- `itemAdded` { item }
- `itemToggled` { itemId, isChecked, updatedAt, updatedByUserId }
- `itemUpdated` { itemId, category?, text? }
- (optional) `batchAdded` { items[] } for add-from-recipe

Server:
- [✅] **7.1** Add stream setup for shopping list channel per listId
- [✅] **7.2** Broadcast on:
  - add item
  - toggle item
  - update category
  - add items from recipe (prefer batch)
- [ ] **7.3** Deploy stream changes

Flutter:
- [✅] **7.4** Subscribe when ShoppingListDetail opens
- [✅] **7.5** Apply events to provider cache (no full refresh)
- [✅] **7.6** Ensure deterministic ordering after each event:
  - within category: unchecked first, then checked
  - tie-break: createdAt then id
- [ ] **7.7** Verify with two browsers:
  - User A and User B on same shared list
  - toggle syncs instantly without refresh
  - new items appear under correct category
  - “My items” stays at top

Docs: https://docs.serverpod.dev/concepts/streams

Fallback (only if blocked):
- Poll `listShoppingItems` every 2 seconds while screen open (temporary)

---

## PHASE 8: Butler Chat (Tab 2)
MVP options:
- Option A (better): store messages in DB
- Option B (fastest): no DB, just server returns a reply string

- [ ] **8.1** Decide chat storage:
  - [ ] Option A: DB messages
  - [ ] Option B: stateless replies
- [ ] **8.2** Implement endpoint:
  - sendMessage(text) -> replyText
  - listMessages (only if Option A)
- [ ] **8.3** Flutter: ButlerChatService + ButlerChatProvider
- [ ] **8.4** ButlerChatScreen UI:
  - message list
  - input + send
  - loading + error state

---

## PHASE 9: Shopping list cateogy
- remove pre saved cateories,show default as my items, allow people to add remove and rename their cateories, save any cateogry they create so they can just click to mark it, change ui also a bit put cateogy selection thing above typing space so typing space has more space also just keep it + instead of "Add +"
-----

## PHASE 10: Task Chats (Event pivot)
- [✅] **10.1** Model: `TaskMessage` table + migration `20260127062037516`
- [✅] **10.2** Endpoint: `TasksEndpoint` (list/add) posting `taskAdded` to shopping list stream
- [✅] **10.3** Flutter: TasksProvider + TaskService + Tasks tab (one chat per shopping list)
- [ ] **10.4** Realtime apply: hook `ShoppingListEvent.task` into client stream handling
- [ ] **10.5** Demo flow update: highlight Tasks + Shopping (no recipe import)

---

## Progress Summary

| Phase | Name | Status |
|------:|------|--------|
| 0 | Project Setup | ✅ Complete |
| 1 | Flutter Web Scaffolding | ✅ Complete |
| 2 | Auth (Firebase + Serverpod) | ✅ Code complete, web tests pending |
| 3 | Recipes | ✅ Complete |
| 4 | URL Import | ✅ Complete |
| 5A | Shopping Lists Core | ✅ Core complete (wire add-from-recipe pending) |
| 5B | Shopping Categorization | ⏳ Category column + picker shipped; migration deploy pending; recipe-mapping pending |
| 6 | Sharing | ✅ Backend + UI complete |
| 7 | Realtime Streams | ⏳ Server + client streaming wired; dual-browser verification pending; deploy pending |
| 8 | Butler Chat | ❌ Not started |
| 9 | Polish & Demo | ❌ Not started |
| 10 | Task Chats (pivot) | ⏳ Backend + Tasks tab shipped; realtime wiring + deploy pending |

---

## Build Status (Web only,keep updating)
- Flutter analyze: Pass (2026-01-27, after Tasks pivot)
- Flutter build web: Pass (2026-01-27)
- Server analyze: Pass (2026-01-27)
- Cloud deploy: 2026-01-27 (`task_message` migration + TasksEndpoint)

---

## Key Files (quick map)
Server:
- `recipe_butler_server/lib/server.dart` (init, auth)
- `recipe_butler_server/lib/src/recipes/recipe_endpoint.dart`
- `recipe_butler_server/lib/src/shopping/shopping_endpoint.dart`
- `recipe_butler_server/lib/src/import/import_endpoint.dart`
- `recipe_butler_server/lib/src/auth/firebase_idp_endpoint.dart`

Flutter:
- `lib/services/serverpod_client_service.dart`
- `lib/providers/auth_provider.dart`
- `lib/providers/recipes_provider.dart`
- `lib/providers/shopping_lists_provider.dart`
- `lib/providers/butler_chat_provider.dart`
- `lib/screens/home/home_screen.dart`
- `lib/screens/auth/auth_screen.dart`

---

## Deployment
- Server URL: https://recipebutler.api.serverpod.space/
- Project: `recipebutler` (Serverpod Cloud)
- Deploy:
  - `cd recipe_butler_server && scloud deploy`
- Pending deploy: `shopping_item.category` migration + shopping list stream changes (`20260126200031584`) **and** new task chat migration `20260127062037516` + `TasksEndpoint`
