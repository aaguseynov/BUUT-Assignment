# Architecture (why it is built this way)

Short notes to explain decisions in interviews. Simple English on purpose.

---

## Big picture

The app splits into four ideas:

1. **What the business cares about** (domain) — not JSON, not UI.
2. **Where data comes from** (data) — network, DTOs, mapping.
3. **What the user sees** (presentation) — view models, screens, copy.
4. **Who navigates** (composition) — coordinators + DI.

They stay separate so you can change the API, the UI toolkit, or tests without breaking everything at once.

---

## Application layer

**Role:** App launch only: window, scene, and starting the root coordinator.

**Why:** `SceneDelegate` / `AppDelegate` stay thin. No business logic here — only wiring.

---

## Coordinators

**Role:** Flows: which screen to show, push/pop, child flows.

**Why:**

- View controllers do not decide “what happens next in the app.”
- **Parent vs child:** list is the main flow; detail is a **child** coordinator. The parent keeps the child until the flow finishes (`onComplete`).
- **`UIViewController.onClose`** (with swizzling) fires when the screen leaves the stack — a clear “flow ended” signal, not only the back button.

**Trade-off:** More files than putting all navigation in one place — you get clear flow boundaries and predictable lifetime of child coordinators.

---

## Dependency injection (DI)

**Role:** `DIContainer` + `Assembly` — wire protocols to real types.

**Why:**

- Classes depend on **protocols** (`LocationsRepositoryProtocol`, …), not concrete HTTP code. Easy to mock in tests.
- **Child container** for a feature: register feature services on top of the parent (e.g. reuse one `NetworkClient`).

This is **Dependency Inversion**: high-level modules do not depend on low-level details; both depend on abstractions.

---

## Feature module (`Input` / `Output`)

**Role:** The feature’s public boundary: commands in, events out.

**Why:** The parent (coordinator) talks to **module.output**, not inside view controllers. For the list feature, **output is a protocol** implemented by the **same object as the view model** — one place for state + outgoing events, no extra “event bus” until you need it.

---

## Domain

**Role:** `Location`, repository **protocol**, **use cases** (e.g. fetch locations).

**Why:**

- **`Location`** is stable app language — not tied to JSON field names.
- **Repository protocol** says *what* you load, not *how* (HTTP vs cache vs mock).
- **Use case** is one application scenario — one class, one job. If tomorrow the scenario needs two repositories or rules, it grows here, not inside a huge repository.

---

## Data

**Role:** Endpoints, DTOs, **mappers**, repository implementation, error text helpers.

**Why:**

- **DTO ≠ domain model** — API shape can change without renaming your whole app.
- **Mapper** owns rules like trim, default name, `id` string — not the view model.
- **Repository** is the single place that talks to the network and returns domain types.
- **`Task.checkCancellation`** in async code supports cooperative cancel with the view model’s `Task`.

---

## Presentation

**Role:** View models (behind protocols), view controllers, row models (`LocationListItemViewData`), strings, formatting.

**Why:**

- **Protocols for VMs** — the screen depends on an interface; tests use mocks.
- **Strings** (`LocationsListStringsProviding`) — copy/localization separate from state logic.
- **List row mapping** (`LocationsListItemMapping`) — list line format differs from detail; each has its own small mapper.
- **Coordinate formatting for detail** (`LocationCoordinatesFormatting`) — formatting rules are not buried inside the VM.
- **Explicit states** (loading / loaded / empty / failed) + diffable collection model — UI gets a clear render model.
- **Load task + generation + cancel** — avoid updating UI with stale responses after a new request or cancel.

---

## Shared UI components

**Role:** Diffable collection + overlays (loading, error, empty).

**Why:** Reuse list behavior; feature screens stay thin.

---

## One sentence for interviews

*“Domain describes the problem, data talks to the outside world, presentation translates to the screen, coordinators own navigation, and DI connects interfaces to implementations — so each part can change with minimal ripple.”*

---

## Short FAQ (interview pushback)

| Question | Short answer |
|----------|----------------|
| Too many layers? | Layers match **reasons to change**. JSON changes often; business meaning of “location” changes rarely — so DTO and domain stay split. |
| Why use case if there is a repository? | Use case = **app scenario**. Repository = **data access**. Tomorrow one scenario may use two repos or extra rules. |
| Why coordinator? | Keeps **flow order** and **child flow lifetime** out of view controllers. |
| Why is output on the view model? | One object owns list state **and** outgoing events; can split later if the feature grows. |
