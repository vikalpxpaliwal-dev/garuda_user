/// Controls whether the home screen uses bundled demo content.
///
/// The `/buyer/home` API does not yet return a usable dashboard, so the home
/// screen defaults to the bundled demo content that matches the intended UI.
/// Once the API is ready, opt into it with:
/// `flutter run --dart-define=USE_DEMO_HOME=false`
abstract final class HomeDataConfig {
  static const bool useDemoHome = bool.fromEnvironment(
    'USE_DEMO_HOME',
    defaultValue: true,
  );
}
