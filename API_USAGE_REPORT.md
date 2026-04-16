# API Usage Report

## Current Totals

- Base URL: `http://72.61.169.226:5000/api`
- Total API call sites in code (`_apiService.get/post`): **15**
- Unique API paths: **12**
- Unique API operations (`METHOD + path`): **15**

## API Operations In Use

| Method | Path | Feature | Source |
| --- | --- | --- | --- |
| POST | `/buyer/signup` | Auth | `lib/features/auth/data/datasources/auth_remote_data_source.dart` |
| POST | `/buyer/login` | Auth | `lib/features/auth/data/datasources/auth_remote_data_source.dart` |
| POST | `/buyer/refresh` | Auth | `lib/features/auth/data/datasources/auth_remote_data_source.dart` |
| POST | `/buyer/update-profile` | Auth/Profile | `lib/features/auth/data/datasources/auth_remote_data_source.dart` |
| POST | `/buyer/logout` | Auth | `lib/features/auth/data/datasources/auth_remote_data_source.dart` |
| POST | `/buyer/delete-account` | Auth | `lib/features/auth/data/datasources/auth_remote_data_source.dart` |
| GET | `/buyer/land` | Search | `lib/features/search/data/datasources/search_remote_data_source.dart` |
| POST | `/buyer/wishlist` | Search | `lib/features/search/data/datasources/search_remote_data_source.dart` |
| GET | `/buyer/wishlist` | Profile | `lib/features/profile/data/datasources/profile_remote_data_source.dart` |
| POST | `/buyer/availability` | Profile | `lib/features/profile/data/datasources/profile_remote_data_source.dart` |
| GET | `/buyer/availability` | Profile | `lib/features/profile/data/datasources/profile_remote_data_source.dart` |
| POST | `/buyer/cart` | Profile | `lib/features/profile/data/datasources/profile_remote_data_source.dart` |
| GET | `/buyer/cart` | Profile | `lib/features/profile/data/datasources/profile_remote_data_source.dart` |
| POST | `/buyer/payment` | Profile | `lib/features/profile/data/datasources/profile_remote_data_source.dart` |
| POST | `/buyer/visit` | Profile | `lib/features/profile/data/datasources/profile_remote_data_source.dart` |

## Notes

- Counting is based on current direct `_apiService` usage in `lib/features/*/data/datasources/*_remote_data_source.dart`.
- Route guards in interceptors (for auth bypass) are not counted as API operations.
