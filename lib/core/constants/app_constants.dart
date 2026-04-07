final class AppConstants {
  AppConstants._();

  static const String baseUrl = 'https://api.garudalands.com/v1';
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
  static const Duration mockLoadingDelay = Duration(milliseconds: 350);
  static const double maxContentWidth = 1080;
}
