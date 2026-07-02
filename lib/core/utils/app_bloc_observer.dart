import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    if (kDebugMode) {
      log('${bloc.runtimeType} -> ${event.runtimeType}', name: 'BlocEvent');
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    if (kDebugMode) {
      log(
        '${bloc.runtimeType} ${transition.event.runtimeType} -> ${transition.nextState.runtimeType}',
        name: 'BlocTransition',
      );
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      log('$error', name: 'BlocError', error: error, stackTrace: stackTrace);
    }
    super.onError(bloc, error, stackTrace);
  }
}
