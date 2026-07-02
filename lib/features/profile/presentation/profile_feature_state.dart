import 'package:garuda_user_app/features/profile/domain/entities/availability_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/cart_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/shortlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/visit_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/availability/availability_state.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/cart/cart_state.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/shortlist/shortlist_state.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/visits/visits_state.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_state.dart';

/// Read-only view combining sub-bloc states for profile UI code that
/// previously consumed a single monolithic [ProfileState].
class ProfileFeatureState {
  const ProfileFeatureState({
    required this.wishlist,
    required this.availability,
    required this.cart,
    required this.visits,
    required this.shortlist,
  });

  final WishlistState wishlist;
  final AvailabilityState availability;
  final CartState cart;
  final VisitsState visits;
  final ShortlistState shortlist;

  WishlistStatus get wishlistStatus => wishlist.status;
  List<WishlistItemEntity> get wishlistItems => wishlist.items;
  String? get wishlistErrorMessage => wishlist.errorMessage;

  CreateAvailabilityStatus get availabilityStatus => availability.createStatus;
  GetAvailabilityStatus get getAvailabilityStatus => availability.getStatus;
  String? get availabilityErrorMessage => availability.errorMessage;
  List<AvailabilityEntity> get availabilityItems => availability.items;

  CreateCartStatus get cartStatus => cart.createStatus;
  String? get cartErrorMessage => cart.createErrorMessage;
  GetCartStatus get getCartStatus => cart.getStatus;
  List<CartItemEntity> get cartItems => cart.items;
  String? get cartItemsErrorMessage => cart.getErrorMessage;
  CreatePaymentStatus get paymentStatus => cart.paymentStatus;
  String? get paymentErrorMessage => cart.paymentErrorMessage;

  CreateVisitStatus get visitStatus => visits.createStatus;
  String? get visitErrorMessage => visits.createErrorMessage;
  GetVisitsStatus get getVisitsStatus => visits.getStatus;
  List<VisitItemEntity> get visitItems => visits.items;
  String? get visitItemsErrorMessage => visits.getErrorMessage;

  GetShortlistsStatus get getShortlistsStatus => shortlist.getShortlistsStatus;
  List<ShortlistItemEntity> get shortlistItems => shortlist.shortlistItems;
  String? get shortlistItemsErrorMessage => shortlist.shortlistItemsErrorMessage;
  GetFinalsStatus get getFinalsStatus => shortlist.getFinalsStatus;
  List<ShortlistItemEntity> get finalItems => shortlist.finalItems;
  String? get finalItemsErrorMessage => shortlist.finalItemsErrorMessage;
  CreateShortlistStatus get shortlistStatus => shortlist.shortlistStatus;
  String? get shortlistMessage => shortlist.shortlistMessage;
  int? get activeShortlistLandId => shortlist.activeShortlistLandId;
  List<int> get shortlistedLandIds => shortlist.shortlistedLandIds;
  DeleteShortlistStatus get deleteShortlistStatus =>
      shortlist.deleteShortlistStatus;
  String? get deleteShortlistMessage => shortlist.deleteShortlistMessage;
  int? get activeDeleteShortlistLandId => shortlist.activeDeleteShortlistLandId;
  CreateFinalStatus get createFinalStatus => shortlist.createFinalStatus;
  String? get finalMessage => shortlist.finalMessage;
  int? get activeFinalLandId => shortlist.activeFinalLandId;
  List<int> get finalizedLandIds => shortlist.finalizedLandIds;
  DeleteFinalStatus get deleteFinalStatus => shortlist.deleteFinalStatus;
  String? get deleteFinalMessage => shortlist.deleteFinalMessage;
  int? get activeDeleteFinalLandId => shortlist.activeDeleteFinalLandId;
}
