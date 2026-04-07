# Garuda User App: Project Architecture & Structure Guide

Welcome to the Garuda Lands app! This project is built using **Clean Architecture** and the **BLoC Pattern**. This structure is designed to be professional, scalable, and easy to maintain.

Even with one year of experience, understanding these layers will help you write "Enterprise-grade" code.

---

## 1. High-Level Folder Structure

```text
lib/
├── core/             # Shared logic and global configurations
├── features/         # Feature-based modular code (e.g., Auth, Home)
└── main.dart         # Entry point of the application
```

---

## 2. The `core/` Directory
The `core` folder contains code that is used everywhere across the app. Think of it as the "Foundation."

- **`constants/`**: App-wide strings, API endpoints (`AppConstants`), and route names (`AppRoutes`).
- **`di/`**: Dependency Injection using `get_it`. The `service_locator.dart` is the "Warehouse" where all your classes (BLoCs, UseCases) are registered before use.
- **`error/`**: Custom `AppException` and `Failure` classes for consistent error handling.
- **`network/`**: Networking logic (Dio, API Service, Interceptors).
- **`theme/`**: Global UI styles, colors (`AppColors`), and typography.
- **`utils/`**: Helper classes like `Result` (used to return either Success or Error from functions).
- **`widgets/`**: Reusable UI components used in multiple features (e.g., `CustomTextField`, `CustomCard`).

---

## 3. The `features/` Directory (Clean Architecture)
Instead of folders like "models" or "screens" at the root, we group code by **Features** (e.g., `auth`). Each feature is divided into 3 layers:

### A. Domain Layer (The "Brain")
This is the most important layer. It contains the business logic and should not depend on any external package (like Dio).
- **`entities/`**: Plain Dart objects that represent the data (e.g., `UserEntity`).
- **`repositories/`**: **Interfaces** (abstract classes). They define *what* the feature can do (e.g., `login`, `signup`) but not *how* to do it.
- **`usecases/`**: Specific tasks a user can perform. Each file does exactly one thing (e.g., `LoginUseCase`).

### B. Data Layer (The "Muscles")
This layer handles the actual data fetching.
- **`models/`**: Data Transfer Objects (DTOs). These extend Entities but add `fromJson` and `toJson` methods for API communication.
- **`datasources/`**:
    - `remote`: Makes HTTP calls to the API.
    - `local`: Handles local storage (SharedPreferences).
- **`repositories/`**: Implementation of the domain interfaces. This is where you decide whether to fetch data from the API or from the local cache.

### C. Presentation Layer (The "Face")
This is everything the user sees.
- **`pages/`**: The actual screens (e.g., `LoginPage`).
- **`bloc/`**: State management logic.
    - `event.dart`: Actions the user takes (e.g., "Login Button Pressed").
    - `state.dart`: Different UI states (e.g., "Loading", "Success", "Error").
    - `bloc.dart`: The "Middleman" that takes an event and converts it into a state.
- **`widgets/`**: UI components specific to *only* this feature (e.g., `ProfileImagePicker`).

---

## 4. How the Flow Works (Example: Login)

1.  **UI (`LoginPage`)**: The user clicks the button. The UI sends a `LoginRequested` event to the `LoginBloc`.
2.  **BLoC (`LoginBloc`)**: The BLoC calls the `LoginUseCase`.
3.  **UseCase (`LoginUseCase`)**: The UseCase calls the `AuthRepository`.
4.  **Repository (`AuthRepositoryImpl`)**:
    - Calls `AuthRemoteDataSource` to hit the API.
    - Receives a `LoginResponseModel`.
    - Saves the tokens to `AuthLocalDataSource` (SharedPreferences).
    - Returns the `UserEntity` back up the chain.
5.  **BLoC (`LoginBloc`)**: Receives the result and emits a `LoginStatus.success` state.
6.  **UI (`LoginPage`)**: The `BlocConsumer` sees the success state and navigates the user to the Home screen.

---

## 5. Key Concepts to Remember

- **Interface vs Implementation**: We use `abstract interface class AuthRepository` in the Domain so that the UI doesn't care *where* the data comes from. This makes it easy to switch APIs or swap them with mock data for testing.
- **Dependency Injection (DI)**: Never create instances of classes manually using `new AuthRepositoryImpl()`. Always use `sl<AuthRepository>()`. This makes your code modular and "testable."
- **Failures, not Exceptions**: We convert low-level `Exceptions` (like Dio errors) into high-level `Failures` in the Data layer. This ensures the UI only deals with user-friendly error messages.

---

### Pro-Tip for your 1-Year Journey:
When adding a new feature, follow this order:
1.  **Domain**: Define the Entity -> Define the Repository Interface -> Create the UseCase.
2.  **Data**: Create the Model -> Create the DataSource -> Implement the Repository.
3.  **Presentation**: Create the Events/State -> Create the Bloc -> Build the Page UI.
4.  **DI**: Register everything in `service_locator.dart`.

Happy Coding! 🚀
