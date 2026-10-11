// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide router (file 01 §5.1: go_router + ShellRoute; stage 1.5 uses
/// `StatefulShellRoute.indexedStack` — see main_shell.dart doc comment).
///
/// Stage 1.7 mobile: starts on [AppRoutes.splash] (§10.2 A) and delegates
/// EVERY redirect to [AppRouterGuard] (§11). [_GuardRefresh] re-runs the
/// guard whenever the startup status, the session, or `GET /users/me`
/// changes — so onboarding screens only mutate server state and the guard
/// moves the user to the next step (no navigation logic in screens).

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// App-wide router (file 01 §5.1: go_router + ShellRoute; stage 1.5 uses
/// `StatefulShellRoute.indexedStack` — see main_shell.dart doc comment).
///
/// Stage 1.7 mobile: starts on [AppRoutes.splash] (§10.2 A) and delegates
/// EVERY redirect to [AppRouterGuard] (§11). [_GuardRefresh] re-runs the
/// guard whenever the startup status, the session, or `GET /users/me`
/// changes — so onboarding screens only mutate server state and the guard
/// moves the user to the next step (no navigation logic in screens).

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// App-wide router (file 01 §5.1: go_router + ShellRoute; stage 1.5 uses
  /// `StatefulShellRoute.indexedStack` — see main_shell.dart doc comment).
  ///
  /// Stage 1.7 mobile: starts on [AppRoutes.splash] (§10.2 A) and delegates
  /// EVERY redirect to [AppRouterGuard] (§11). [_GuardRefresh] re-runs the
  /// guard whenever the startup status, the session, or `GET /users/me`
  /// changes — so onboarding screens only mutate server state and the guard
  /// moves the user to the next step (no navigation logic in screens).
  AppRouterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appRouterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'244b00d6eac94d5930bfbbaaada1aed5f42e01ba';
