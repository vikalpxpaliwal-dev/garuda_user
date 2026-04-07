import 'dart:async';

import 'package:flutter/widgets.dart';

/// A [Listenable] that notifies listeners whenever a [Stream] emits a value.
/// Used to bridge BLoC streams with [GoRouter]'s refreshListenable.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
