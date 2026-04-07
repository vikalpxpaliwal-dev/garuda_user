final class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/';
  static const search = '/search';
  static const searchDetails = 'details';
  static const profile = '/profile';

  static String searchListingDetails(int index) =>
      '$search/$searchDetails/$index';
}
