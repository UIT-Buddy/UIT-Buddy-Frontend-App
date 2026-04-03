# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UIT Buddy is a Flutter mobile app (Android/iOS) for university students — providing schedule management, social feeds, file storage, chat (via CometChat), and push notifications (via FCM).

- **Flutter:** 3.38.6 stable, Dart SDK ≥3.10.0
- **State management:** flutter_bloc (BLoC pattern)
- **Routing:** go_router v17
- **Backend API:** `http://52.64.199.49:8080`

## Common Commands

```bash
make run            # Run app with env vars from .env
make gen-code       # Run build_runner (Freezed, JSON serializable)
make format         # Format Dart code (required before every commit)
make clean          # flutter clean + flutter pub get
make unit-test      # flutter test test/ --no-pub
make test           # Full CI check locally: format + analyze + unit tests
make build-release  # Build release APK (clean + gen-code first)
make build-bundle   # Build AAB for Google Play
make install-apk     # Clean, build, install via ADB, grant permissions, launch
```

To run a single test file:
```bash
flutter test test/features/onboarding/domain/usecases/sign_in_usecase_test.dart --no-pub
```

## Architecture

### Layer Structure (per feature)
Every feature lives under `lib/features/<name>/` with three layers:
```
presentation/   → Screens, Widgets, BLoCs
domain/         → Entities, Repository interfaces (abstract), Usecases
data/           → Models, Datasource implementations, Repository implementations
```

### Core Module (`lib/core/`)
- `network/` — `HttpClient` (Dio wrapper), `AuthRefreshInterceptor` (auto-attaches Bearer token, handles 401 refresh)
- `error/` — `Failure` and `ServerException` (Freezed) for typed error handling
- `usecase/` — `UseCase<Success, Params>` base using `fpdart Either<Failure, T>`
- `storages/` — `SecureStorage`, `LocalStorage`, `KeyValueStorage` wrappers
- `common/token/` — `TokenStore`, `RefreshTokenDataSource` for session persistence
- `config/` — `AppEnv` reads env vars via `--dart-define-from-file=.env`

### App Module (`lib/app/`)
- `main.dart` — Entry point, initializes DI, runs `MainApp`
- `app.dart` — Root `MaterialApp.router` with `SessionBloc` provider
- `di/app_dependencies.dart` — Full GetIt DI container (~1000 lines)
- `router/app_router.dart` — GoRouter configuration and all route definitions
- `router/route_name.dart` — Route path constants

### Dependency Injection Pattern
- `registerLazySingleton` for repositories, datasources, usecases, blocs
- `registerFactory` for screen-scoped blocs
- `registerSingleton` for `SecureStorage` and `TokenStore`
- Named Dio clients: `'publicDio'` (no auth), `'authenticatedDio'` (has interceptors)

### Auth / Session Flow
1. `SessionBloc` (singleton) fetches the current user on app start
2. `publicDio` is used for auth endpoints (`/signin`, `/signup`, `/refresh-token`)
3. `authenticatedDio` has `AuthRefreshInterceptor` that attaches the Bearer token and auto-retries after a token refresh
4. Tokens are persisted in `flutter_secure_storage`
5. On session expiry, `onSessionExpired` redirects to `/sign-in`

### Code Generation
- **Freezed** — immutable data classes (models, exceptions, API responses)
- **JSON Serializable** — generates `.g.dart` for JSON serialization
- **Mockito** — generates `.mocks.dart` via `@GenerateMocks`
- Always run `make gen-code` after modifying any Freezed/JSON serializable class

### Testing
- Tests live under `test/`, mirroring the `lib/features/` structure
- `test/mocks/mocks.dart` contains all `@GenerateMocks` declarations
- Use `bloc_test` for BLoC testing and `mockito` for mocking

## Navigation

The app has two main route groups:
- **Unauthenticated:** `/sign-in`, `/sign-up-token`, `/sign-up-info`, `/otp`, `/reset-password`, `/welcome`
- **Authenticated (bottom nav):** `/home`, `/calendar`, `/social`, `/storage`, `/profile`

The root `WrapperScreen` uses a `PageView` with a custom bottom nav panel (5 tabs). Modal/push routes include `/notification`, `/tasks`, `/task-detail`, `/settings`, and others.

## Key Files

| File | Purpose |
|---|---|
| `lib/app/di/app_dependencies.dart` | All DI registrations |
| `lib/app/router/app_router.dart` | All route definitions |
| `lib/core/network/auth_refresh_interceptor.dart` | Token attach + 401 refresh logic |
| `lib/features/session/` | `SessionBloc` — app-wide auth state |
| `lib/app/app.dart` | Root app widget, BLoC providers |
| `.env` | Local env vars (base URL, CometChat config) |
