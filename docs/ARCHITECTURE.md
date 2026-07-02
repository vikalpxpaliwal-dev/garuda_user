# Garuda User App — Architecture

## Layering

```
presentation (bloc, pages, widgets)
    ↓ events / use cases
domain (entities, repositories interfaces, use cases)
    ↓
data (repository impls, remote/local data sources, models, mappers)
```

Presentation must not import `data/` models. Cross-feature reads go through domain use cases (for example, search uses profile `AddToWishlistUseCase`).

## Bloc lifecycle

| Bloc | Registration | Provided at |
|------|----------------|-------------|
| `AuthBloc` | lazy singleton | `main.dart` / app root |
| `HomeBloc` | factory | Home tab route (`app_router.dart`) |
| `SearchBloc` | factory | `SearchScope` shell branch |
| Profile sub-blocs (`ProfileBloc`, `WishlistBloc`, …) | factory | `ProfileScope` shell branch |

**Singleton vs factory**

- **Singleton** — expensive or app-wide dependencies (repositories, use cases, `AuthBloc`).
- **Factory** — screen/tab-scoped blocs that should not leak state across navigations. A new instance is created when the shell scope `create` runs.

**Shell scopes**

- `SearchScope` wraps the search branch so list and `/search/details/:landId` share one `SearchBloc`.
- `ProfileScope` wraps profile + edit-profile so account and wishlist state is shared.

## Navigation

- Prefer path parameters (`/search/details/:landId`) over passing blocs in `GoRouter.extra`.
- Detail screens resolve data via the scoped bloc or a use case (`GetLandByIdUseCase`).

## Data sources

- **Production default** — remote APIs via `*RemoteDataSource`.
- **Demo home** — opt-in with `flutter run --dart-define=USE_DEMO_HOME=true` (see `HomeDataConfig`).
- **Storage reset** — opt-in with `--dart-define=RESET_STORAGE=true` (dev only).

## Testing focus

Prioritize domain use cases and blocs (`bloc_test`, `mocktail`). JSON fixtures live under `test/fixtures/`.
