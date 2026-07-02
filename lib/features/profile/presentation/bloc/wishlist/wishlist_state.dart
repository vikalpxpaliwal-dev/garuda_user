import 'package:equatable/equatable.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';

enum WishlistStatus { initial, loading, success, failure }

class WishlistState extends Equatable {
  const WishlistState({
    this.status = WishlistStatus.initial,
    this.items = const <WishlistItemEntity>[],
    this.errorMessage,
  });

  final WishlistStatus status;
  final List<WishlistItemEntity> items;
  final String? errorMessage;

  WishlistState copyWith({
    WishlistStatus? status,
    List<WishlistItemEntity>? items,
    String? errorMessage,
  }) {
    return WishlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
