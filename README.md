# Ticketing

A backend for browsing events and purchasing tickets, built to demonstrate real backend engineering concerns — not just CRUD — with Phoenix/Ecto.

## Domain

```
Venue --< Event --< TicketType --< Order >-- User
```

- **Venue** — a physical location, `has_many :events`.
- **Event** — happens at a venue, `belongs_to :venue`.
- **TicketType** — a category of ticket for an event (e.g. "General Admission", price + available quantity), `belongs_to :event`. This is where inventory lives.
- **User** — an account, with a hashed password and token-based sessions.
- **Order** — a user's purchase of N tickets of a given type, `belongs_to :user` and `belongs_to :ticket_type`.

## What this project is actually demonstrating

**1. Concurrency-safe inventory (`Ticketing.Orders.purchase_tickets/3`).**
The core risk in any ticketing system: two people buying the last available ticket at the same instant must not both succeed. This is solved by folding the "is there enough stock" check and the decrement into a *single atomic SQL statement* (`UPDATE ticket_types SET quantity = quantity - N WHERE id = ? AND quantity >= N`), rather than a read-then-write with a gap in between. The inventory decrement and the order creation are wrapped in `Ecto.Multi` + `Repo.transaction/1`, so either both happen or neither does — no state where inventory was taken but no order exists, or vice versa.

`cancel_order/1` uses the same pattern in reverse, with its own atomic guard (`WHERE status = 'confirmed'`) to prevent a double-cancel from refunding inventory twice.

Both are covered by automated tests in `test/ticketing/orders_test.exs`, including a test that fires 10 concurrent purchase attempts at 5 available tickets via `Task.async_stream` and asserts exactly 5 succeed.

**2. Password auth done deliberately, not by feel.**
`Ticketing.Accounts` hashes passwords with `bcrypt_elixir` (never stores plaintext), and `User.valid_password?/2` includes a timing-attack defense — a nonexistent user still runs a dummy hash comparison (`Bcrypt.no_user_verify/0`), so "wrong password" and "no such account" aren't distinguishable by response time.

**3. Token-based sessions, not cookies.**
Since this is a JSON API (not a server-rendered app), sessions are opaque random tokens (`UserToken`, 32 bytes via `:crypto.strong_rand_bytes/1`) issued at login and sent as `Authorization: Bearer <token>` on subsequent requests — checked by a custom Plug (`TicketingWeb.Plugs.RequireUser`) before any protected controller action runs.

**4. Authentication vs. authorization, kept distinct.**
The Plug answers "who is this" (authentication). `OrderController.delete/2` separately checks "is this *their* order" before allowing a cancel (authorization) — being logged in isn't enough to cancel someone else's order.

## API

| Method | Path | Auth required | Purpose |
|---|---|---|---|
| `GET`  | `/api/events` | no | List events |
| `GET`  | `/api/events/:id` | no | Show one event |
| `POST` | `/api/sessions` | no | Log in, returns a session token |
| `POST` | `/api/orders` | yes | Purchase tickets (`ticket_type_id`, `quantity`) |
| `DELETE` | `/api/orders/:id` | yes | Cancel an order you own |

## Running it

```
mix setup
mix phx.server
```

Tests: `mix test`.

## Known gaps, deliberately deferred

- **Order expiry.** Orders go straight to `"confirmed"` — there's no `"pending"` reservation window with an expiry (e.g. release tickets back to inventory if unpaid after N minutes). Would need a background job (`Oban`, or a `GenServer` timer).
- **Session token expiry/revocation.** Tokens don't expire and there's no logout endpoint yet.
- **Roles/admin.** Any authenticated user can create events/ticket types via direct context calls — there's no admin-only route separation.
