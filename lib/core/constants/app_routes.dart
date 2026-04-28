final class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const home = '/';
  static const search = '/search';
  static const searchDetails = '/search/details';
  static const profile = '/profile';
  static const editProfile = '/profile/edit-profile';

  static String searchListingDetails(int index) =>
      '$search/$searchDetails/$index';
}
