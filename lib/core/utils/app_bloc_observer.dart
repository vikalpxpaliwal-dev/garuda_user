import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    log('${bloc.runtimeType} -> $event', name: 'BlocEvent');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    log('${bloc.runtimeType} -> $transition', name: 'BlocTransition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('$error', name: 'BlocError', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
