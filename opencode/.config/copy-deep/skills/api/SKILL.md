---
name: willow api 
description: >
  api endpoints to use when developing features, other api calls should be used only in special cases and you should ask user for confirmation
---


# Moneybox App — API Endpoint Reference

> Sourced from Android Retrofit API interfaces in `Moneybox.Android`.
> All endpoints are relative to the Moneybox API base URL.
> Parameters in `{curly braces}` are path params; `?param=` are query params.

**Tip:** When a screen looks wrong, check its ⭐ template/config endpoint first — it drives the layout. Then check the widget-specific data endpoints for the values shown.

---

## Authentication

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Email/password login | POST | `users/v2/login` |
| PIN login | POST | `users/v2/pinlogin` |
| Biometric login | POST | `users/biometriclogin` |
| Token login (auto re-auth) | POST | `users/tokenlogin` |
| Verify / get access token | POST | `users/verify/accesstoken` |
| Replace session | POST | `/users/replacesession` |
| Logout | POST | `/users/logout` |
| Post-login actions (dialogs/prompts) | GET | `user/after-login-actions` |

---

## User & Profile

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Get user profiles | GET | `users/profiles` |
| Get personal details | GET | `users/personal` |
| Update personal details | PUT | `users/personal` |
| Update user | PATCH | `users/{userId}` |
| Update email | PUT | `users/email` |
| Update address | PUT | `users/address` |
| Update child address | PUT | `users/children/{childId}` |
| Switch profile | POST | `users/switchprofile` |
| Unpause direct debit | POST | `users/unpausedirectdebit` |

---

## Home Tab

The Home tab is **template-driven** — the main template call defines which widgets appear in which order. Each widget then makes its own data call.

| Purpose | Method | Endpoint |
|---------|--------|----------|
| **Home tab layout template** ⭐ | GET | `/template/wrappergroupoverview` |
| All investor products (account list values) | GET | `investorproducts` |
| Recent activity / In progress | GET | `/willow/activities/recent` |
| Upcoming collection breakdown (banner) | GET | `/upcomingcollection/breakdown` |
| To-dos / onboarding checklist | GET | `insights/to-dos` |
| Onboarding hero module definition | GET | `/insights/to-dos/definitions/{key}` |
| Cards / banners (marketing, NBA, promos) | GET | `/insights/cards?UserId=&sets=&key=` |
| Mortgages hero module | GET | `mortgages/heromodule` |
| Dynamic content (modules, placements, screens) | — | See [Dynamic Content (CMS / Blueprint SDUI)](#dynamic-content-cms--blueprint-sdui) section below |
| Global CMS design tokens | GET | `willow/tokens/global` |
| User CMS tokens | GET | `willow/tokens/user` |

---

## Wealth Tab

| Purpose | Method | Endpoint |
|---------|--------|----------|
| **Wealth tab overview template** ⭐ | GET | `/willow/templates/wealth-overview` |
| Chart data (all charts) | GET | `willow/charting/{key}?` |
| Plan header widget | GET | `/willow/guidance/plan-header` |
| Plan action areas | GET | `/willow/guidance/action-areas` |
| Plan overview | GET | `/willow/templates/plan-overview` |
| Refresh plan state | POST | `/willow/guidance/refresh-plan-state` |
| Account options for a plan action | GET | `/willow/guidance/account-options/{actionGlobalId}` |
| Cross-sell cards (Wealth) | GET | `/insights/cards?UserId=&sets=&key=` |
| ISA contribution tracking (£20K tracker) | GET | `investment/wrappers/contribution-tracking` |

---

## Individual Product Pages (ISA, GIA, Simple Saver, Pension etc.)

The product page is **template-driven** — the template call defines which widgets appear. Each widget fetches its own data using the `wrapperGlobalId` (and optionally `assetBoxGlobalId`).

| Purpose | Method | Endpoint |
|---------|--------|----------|
| **Product page template (by wrapperType)** ⭐ | GET | `/willow/templates/product-page/{wrapperType}/{wrapperGlobalId}?assetboxGlobalId=` |
| **Product definitions template (by type)** ⭐ | GET | `/willow/templates/wrapper-definitions/{type}?wrapperGlobalId=` |
| Product overview content (header widget) | GET | `willow/featureconfiguration/product-overview?wrapperGlobalId=&assetBoxGlobalId=` |
| Product breakdown widget | GET | `willow/featureconfiguration/breakdown?wrapperGlobalId=&assetBoxGlobalId=` |
| Interest rate widget (Cash ISA, Simple Saver) | GET | `willow/feature/interest-rate?wrapperGlobalId=&assetBoxGlobalId=` |
| Investments summary (S&S ISA, GIA) | GET | `/willow/featureconfiguration/investments-summary?wrapperGlobalId=` |
| Portfolio holdings widget | GET | `willow/feature/product-portfolio?wrapperGlobalId=` |
| Product action buttons (Add money etc.) | GET | `/willow/feature/product-actions?wrapperGlobalId=&assetBoxGlobalId=&wrapperSet=` |
| More actions menu | GET | `/willow/feature/more-product-actions?wrapperGlobalId=&assetBoxGlobalId=&wrapperSet=` |
| Resources widget (links, guides) | GET | `willow/featureconfiguration/resources?wrapperGlobalId=&assetBoxGlobalId=` |
| Asset breakdown chart (per product) | GET | `/willow/insights/wrapper/asset-breakdown/{wrapperGlobalId}` |
| Asset breakdown (investor-level) | GET | `/willow/insights/investor/asset-breakdown` |
| Recurring deposit settings | GET | `willow/recurring-deposits/settings` |
| Upcoming rate change alerts | GET | `investment/wrapper/{wrapperDefinitionGlobalId}/upcoming-rate-change-alerts` |
| Tax year end tracking (contribution) | GET | `investment/wrappers/contribution-tracking` |
| Projection setup (edit projections) | GET | `willow/projections/setup/{wrapperGlobalId}` |
| Edit projections config | GET | `willow/featureconfiguration/edit-projections` |
| Product activities feed | GET | `willow/activities/wrapper/{wrapperGlobalId}?assetBoxGlobalId=` |
| Pension consolidation widget | GET | `/willow/feature/pension-consolidation` |
| Pension settings | GET | `/willow/feature/pension-settings` |
| Product settings (generic) | GET | `/willow/feature/product-settings?wrapperSet=` |
| Promo card (product page banner) | GET | `/insights/cards?UserId=&sets=&categories=&key=` |
| Portfolio insights template | GET | `/willow/templates/portfolio-insights/wrapper/{wrapperId}` |
| Investor portfolio insights | GET | `/willow/templates/portfolio-insights/investor` |

---

## Accounts & Services / Open New Account

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Available products (before registration) | GET | `product/available` |
| Available products (after registration) | GET | `product/crosssell` |
| Product cross-sell info | GET | `product/{assetBoxDefinitionGlobalId}/crosssell` |
| Fund account options | GET | `/investment/fundaccountoptions/{wrapperDefinitionGlobalId}` |
| Contribution limits | POST | `investment/contributionlimits` |

---

## Deposit / Add Money

| Purpose | Method | Endpoint |
|---------|--------|----------|
| One-off deposit | POST | `oneoffpayments` |
| Fund account options | GET | `/investment/fundaccountoptions/{wrapperDefinitionGlobalId}` |
| Collection breakdown | GET | `/upcomingcollection/breakdown` |
| Virtual bank account (push payment / bank transfer) | GET | `/investment/virtual-bankaccount/{wrapperId}?productOpening=` |

---

## Move Money & Transfers

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Can move money check | GET | `/movemoney/{wrapperId}` |
| Transfer limits & providers | GET | `investment/transfer/product/{wrapperDefinitionGlobalId}/limitsandproviders` |
| Submit ISA transfer in | POST | `investment/transfer` |
| Update ISA transfer | PUT | `investment/transfer/{TransferInGlobalId}` |
| Incomplete transfers list | GET | `/investment/{type}` (e.g. `/investment/transfer`) |
| Transfer-in feature config | GET | `willow/feature/transfer-in/{productType}?wrapperGlobalId=` |

---

## Discover Tab

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Mortgages hero module | GET | `mortgages/heromodule` |
| Tax year summary | GET | `discovery/{assetboxglobalid}/thistaxyearsummary` |
| Available goals | GET | `/willow/goals/available?goalTypes=` |
| Goal suggestions content | GET | `/willow/goals/content/suggestions` |
| Goal overview templates | GET | `/willow/templates/goals/{type}` |
| Dynamic content (For You tab) | — | See [Dynamic Content (CMS / Blueprint SDUI)](#dynamic-content-cms--blueprint-sdui) section below |

---

## Settings Tab

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Personal details (name, DOB, address) | GET | `users/personal` |
| Linked bank accounts (Round-ups) | GET | `roundups/open-banking/consents` |
| Recurring deposit settings | GET | `willow/recurring-deposits/settings` |
| Update email | PUT | `users/email` |
| Update address | PUT | `users/address` |

---

## Onboarding

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Get onboarding tutorial tips | GET | `/onboarding` |
| Mark onboarding step seen | POST | `/onboarding/{id}` |

---

## Dynamic Content (CMS / Blueprint SDUI)

These endpoints power any screen or widget whose layout and content is defined in **Contentful** and rendered at runtime using the **Blueprint SDUI** component system. They are used across multiple tabs (Home, Discover, and others) wherever the app displays CMS-driven UI.

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Dynamic content module — fetches a single CMS-driven module by `contentKey`; response is a Blueprint SDUI component tree | GET | `willow/content/module/{contentKey}` |
| Dynamic content placement — fetches one or more CMS-driven modules for a named placement slot (e.g. a Home tab card zone); `?refresh=` forces a fresh CMS fetch; rendered as Blueprint SDUI | GET | `willow/content/{placementId}/?refresh=` |
| Dynamic content screen — fetches a full CMS-driven screen definition by `contentKey`; the entire screen layout and all components are authored in Contentful and rendered using Blueprint SDUI | GET | `willow/content/screen/{contentKey}` |
| Dismiss a dynamic content module | POST | `willow/content/module/{contentKey}/dismiss` |

---

## Flows Framework

The Flows Framework powers multi-step user journeys (onboarding, product opening, KYC, etc.). Flows are identified by `{type}` (flow category) and `{name}` (specific flow). There are two API variants in the Android codebase — the newer `flows.engine` module (with `context` and token params) and the older `decisionengine` module (with `wrapperGlobalId`). Both share the same endpoint shape.

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Fetch initial flow state — returns step content and transition rules for the first (or current) step | GET | `willow/flows/{type}/{name}?context=&wrapperGlobalId=` |
| Submit step answer / advance flow — POST step response body to move to the next step | POST | `willow/flows/{type}/{name}?context=` |
| Save flow state (persist without advancing) — saves current step state server-side without transitioning | POST | `willow/flows/save/{type}/{name}?context=` |

**Path params:**

- `{type}` — flow category (e.g. `onboarding`, `product`, `kyc`)
- `{name}` — specific flow identifier (e.g. `cash-isa`, `registration`)

**Key query params:**

- `context` — stringified JSON context object passed with GET and POST calls (newer `flows.engine` module)
- `wrapperGlobalId` — product wrapper ID (older `decisionengine` module)
- `tokens` — additional key-value token map (newer module, GET only)

---

## Shared / Cross-cutting

| Purpose | Method | Endpoint |
|---------|--------|----------|
| Cards/banners (any screen) | GET | `insights/to-dos` / `/insights/cards` |
| Delete a card/banner | DELETE | `cards/{id}` |
