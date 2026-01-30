# Event Butler 📅🤖

**Real-time event coordination for teams and vendors.**
**Separate workspaces for each part of an event, plus one Reminders timeline so nothing gets missed.**

- **Live demo:** https://recipebutler.serverpod.space  
- **Demo video:** https://youtu.be/pHJ4FsjsyPU  

---

## 💡 Inspiration

Last month I helped organize my company’s team outing.

We had:
- a shared notes doc
- a group chat with 200 messages
- three different calendar apps

We forgot a lot of things. It was chaos.

The problem was not “writing tasks is hard”.
The problem was **coordination**: the plan gets split across tools, updates don’t reach everyone, and follow-ups slip.

That’s why I built **Event Butler**.

---

## 🚀 What it does (demo flow)

Event Butler turns one messy plan into focused **Workspaces**.

### 1) Workspaces per event area
For a team outing, I create separate workspaces like:
- **Food**
- **Games**
- **Venue**

Each workspace has **separate items, separate chat, separate collaborators** so people only see what they need.

### 2) Sign-in that matches real sharing
I can sign in via **email**, **Google**, or **guest mode**, using Serverpod auth.

### 3) AI Butler to kickstart planning
Inside a workspace, I ask:

> “Barbecue catering for thirty people, outdoor event.”

The Butler returns **shopping suggestions** and **reminder suggestions**.
I add items like **plates** and **ice packs** with one tap, and they show up in the **Shopping List** tab.

### 4) Invite vendors into only what they should see
I share a join token with a caterer (example: Joe).
Joe opens the app in a browser, signs in, and joins the **Food** workspace.

Now the vendor collaborates with us, but **only on what they have to see**.

**No WhatsApp. No email chains. The vendor is in the list.**

### 5) Reminders that run on the server
I set a reminder like “Confirm catering order”.
It appears in the **Reminders** tab.

When it’s due, Event Butler sends an **email automatically** using Serverpod **Future Calls** (scheduled tasks on the server).

---

## 🧩 Why this is different

Most to-do apps assume everyone is internal.

Real events include **external vendors**, and you can’t expose your full private plan to them.

Event Butler solves this with:
- **Workspace isolation**
- **Vendor-safe collaboration**
- **One reminders timeline** across all workspaces

---

## 🛠 How it’s built

### Frontend
- **Flutter Web**

### Backend
- **Serverpod (Dart framework)**
  - **Auth**: email, Google sign-in (Firebase), and guest mode (Serverpod auth docs: https://docs.serverpod.dev/concepts/authentication)
  - **Real-time**: streams over WebSockets for live collaboration (streams docs: https://docs.serverpod.dev/concepts/streams)
  - **Automation**: **Future Calls** to schedule reminders and emails (scheduling docs: https://docs.serverpod.dev/concepts/scheduling)
  - **Type-safe**: shared models and generated client APIs (overview: https://docs.serverpod.dev/overview)

![Event Butler Interface](https://i.ibb.co/4xbnhvq/okbroo.png)

### Deployment
- **Serverpod Cloud**
  - Deployed without managing Docker, servers, or a database manually (Serverpod Cloud docs: https://docs.serverpod.cloud/)

![Serverpod Cloud](https://i.ibb.co/fV9j5p7V/Screenshot-2026-01-29-at-3-41-12-PM.png)

---

## 🔄 The Pivot (Recipe to Event)

You may notice the demo URL is `recipebutler.serverpod.space`.

This started as **RecipeButler**, focused on catering coordination.
While building it, I realized catering issues are usually a symptom of a bigger problem: **the whole event plan is scattered**.

So the architecture expanded into **workspaces + vendors + reminders**, and it became **Event Butler**.
The URL stayed the same during the hackathon.

---

## 🧠 Challenges & learnings

- **Workspace permissions**
  Vendors must be limited to their workspace, including real-time updates, so access checks had to be strict.

- **First backend build**
  I have strong Flutter experience, but this was my first full backend build.
  I learned server-side logic, schema changes, and real-time infrastructure.

- **Structured AI output**
  Getting consistent outputs that map cleanly into shopping items and reminders took iteration, but it made the UX much faster.

---

## 🏅 Accomplishments we’re proud of

- Workspaces that reduce noise and keep collaboration focused.
- Vendor-safe access so external people only see what they need.
- Real-time collaboration for tasks and updates.
- A unified Reminders view that keeps deadlines on track.

---

## 🔮 What’s next

- **Agentic reminder workflows**
  Reminders won’t just notify.
  When a reminder fires, Event Butler can run a server action using AI plus MCP-style tools to execute workflows.

- **Integrated payments**
  Let vendors send invoices and collect deposits inside their workspace.

- **Blueprint templates**
  One-click workspace sets for weddings, hackathons, corporate offsites.

- **Calendar sync**
  Push Butler reminders to Google Calendar and Outlook.

---

## 🧰 Built with

- Flutter  
- Dart  
- Serverpod  
- PostgreSQL  
- OpenAI API  
