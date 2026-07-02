import 'package:equatable/equatable.dart';

sealed class VisitsEvent extends Equatable {
  const VisitsEvent();

  @override
  List<Object?> get props => [];
}

class CreateVisitRequested extends VisitsEvent {
  const CreateVisitRequested({
    required this.landIds,
    required this.visitDate,
    required this.time,
  });

  final List<int> landIds;
  final String visitDate;
  final String time;

  @override
  List<Object?> get props => [landIds, visitDate, time];
}

class GetVisitsRequested extends VisitsEvent {
  const GetVisitsRequested();
}
