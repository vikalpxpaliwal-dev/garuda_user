import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/home/domain/entities/home_dashboard.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.dashboard,
    this.errorMessage,
  });

  final HomeStatus status;
  final HomeDashboard? dashboard;
  final String? errorMessage;

  static const Object _sentinel = Object();

  HomeState copyWith({
    HomeStatus? status,
    Object? dashboard = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboard: identical(dashboard, _sentinel)
          ? this.dashboard
          : dashboard as HomeDashboard?,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, dashboard, errorMessage];
}
