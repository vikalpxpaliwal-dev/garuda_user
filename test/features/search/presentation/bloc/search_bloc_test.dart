import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/core/utils/result.dart';
import 'package:garuda_user_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:garuda_user_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:garuda_user_app/features/search/domain/entities/land_entity.dart';
import 'package:garuda_user_app/features/search/domain/repositories/search_repository.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_land_by_id_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_lands_usecase.dart';
import 'package:garuda_user_app/features/search/domain/usecases/get_locations_usecase.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_bloc.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_event.dart';
import 'package:garuda_user_app/features/search/presentation/bloc/search_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchRepository extends Mock implements SearchRepository {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

LandEntity _land(int id) {
  return LandEntity(
    id: id,
    village: 'V',
    state: 'TS',
    district: 'R',
    mandal: 'M',
    landStatus: const ['Available'],
    mortgageStatus: const ['Available'],
    urgencyListing: const [],
    verificationPackage: false,
    isVerified: false,
    landDetails: const LandDetailsEntity(
      totalAcres: 1,
      guntas: 0,
      pricePerAcres: 1000000,
      totalValue: 1000000,
      soilType: 'Red',
      nearestRoadType: 'BT',
      landAttachedToRoad: 'Yes',
      fencingStatus: 'None',
      waterSource: [],
      electricity: [],
      residence: [],
      numberOfBores: 0,
      farmPond: false,
      poultryShedNumber: 0,
      cowShedNumber: 0,
      trees: [],
    ),
    media: const [],
    documents: const [],
  );
}

void main() {
  late _MockSearchRepository searchRepository;
  late _MockProfileRepository profileRepository;
  late SearchBloc bloc;

  setUp(() {
    searchRepository = _MockSearchRepository();
    profileRepository = _MockProfileRepository();
    bloc = SearchBloc(
      getLandsUseCase: GetLandsUseCase(searchRepository),
      addToWishlistUseCase: AddToWishlistUseCase(profileRepository),
      getWishlistUseCase: GetWishlistUseCase(profileRepository),
      getLocationsUseCase: GetLocationsUseCase(searchRepository),
      getLandByIdUseCase: GetLandByIdUseCase(searchRepository),
    );
  });

  tearDown(() => bloc.close());

  blocTest<SearchBloc, SearchState>(
    'emits success with lands when GetLandsEvent succeeds',
    build: () {
      when(() => searchRepository.getLands(filters: any(named: 'filters')))
          .thenAnswer((_) async => Success([_land(1)]));
      when(() => profileRepository.getWishlist())
          .thenAnswer((_) async => const Success([]));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetLandsEvent()),
    expect: () => [
      isA<SearchState>().having((s) => s.status, 'status', SearchStatus.loading),
      isA<SearchState>()
          .having((s) => s.status, 'status', SearchStatus.success)
          .having((s) => s.lands, 'lands', hasLength(1)),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'loads land detail from cache when land is already in state',
    seed: () => SearchState(lands: [_land(9)]),
    build: () => bloc,
    act: (bloc) => bloc.add(const LoadLandDetailEvent(landId: 9)),
    expect: () => [
      isA<SearchState>()
          .having((s) => s.landDetailStatus, 'status', LandDetailStatus.success)
          .having((s) => s.landDetail?.id, 'id', 9),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'fetches land detail when not cached',
    build: () {
      when(
        () => searchRepository.getLands(
          filters: any(named: 'filters'),
        ),
      ).thenAnswer((_) async => Success([_land(5)]));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadLandDetailEvent(landId: 5)),
    expect: () => [
      isA<SearchState>().having(
        (s) => s.landDetailStatus,
        'status',
        LandDetailStatus.loading,
      ),
      isA<SearchState>()
          .having((s) => s.landDetailStatus, 'status', LandDetailStatus.success)
          .having((s) => s.landDetail?.id, 'id', 5),
    ],
  );
}
