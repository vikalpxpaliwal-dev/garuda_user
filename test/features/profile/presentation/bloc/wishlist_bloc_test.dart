import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/core/error/failures.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/entities/wishlist_item_entity.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_bloc.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_event.dart';
import 'package:garuda_user_app/features/profile/presentation/bloc/wishlist/wishlist_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

WishlistItemEntity _item(int landId) {
  return WishlistItemEntity(
    id: landId,
    landId: landId,
    userId: 1,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
    land: WishlistLandEntity(
      id: landId,
      state: 'TS',
      district: 'R',
      mandal: 'M',
      village: 'V',
      locationLatitude: '0',
      locationLongitude: '0',
      landStatus: const ['Available'],
      urgencyListing: const [],
      verificationPackage: false,
      createdBy: 1,
      verifiedBy: null,
      formStatus: 'done',
      availability: 'yes',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    ),
  );
}

void main() {
  late _MockProfileRepository repository;
  late WishlistBloc bloc;

  setUp(() {
    repository = _MockProfileRepository();
    bloc = WishlistBloc(getWishlistUseCase: GetWishlistUseCase(repository));
  });

  tearDown(() => bloc.close());

  blocTest<WishlistBloc, WishlistState>(
    'emits success with wishlist items',
    build: () {
      when(() => repository.getWishlist())
          .thenAnswer((_) async => Success([_item(3)]));
      return bloc;
    },
    act: (bloc) => bloc.add(const WishlistRequested()),
    expect: () => [
      isA<WishlistState>().having((s) => s.status, 'status', WishlistStatus.loading),
      isA<WishlistState>()
          .having((s) => s.status, 'status', WishlistStatus.success)
          .having((s) => s.items, 'items', hasLength(1)),
    ],
  );

  blocTest<WishlistBloc, WishlistState>(
    'emits failure when repository fails',
    build: () {
      when(() => repository.getWishlist()).thenAnswer(
        (_) async => const Error(ServerFailure(message: 'Network error')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(const WishlistRequested()),
    expect: () => [
      isA<WishlistState>().having((s) => s.status, 'status', WishlistStatus.loading),
      isA<WishlistState>()
          .having((s) => s.status, 'status', WishlistStatus.failure)
          .having((s) => s.errorMessage, 'message', 'Network error'),
    ],
  );
}
