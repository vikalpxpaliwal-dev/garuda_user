# Understanding BLoC, UseCases, Entities, and Models

As a developer with 1 year of experience, this is the part where most people get confused. Let's break it down simply.

---

## 1. Entities vs. Models: Which one to use?

Think of a **User**.

### **Entity (`user_entity.dart`)**
-   **Where?** Inside `domain/entities/`.
-   **What?** A pure Dart object. It has no idea about APIs, JSON, or external packages.
-   **When to use?** In your **UI (Pages)**, **BLoCs**, and **UseCases**.
-   **Why?** If the API changes its field names (e.g., from `full_name` to `name`), your UI doesn't need to change because it only cares about the `UserEntity.name`.

### **Model (`signup_response_model.dart`)**
-   **Where?** Inside `data/models/`.
-   **What?** A special class that **extends** (or implements) the Entity and adds `fromJson` and `toJson`.
-   **When to use?** ONLY inside the **Data Layer** (Repositories and DataSources).
-   **The Rule:** The API gives you a **Model**. You immediately convert it to an **Entity** and send it up to the UI.

---

## 2. Line-by-Line: UseCases & BLoC

Let's look at `LoginUseCase` and `LoginBloc`.

### **The UseCase (`login_usecase.dart`)**
```dart
class LoginUseCase {
  final AuthRepository _repository; // 1. It only knows the "Interface"

  Future<Result<UserEntity>> call(LoginRequestModel params) { // 2. It returns an Entity
    return _repository.login(params); // 3. It asks the repository to do the work
  }
}
```
-   **Line 1**: The UseCase doesn't know *how* login works (API? Mock? Database?). It only knows the `AuthRepository` interface.
-   **Line 2**: It returns a `UserEntity`, not a model. This keeps the logic professional and clean.

### **The BLoC (`login_bloc.dart`)**
```dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase; // 1. BLoC depends on UseCase

  Future<void> _onLoginRequested(...) async {
    emit(state.copyWith(status: LoginStatus.loading)); // 2. Start Loading

    final result = await _loginUseCase(event.request); // 3. Magic happens here

    // 4. Handle the result
    switch (result) {
      case Success(data: final user): 
        emit(state.copyWith(status: LoginStatus.success, user: user));
      case Error(failure: final f): 
        emit(state.copyWith(status: LoginStatus.failure, errorMessage: f.message));
    }
  }
}
```
-   **Line 1**: BLoC doesn't talk to the Repository. It talks to the **UseCase**.
-   **Line 3**: When the user clicks "Login", the BLoC calls the UseCase. The BLoC doesn't know *how* the API works; it just waits for a `Result`.

---

## 3. The "Chain of Command" (Step-by-Step)

1.  **User acts**: Taps button on `LoginPage`.
2.  **Event sent**: UI sends `LoginRequested` to `LoginBloc`.
3.  **Bloc calls UseCase**: `LoginBloc` calls `LoginUseCase`.
4.  **UseCase calls Repo**: `LoginUseCase` calls `AuthRepository.login()`.
5.  **Repo calls API**: `AuthRepositoryImpl` calls `AuthRemoteDataSource`.
6.  **Data comes back**: API returns `JSON` -> DataSource converts to `LoginResponseModel` -> Repository returns it as a `UserEntity`.
7.  **Bloc updates UI**: `LoginBloc` receives `UserEntity`, emits `LoginStatus.success`, and the UI shows the home screen.

---

## 4. Why do we do this? It seems like "Extra Work."

You might think: *"Can't I just call Dio inside my Page?"*

Yes, you can. But in professional apps:
1.  **Tested Code**: You can test the `LoginUseCase` without ever opening the app or having an internet connection (by mocking the Repository).
2.  **Easy Maintenance**: If you decide to switch from `shared_preferences` to `flutter_secure_storage`, you only change **one file** (`AuthLocalDataSource`). Your BLoC and UI never change!
3.  **Readability**: Anyone can look at `LoginUseCase` and understand the feature without reading 500 lines of UI code.

---

### **Summary Table**

| Component | Responsibility | Layer |
| :--- | :--- | :--- |
| **Entity** | Data structure for the UI | Domain |
| **Model** | JSON Serialization (API) | Data |
| **UseCase** | Business logic for one task | Domain |
| **Repository** | Decides Remote vs Local data | Data/Domain |
| **BLoC** | UI State management | Presentation |

Does this make it clearer? Let me know if you want to dive deeper into any specific line!
