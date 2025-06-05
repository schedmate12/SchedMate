SchedMate - Team-Friendly README (Extended Edition)
Purpose:
Provide a crystal-clear, no-jargon guide so that any teammate-developer,
designer, tester, project manager, or intern-can understand what SchedMate
does, why it matters, and how to get it running locally without breaking a sweat.
0. Why Should You Care?
Imagine you want a haircut on Saturday but don't have time to call around.
SchedMate lets you open a website, pick 3 PM, pay, and receive a reminder -
no phone tags or double-bookings.
1. Big Picture (Super-Short Version)
- Self-service booking: Customers choose time slots for any service.
- Payments & promos: Pay online and apply coupons or memberships.
- Auto reminders: Email/SMS so nobody forgets their slot.
- Video meetings: Optional Zoom link for virtual consultations.
- Normal web tech: Laravel server + MySQL database + Bootstrap pages.
Analogy: Think of Calendly + a cash register + email reminders, all rolled into
one.
2. End-to-End User Flow (Detailed)
Step | User Does | Tech Does
--- | --- | ---
1 | Sign Up - email & password | Stores hashed password in users table.
2 | Browse Services | Pulls list from services table.
3 | Pick Time | Checks bookings table for free slot.
4 | Pay | Sends charge to Stripe/PayPal; on success writes payments row.
5 | Confirmation | Sends email & SMS; locks slot.
6 | Reminder | Scheduler sends reminder messages.
7 | Review | Adds row to reviews table.
3. Codebase Map - Where to Look for What
SchedMate/
|- app/ # Laravel controllers, models, jobs
|- resources/views/ # Blade templates (HTML)
|- resources/js/ # JS helpers (jQuery, DataTables)
|- database/migrations/ # SQL table definitions
|- public/ # Browser-visible assets
|- routes/ # web.php & api.php
|- tests/ # PHPUnit tests
Tip: Search the folder name in your editor when lost.
4. Core Booking Engine (Plain English)
Like a super-organised receptionist:
- createBooking() - Stores row, marks slot busy.
- cancelBooking() - Frees slot, refunds if within policy.
- sendReminder() - Finds bookings in 24 h, dispatches SMS/email job.
- applyCoupon(code) - Looks up coupons, recalculates price.
Safety: No overlaps, payment verified before slot locks.
5. Database Tables - Explained with Examples
Table | Sample Row | Why It Matters
services | (12, "Haircut", 30 min, $40) | Lists offerings.
staff | (7, "Alice") | Who can deliver service.
bookings | (88, 12, 7, 2025-06-14 15:00) | Locks slot.
payments | (88, Stripe, paid, $40) | Money trail.
coupons | (SPRING10, 10 % off) | Promos.
6. Backend <-> External Services Bridge (Deep Dive)
1. Payment Webhooks - verify Stripe signature -> mark paid.
2. SMS/Email Queue - uses Vonage & SMTP, retries on failure.
3. Video Link - call Zoom API, store link in bookings.
4. Error Handling - write to failed_jobs table, alert ops.
7. NPM & Artisan Scripts Cheat Sheet
Script | What It Does
npm run dev | Builds assets with hot reload.
npm run build | Minifies JS/CSS.
php artisan migrate | Runs migrations.
php artisan queue:work | Starts job worker.
php artisan schedule:work | Runs scheduler nonstop.
8. Key Dependencies (Plain Words)
- Laravel - routes, security, DB.
- Bootstrap - responsive pages.
- jQuery & DataTables - list interactivity.
- Stripe & PayPal SDKs - secure payments.
- Vonage - SMS reminders.
- Zoom SDK - video meetings.
- PHPUnit - test runner.
9. Environment Variables - Examples
Var | Example | Without It?
APP_URL | https://book.myspa.com | Links in emails break.
DB_PASSWORD | s3cr3t | No DB connection.
STRIPE_SECRET | sk_live... | Payments fail.
VONAGE_KEY | abcd1234 | No SMS.
ZOOM_API_KEY | xyz456 | No video link.
10. Quick Local Setup
Option A (Docker):
docker compose -f infra/local-compose.yml up --build
Spins up MySQL, Redis, MailHog, Laravel app.
Option B (Manual):
git clone ... schedmate && cd schedmate
composer install && npm install
cp .env.example .env && php artisan key:generate
mysql -u root -p -e "create database schedmate"
php artisan migrate --seed
npm run dev & php artisan serve
11. Testing Playground
- php artisan test - unit & feature tests.
- php artisan dusk - browser tests.
12. Troubleshooting Cheatsheet
Problem | Fix
Stripe 400 error | Check webhook secret.
Email not sending | Confirm mail driver in .env.
Jobs stuck | Run queue worker; check Redis.
Images broken | Run php artisan storage:link.
13. Roadmap
- MVP launch (done)
- Staff mobile app (coming)
- Multi-location support (coming)
- Google Calendar sync (coming)
- AI no-show prediction (coming)
14. Getting Involved - First Contribution
Fork repo -> run setup -> pick "good first issue" -> branch -> code -> tests ->
PR -> celebrate!
15. Who to Ping
Topic | Slack Handle
Setup | @project-lead
Payments | @fin-dev
SMS/Email | @ops-support
