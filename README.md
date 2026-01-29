 # Event Butler 📅🤖
**Real-time event planning with teams, vendors, and reminders in one place.**

- **Live demo:** https://recipebutler.serverpod.space (temporary hackathon URL)
- **Demo video:** [Watch Demo](https://youtu.be/pHJ4FsjsyPU)

---

## Inspiration

Planning an event breaks in the same place: coordination.

Last month during our company offsite, the headcount was updated in too many places: Notes, WhatsApp, and a spreadsheet. The caterer brought food for fewer people than we had, and we had to fix it at the last minute.

**Event Butler** keeps the plan, the people, and the reminders in one place, so everyone stays in sync.

---

## What it does

Event Butler breaks an event into focused workspaces (lists) like **Food**, **Games**, and **Venue**. Each list is its own workspace with separate tasks, chat, and collaborators.

### Key features
- **Focused workspaces:** Separate items, separate chat, separate collaborators. Less noise.
- **AI Butler suggestions:** Type a prompt like *“BBQ catering for 30 people, outdoor event”* and get suggested tasks plus smart reminders.
- **Vendor collaboration (with access control):** Invite an external vendor into a specific list (for example, the caterer joins Food). They only see what they need to see.
- **Real-time sync:** Updates happen instantly across clients, no refresh needed.
- **Unified reminders:** A single reminders view that aggregates deadlines from all lists so nothing slips.

---

## How it’s built

### Frontend
- **Flutter Web**

### Backend
- **Serverpod (Dart backend)**
  - **Auth:** Email and Google Sign-In (and optional guest flow)
  - **WebSocket streams:** real-time chat and task updates
  - **Future calls:** scheduled reminder workflows (and other time-based automation)
  - **Type safety:** shared models drive backend + client code generation

### Deployment
- **Serverpod Cloud**
  - Hosted backend + database + SSL with a simple deploy flow

---

## Demo flow (what judges will see)

1. Create an event and make three lists: **Food**, **Games**, **Venue**
2. Open **Food**
3. Ask **AI Butler** for: *“BBQ catering for 30 people, outdoor event”*
4. Add suggested items with one tap
5. Share invite code and join as **Joe’s BBQ**
6. Send a message from Joe, watch it appear instantly for the organizer
7. Show that Joe can only access **Food**
8. Open **Reminders** and show the unified view
9. Create one reminder (and show email option if enabled)

---

## The pivot (Recipe → Event)

You may notice the demo URL uses `recipebutler.serverpod.space`.

This project started as **RecipeButler**, focused on catering coordination. While building, it became clear that catering issues are usually a symptom of a bigger problem: event planning is fragmented across too many tools.

So the product evolved into **Event Butler**, covering the full event workflow (Food, Venue, Games, and more). The URL stayed as a temporary hackathon detail.

---

## Challenges

- **Real-time permissions:** Ensuring a vendor invited to Food cannot access other private lists required strict access checks on every request and stream subscription.
- **Cross-role UX:** Keeping the UI simple for vendors while still powerful for organizers.
- **First full-stack build:** I’ve built Flutter apps for 4 years, and this is my first deep backend build. Serverpod helped by keeping the entire stack in Dart and generating a lot of boilerplate.

---

## What’s next

- **Payments inside lists:** Stripe payment links for vendor deposits and invoices.
- **Calendar sync:** Two-way sync with Google Calendar and Outlook.
- **Templates:** Reusable event templates (“Butler Blueprints”) for common event types.
- **Smarter AI:** Suggestions that adapt to guest count, budget, and context across lists.

---

## Links

- **Live demo:** https://recipebutler.serverpod.space
- **Demo video:** [Watch Demo](https://youtu.be/pHJ4FsjsyPU)

---

## Built with

Flutter Web + Serverpod + Serverpod Cloud

