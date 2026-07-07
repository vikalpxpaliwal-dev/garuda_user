import 'package:flutter/foundation.dart';

/// Platform-aware backdrop blur policy — iOS only; Android uses solid fills.
abstract final class PlatformBlur {
  static bool get prefersBackdropBlur {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  static const double lightSigma = 8;
  static const double appBarSigma = 8;
}
