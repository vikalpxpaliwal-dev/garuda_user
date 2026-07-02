# Garuda User App — Architecture & Design Review

**Reviewer lens:** Senior Flutter architect (Clean Architecture, feature-first modules, BLoC, testability, production readiness)  
**Scope:** `lib/` (~147 Dart files)  
**Date:** July 2026

---

## Executive Summary

The project has a **solid foundation**: feature folders, repository pattern, use cases, GetIt DI, `Result<T>` error handling, and GoRouter with auth redirects. Search and auth flows are reasonably structured.

The main risks are **concentration of complexity** in a few files, **layer leaks**, **mock/dead code mixed with production paths**, and **almost no automated tests**. The graph analysis flagged `ProfileBloc` as the highest-connectivity node (34 edges) — it has become an application hub instead of a focused presentation controller.

| Severity | Count | Theme |
|----------|-------|-------|
| Critical | 5 | God files, security, mock data in UI |
| High | 8 | SRP violations, layer boundaries, feature coupling |
| Medium | 7 | Duplication, dead code, placeholder data |
| Low | 4 | Naming, minor consistency |

---

## What Is Working Well

1. **Feature-based folder layout** — `auth`, `home`, `search`, `profile` with `data / domain / presentation`.
2. **Repository abstraction** — domain interfaces with `Result<T>` instead of throwing into UI.
3. **Central DI** — `service_locator.dart` wires dependencies in one place.
4. **Auth routing** — `GoRouter` + `AuthBloc` refresh stream for guarded navigation.
5. **Search data pipeline** — `LandModel → LandEntity → LandMapper → UI` is the right direction.
6. **ApiService wrapper** — Dio isolated behind an interface.

---

## Critical Issues

### 1. God Page — `profile_page.dart` (~4,051 lines)

**Violation:** Single Responsibility Principle (SRP), separation of concerns, maintainability.

One file contains:
- Page state and business-ish UI state (`_selectedTab`, `_cartLandIds`, visit date/time)
- Multiple private enums
- UI mappers (`_ProfileWishlistMapper`, `_ProfileAvailabilityMapper`, …)
- Dozens of private widgets (`_JourneyCard`, `_AvailabilityArrowButton`, …)
- Navigation and Bloc orchestration

**Impact:** Impossible to review, test, or reuse. High merge-conflict risk. New developers cannot navigate the feature.

**Files:** `lib/features/profile/presentation/pages/profile_page.dart`

---

### 2. God BLoC — `ProfileBloc` (~606 lines, 16 use cases)

**Violation:** SRP, Interface Segregation, feature cohesion.

`ProfileBloc` handles:
- Profile update / logout / delete account (auth domain)
- Wishlist, availability, cart, payment, visits, shortlists, finals (6+ sub-domains)

`ProfileState` has **15+ status enums** and **40+ fields** — a single mega-state object.

**Impact:** Any change to cart affects wishlist tests. State updates are error-prone. Bloc becomes the bottleneck for the entire buyer journey.

**Files:**
- `lib/features/profile/presentation/bloc/profile_bloc.dart`
- `lib/features/profile/presentation/bloc/profile_state.dart`
- `lib/core/di/service_locator.dart` (16 constructor injections)

---

### 3. Presentation Layer Imports Data Layer

**Violation:** Dependency Rule (Clean Architecture — dependencies point inward only).

| File | Imports |
|------|---------|
| `login_page.dart` | `auth/data/models/login_request_model.dart` |
| `signup_page.dart` | `auth/data/models/signup_request_model.dart` |
| `login_event.dart` | `login_request_model.dart` |
| `signup_event.dart` | `signup_request_model.dart` |
| `profile_sections.dart` | `profile/data/models/property_mock_data.dart` |

**Impact:** UI is coupled to API JSON shape. Refactoring models breaks presentation. Cannot swap data sources without touching widgets.

---

### 4. Mock / Dead Code in Production Paths

**Violation:** Production readiness, YAGNI discipline.

- `property_mock_data.dart` drives UI in `profile_sections.dart`
- `new_profile_page.dart` exists with **6 TODO stubs** but is **not routed** in `app_router.dart`
- `search_listing_catalog.dart` is **never imported** (dead code)
- Home dashboard is **hardcoded local mock** only (`home_local_data_source.dart`)
- Placeholders in UI: `'2 DAYS AGO'`, `'Pending'`, `'YET TO BE VERIFIED'`

**Impact:** Users see fake data. Two parallel profile implementations confuse the team.

---

### 5. Security — Token Logged to Console

**Violation:** Security best practice.

```dart
// auth_interceptor.dart
print('AccessToken: $token');
```

**Impact:** Tokens visible in debug logs / device logs. Must be removed before any release.

---

## High-Priority Issues

### 6. Network Layer Depends on Presentation (`AuthBloc`)

`AuthInterceptor` calls `sl<AuthBloc>().add(UserLoggedOut())` on refresh failure.

**Violation:** Layer inversion. Infrastructure should not know about UI state management.

**Better:** Emit auth session event via `AuthRepository` / `AuthSessionNotifier` / stream that `AuthBloc` listens to.

---

### 7. Service Locator Inside Interceptor

`AuthInterceptor` uses `sl<>()` for lazy resolution.

**Violation:** Hidden dependencies, hard to test, circular DI risk (already noted in comments).

**Better:** Constructor-inject `AuthRepository` + `TokenRefreshCoordinator` + `Dio`.

---

### 8. Wishlist Split Across Features

- **Add** wishlist → `SearchRepository` / `SearchBloc`
- **Get** wishlist → `ProfileRepository` / `ProfileBloc`

**Violation:** Feature boundary / domain cohesion. Wishlist is a shared buyer concept, not a search-only or profile-only concern.

**Impact:** Duplicate land models (`LandEntity` vs `WishlistLandEntity`), sync issues, duplicated status tracking in `SearchState` and `ProfileState`.

---

### 9. Duplicate `ProfileBloc` Instances Lose State

`app_router.dart`:
- Profile tab: `sl<ProfileBloc>()..add(WishlistRequested())`
- Edit profile route: **new** `sl<ProfileBloc>()` with no shared state

**Violation:** Single source of truth for user journey state.

**Impact:** Edits on edit-profile screen do not reflect in profile tab until manual refresh.

---

### 10. `SearchBloc` Passed Through Route `extra`

```dart
SearchListingDetailArgs(land: land, searchBloc: searchBloc)
```

**Violation:** Fragile navigation contract; breaks deep links and web URLs.

**Better:** Provide `SearchBloc` at shell level or use `BlocProvider.value` from a parent route scope.

---

### 11. Oversized Widget Files

| File | Lines | Issue |
|------|-------|-------|
| `profile_sections.dart` | 990 | Sections + mock binding |
| `search_listing_card.dart` | 890 | Card + artwork painters |
| `search_listing_detail_page.dart` | 735 | Header + properties + media |
| `search_filter_panel.dart` | 581 | Filter UI + API mapping |

**Violation:** Widget composition principle — screens should compose, not contain everything.

---

### 12. Thin Pass-Through Use Cases

Example: `GetWishlistUseCase` only calls `_repository.getWishlist()`.

**Not always wrong**, but with 20+ identical wrappers the indirection adds boilerplate without business rules.

**Recommendation:** Keep use cases where validation/composition exists; consider merging trivial reads or using repository directly until logic appears.

---

### 13. Repeated Repository Error Mapping

Every `*RepositoryImpl` repeats the same `try/catch` + `AppException` → `Failure` mapping (~15 lines × N repositories).

**Violation:** DRY.

**Fix:** `BaseRepository.execute(() async { ... })` helper or extension on `Future`.

---

## Medium-Priority Issues

### 14. `LandModel` API Adapter Complexity

Custom `_readTrees`, root-level `tree` vs nested `trees`, `mortage_availability_status` typo — mapping logic is scattered and defensive.

**Risk:** Silent empty data when API shape changes (already happened with trees).

**Fix:** Dedicated `LandApiMapper` + contract tests with real API JSON fixtures.

---

### 15. Local UI State Duplicates Bloc State

`SearchPage`: `_selectedWishlistLandIds`  
`ProfilePage`: `_selectedLandIds`, `_cartLandIds`, `_selectedVisitDate`

Some of this belongs in Bloc/Cubit for testability and persistence across rebuilds.

---

### 16. `paymentStatus: 'pending'` Hardcoded in Bloc

```dart
// profile_bloc.dart
paymentStatus: 'pending',
```

Business constant embedded in presentation layer.

---

### 17. No Automated Tests Beyond Default Scaffold

Only `test/widget_test.dart` exists. No bloc, repository, or mapper tests.

---

### 18. `main.dart` Storage-Clear TODO Left in Code

Commented `clear()` calls are dangerous if uncommented accidentally.

---

### 19. Inconsistent `Result` Handling Style

Some handlers use `if (result is Success)`, others use `switch (result)`. Standardize on pattern matching.

---

## Low-Priority / Polish

### 20. Theme tokens used inconsistently

Some widgets use raw `Color(0xFF...)` while `AppColors` exists.

### 21. `AuthBloc` registered as `LazySingleton`, feature Blocs as `Factory`

Intentional but undocumented — team should agree lifecycle rules per bloc type.

### 22. `search_listing_catalog.dart` dead mock data

Safe to delete or move to `test/fixtures/`.

### 23. File naming: `get_availability_usecase.dart` vs `get_availabilities` API

Minor confusion for discoverability.

---

## Recommended Target Architecture

```
lib/
  core/           # shared infra only
  features/
    auth/
    lands/        # shared: LandEntity, wishlist add/get (future)
    search/       # search UI + filters only
    profile/      # split into sub-features or blocs:
      wishlist/
      availability/
      cart/
      visits/
      account/
    home/
```

**Rules to enforce:**
1. `presentation` → `domain` only (never `data`)
2. Max ~300 lines per page file; extract widgets to `presentation/widgets/`
3. One bloc per user journey stage (or Cubit for simple CRUD)
4. No `print` / mock data in production widgets
5. Every repository method has at least one unit test

---

## Phase-Wise Fix Plan (with AI Prompts)

Use these prompts **in order**. Complete and verify each phase before starting the next.

---

### Phase 1 — Security & Production Hygiene (1–2 days)

**Goals:** Remove security risks, placeholders, and dead debug code.

#### Prompt 1.1 — Remove token logging and debug leaks
```
Scan lib/ for print/debugPrint statements that log tokens, passwords, or full API responses. Remove them. In auth_interceptor.dart replace token logging with silent handling. Ensure no PII is logged in ApiLoggerInterceptor for production builds. Use kDebugMode guards if logging is needed only in debug.
```

#### Prompt 1.2 — Clean main.dart and temporary test code
```
Remove the TODO block in main.dart that clears AuthLocalDataSource and SharedPreferences. If a dev-only reset is needed, gate it behind a --dart-define=RESET_STORAGE flag and document it in README. Do not run storage clear by default.
```

#### Prompt 1.3 — Replace hardcoded placeholder UI strings with real data or honest empty states
```
In search_listing_card.dart, search_listing_detail_page.dart, and land_mapper.dart replace hardcoded '2 DAYS AGO', 'Pending', and 'YET TO BE VERIFIED' with values from LandEntity/API (createdAt, updatedAt, verification fields). If API does not provide a field, show '—' or 'Not available' instead of fake data. Add formatting helpers for relative dates.
```

**Exit criteria:** No token prints; no fake timestamps; no storage-clear TODO in main.

---

### Phase 2 — Fix Layer Boundaries (2–3 days)

**Goals:** Presentation stops importing data models; network layer stops depending on Blocs.

#### Prompt 2.1 — Decouple AuthInterceptor from AuthBloc
```
Refactor auth_interceptor.dart so it does not import or call AuthBloc. Inject AuthRepository via constructor. On refresh failure, call authRepository.clearSession() or a new AuthSessionController.notifyLoggedOut(). Update AuthBloc to listen to that signal and emit unauthenticated state. Update service_locator.dart accordingly. Add unit test for refresh-failure path.
```

#### Prompt 2.2 — Remove data models from presentation (auth)
```
Create domain-level input types (e.g. LoginCredentials, SignupCredentials) in auth/domain/entities or auth/domain/models. Update LoginBloc/SignupBloc events to use domain types. Map to LoginRequestModel/SignupRequestModel only inside auth/data layer (repository or data source). Remove data imports from login_page.dart, signup_page.dart, login_event.dart, signup_event.dart.
```

#### Prompt 2.3 — Centralize repository error handling
```
Create core/data/repository_executor.dart (or similar) with a generic Future<Result<T>> runSafely<T>(Future<T> Function() action) that maps AppException to Failure. Refactor SearchRepositoryImpl, ProfileRepositoryImpl, AuthRepositoryImpl, HomeRepositoryImpl to use it. Keep behavior identical; reduce duplication.
```

**Exit criteria:** `grep` shows no `features/*/data/` imports under `presentation/`; interceptor has zero Bloc imports.

---

### Phase 3 — Split Profile God Classes (4–6 days)

**Goals:** Break the 4k-line page and 16-use-case bloc into maintainable units.

#### Prompt 3.1 — Extract widgets from profile_page.dart
```
Split lib/features/profile/presentation/pages/profile_page.dart into:
- profile_page.dart (orchestration only, target <200 lines)
- widgets/profile_wishlist_panel.dart
- widgets/profile_tracking_panel.dart
- widgets/profile_visits_hub.dart
- widgets/profile_journey_card.dart
- mappers/profile_ui_mappers.dart (move _ProfileWishlistMapper, _ProfileAvailabilityMapper, _ProfileOwnedLandMapper)

Keep public API and behavior identical. No logic changes yet. Run flutter analyze.
```

#### Prompt 3.2 — Split ProfileBloc by sub-domain
```
Refactor ProfileBloc into focused blocs/cubits:
- WishlistBloc (get wishlist)
- AvailabilityBloc (create + get availability)
- CartBloc (create + get cart)
- VisitsBloc (create + get visits)
- ShortlistBloc (shortlist + finals CRUD)
- AccountBloc or keep profile update/logout/delete in ProfileBloc (3 auth use cases only)

Each gets its own state file with minimal fields. Update profile_page.dart to use MultiBlocProvider. Update service_locator.dart. Migrate events/handlers without changing API contracts.
```

#### Prompt 3.3 — Fix ProfileBloc scoping in router
```
Provide a single ProfileBloc (or the new sub-blocs) at the profile shell branch level in app_router.dart so ProfilePage and EditProfilePage share the same instance. Remove duplicate BlocProvider create on edit-profile route; use existing provider or BlocProvider.value. Verify profile update reflects immediately on profile tab.
```

**Exit criteria:** No file over 800 lines in profile presentation; ProfileBloc (or successor) has ≤5 use cases each.

---

### Phase 4 — Unify Domain & Remove Mock UI (3–5 days)

**Goals:** One source of truth for lands/wishlist; production data only.

#### Prompt 4.1 — Consolidate wishlist under shared domain
```
Move addToWishlist from SearchRepository to ProfileRepository (or new WishlistRepository in profile/domain). Update AddToWishlistUseCase to use profile domain. SearchBloc should call the profile/wishlist use case via DI, not search repository. Align WishlistLandEntity with LandEntity where possible or add a shared LandSummaryEntity in core/domain. Remove duplicate wishlist tracking from SearchState if ProfileBloc/Cubit becomes source of truth after add.
```

#### Prompt 4.2 — Remove mock property data from presentation
```
Delete usage of property_mock_data.dart from profile_sections.dart. Wire EnquiryCard, PropertySelectionCard, and cart sections to ProfileBloc/CartBloc state from real API. If new_profile_page.dart is unused, delete it and profile_sections mock bindings OR route to it intentionally — pick one profile implementation. Remove dead search_listing_catalog.dart or move to test/fixtures.
```

#### Prompt 4.3 — Integrate Home with API (or flag as demo)
```
Replace HomeLocalDataSource hardcoded banners with HomeRemoteDataSource + API endpoint. If API is not ready, add explicit DemoHomeDataSource behind flavor/dev flag so production builds cannot ship mock contact numbers. Document in code which mode is active.
```

#### Prompt 4.4 — Stabilize Land API mapping
```
Create lib/features/search/data/mappers/land_api_mapper.dart. Move tree/mortgage/status parsing out of LandModel custom readers into explicit fromApiJson handling. Add test/fixtures/land_sample.json with real API payloads and unit tests for LandModel.fromJson covering tree[], mortage_availability_status, land_sale_available_status, and total_value formatting inputs.
```

**Exit criteria:** No mock data imports in `lib/features/**/presentation/**`; wishlist add/get in same repository.

---

### Phase 5 — Navigation, Testing & Hardening (4–7 days)

**Goals:** Test coverage, stable navigation, long-term maintainability.

#### Prompt 5.1 — Fix Search detail navigation
```
Remove SearchListingDetailArgs.searchBloc requirement. Provide SearchBloc at search branch level in app_router.dart (similar to HomeBloc). Use go_router path params or extra only for land id; load detail via bloc/state or lightweight GetLandByIdUseCase if needed. Ensure deep link to search/details works without manual bloc passing.
```

#### Prompt 5.2 — Add test pyramid baseline
```
Add tests:
- test/features/search/data/models/land_model_test.dart (JSON fixtures)
- test/features/search/presentation/utils/land_mapper_test.dart
- test/features/search/presentation/bloc/search_bloc_test.dart (bloc_test)
- test/features/profile/presentation/bloc/wishlist_bloc_test.dart (after Phase 3 split)
- test/core/network/auth_interceptor_test.dart (mock AuthRepository)

Use mocktail. Target 60%+ coverage on domain + bloc layers first.
```

#### Prompt 5.3 — Extract oversized search widgets
```
Split search_listing_card.dart into search_listing_card.dart + listing_artwork.dart (CustomPainters). Split search_filter_panel.dart into filter_panel.dart + filter_form_fields.dart + filter_query_mapper.dart. Keep search_page.dart under 350 lines.
```

#### Prompt 5.4 — Document bloc lifecycle conventions
```
Add docs/ARCHITECTURE.md (or extend this file) documenting: which blocs are singleton vs factory, where they are provided in the widget tree, and dependency direction rules. Add a short comment block at top of service_locator.dart explaining the conventions.
```

**Exit criteria:** `flutter test` passes with ≥10 meaningful tests; search detail works without passing bloc in extra.

---

## Quick Reference — Files to Prioritize

| Priority | File | Action |
|----------|------|--------|
| P0 | `profile_page.dart` | Split into widgets |
| P0 | `profile_bloc.dart` / `profile_state.dart` | Split by sub-domain |
| P0 | `auth_interceptor.dart` | Remove print + Bloc dependency |
| P1 | `profile_sections.dart` | Remove mock data |
| P1 | `login_page.dart`, `signup_page.dart` | Stop importing data models |
| P1 | `app_router.dart` | Fix bloc scoping |
| P2 | `land_model.dart` | Mapper + fixture tests |
| P2 | `search_listing_card.dart` | Split artwork |
| P3 | `search_listing_catalog.dart` | Delete or move to test |
| P3 | `new_profile_page.dart` | Delete or wire to router |

---

## Suggested Order of Execution

```
Phase 1 (hygiene) → Phase 2 (layers) → Phase 3 (profile split) → Phase 4 (domain unify) → Phase 5 (tests)
```

Do **not** start Phase 3 before Phase 2 — splitting ProfileBloc while layer violations remain will multiply bad patterns across new files.

---

## Metrics to Track Progress

| Metric | Current | Target |
|--------|---------|--------|
| Largest page file | 4,051 lines | < 300 lines |
| ProfileBloc use cases | 16 | ≤ 5 per bloc |
| Presentation → data imports | 5 files | 0 |
| Unit/bloc tests | ~1 | ≥ 15 |
| Mock data in presentation | Yes | No |
| Token logging | Yes | No |

---

*Generated from static analysis, graphify dependency scan, and architectural review of `garuda_user`.*
