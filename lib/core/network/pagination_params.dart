import 'package:equatable/equatable.dart';

class PaginationParams extends Equatable {
  const PaginationParams({this.page = 1, this.limit = 20, this.query});

  final int page;
  final int limit;
  final String? query;

  PaginationParams copyWith({int? page, int? limit, String? query}) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => <Object?>[page, limit, query];
}
