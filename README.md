# garuda_user_app

Flutter app for Garuda Lands (buyer/user flow).

## Getting Started

```bash
flutter pub get
flutter run
```

## Development

### Reset local storage (dev only)

To clear secure auth tokens and `SharedPreferences` on the next launch (e.g. test login from scratch), opt in with a compile-time flag. **This does not run by default.**

```bash
flutter run --dart-define=RESET_STORAGE=true
```

The same flag works for builds:

```bash
flutter build apk --dart-define=RESET_STORAGE=true
```

Do not enable `RESET_STORAGE` in production release builds.

### Home dashboard data source

By default the home screen loads from `/buyer/home`. For local development without that API, use bundled demo banners and contact info:

```bash
flutter run --dart-define=USE_DEMO_HOME=true
```

Do not enable `USE_DEMO_HOME` in production release builds.
