import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garuda_user_app/app.dart';
import 'package:garuda_user_app/core/constants/app_routes.dart';
import 'package:garuda_user_app/core/di/service_locator.dart';
import 'package:garuda_user_app/features/profile/presentation/pages/profile_page.dart';
import 'package:garuda_user_app/features/search/presentation/pages/search_listing_detail_page.dart';
import 'package:garuda_user_app/features/search/presentation/pages/search_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('renders the Garuda Lands home dashboard', (tester) async {
    await initializeDependencies(reset: true);
    await tester.pumpWidget(const GarudaApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Garuda Lands'), findsOneWidget);
    expect(find.text('Finding land is easy'), findsOneWidget);
    expect(find.text('Selling of land is easy now'), findsOneWidget);
    expect(find.text('Work with us'), findsOneWidget);
    expect(find.text('CONTACT US'), findsOneWidget);
  });

  testWidgets('renders the search listings dashboard', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchPage()));
    await tester.pumpAndSettle();

    expect(find.text('SEARCH LAND'), findsOneWidget);
    expect(find.text('Near Shadnagar'), findsOneWidget);
    expect(find.text('Near Chevella'), findsOneWidget);
    expect(find.text('Full Details'), findsAtLeastNWidgets(2));
  });

  testWidgets('opens the full details screen from a search card', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoutes.search,
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const SearchPage(),
          routes: <RouteBase>[
            GoRoute(
              path: '${AppRoutes.searchDetails}/:index',
              builder: (context, state) {
                final index =
                    int.tryParse(state.pathParameters['index'] ?? '') ?? 0;

                return SearchListingDetailPage(listingIndex: index);
              },
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Full Details').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Full Details').first);
    await tester.pumpAndSettle();

    expect(find.text('FULL DETAILS'), findsOneWidget);
    expect(find.text('PROPERTY REPORT'), findsOneWidget);
    expect(find.text('DOCUMENT STATUS'), findsOneWidget);
  });

  testWidgets('renders the profile land journey dashboard', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
    await tester.pumpAndSettle();

    expect(find.text('User Profile'), findsOneWidget);
    expect(find.text('ACTIVE MEMBER'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('My Lands'), findsOneWidget);
    expect(find.text('SELECT LAND JOURNEY'), findsOneWidget);
    expect(find.text('8 AC - CHEVELLA'), findsOneWidget);
    expect(find.text('START TRACKING 1 LANDS'), findsOneWidget);
  });

  testWidgets('shows my lands list when my lands tab is selected', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Lands'));
    await tester.pumpAndSettle();

    expect(find.text('LIST OF LANDS'), findsOneWidget);
    expect(find.text('LIST NEW LAND'), findsOneWidget);
    expect(find.text('MANGO GROVE ESTATE'), findsOneWidget);
    expect(find.text('VIKARABAD + 3 AC'), findsOneWidget);
    expect(find.text('HILLVIEW AGRI PLOT'), findsOneWidget);
    expect(find.text('CHEVELLA + 2 AC'), findsOneWidget);
    expect(find.text('START TRACKING 1 LANDS'), findsNothing);
  });

  testWidgets('opens the tracked land details flow from profile page', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('START TRACKING 1 LANDS'));
    await tester.pumpAndSettle();

    expect(find.text('BACK TO SELECTION'), findsOneWidget);
    expect(find.text('AVAILABILITY'), findsOneWidget);
    expect(find.text('PAYMENT'), findsOneWidget);
    expect(find.text('VISITS HUB'), findsOneWidget);
    expect(find.text('AVAILABLE FOR SALE'), findsOneWidget);
    expect(find.text('VIEW FULL DETAILS'), findsOneWidget);
    expect(find.text('ADD TO VISIT CART'), findsOneWidget);
    expect(find.text('REMOVE FROM THIS LIST'), findsOneWidget);

    await tester.tap(find.text('BACK TO SELECTION'));
    await tester.pumpAndSettle();

    expect(find.text('SELECT LAND JOURNEY'), findsOneWidget);
  });

  testWidgets('shows payment summary when payment tab is selected', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('START TRACKING 1 LANDS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PAYMENT'));
    await tester.pumpAndSettle();

    expect(find.text('CONSOLIDATED VISIT DATE'), findsOneWidget);
    expect(find.text('BATCH SUMMARY'), findsOneWidget);
    expect(find.text('SELECTED PROPERTIES'), findsOneWidget);
    expect(find.text('TOTAL LAND VALUE'), findsOneWidget);
    expect(find.text('SERVICE FEE'), findsOneWidget);
    expect(find.text('PAY SERVICE FEE (Rs 0)'), findsOneWidget);
  });

  testWidgets('shows visit hub controls when visits hub tab is selected', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('START TRACKING 1 LANDS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('VISITS HUB'));
    await tester.pumpAndSettle();

    expect(find.text('PRIMARY VISIT'), findsOneWidget);
    expect(find.text('SHORTLIST'), findsOneWidget);
    expect(find.text('FINAL LIST'), findsOneWidget);
    expect(find.byIcon(Icons.phone_in_talk_rounded), findsOneWidget);
    expect(find.byIcon(Icons.call_rounded), findsOneWidget);
  });
}
