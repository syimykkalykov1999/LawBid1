// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the signed-in session in memory (docs/01_FOUNDATION_AUTH.md §10.4
/// access-token claims). `keepAlive: true` — the plain `@riverpod`
/// annotation defaults to autoDispose, which is wrong here: this must
/// survive screen navigation for the whole app lifetime, since
/// `AppRouterGuard` reads it on every route change and
/// `AuthInterceptor` reads it on every request.
///
/// State is `SessionState?` — null means signed out, non-null means signed
/// in; see `SessionState.isAuthenticated`'s doc comment for why that's
/// modeled as presence-of-instance rather than an extra bool field.

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerProvider._();

/// Holds the signed-in session in memory (docs/01_FOUNDATION_AUTH.md §10.4
/// access-token claims). `keepAlive: true` — the plain `@riverpod`
/// annotation defaults to autoDispose, which is wrong here: this must
/// survive screen navigation for the whole app lifetime, since
/// `AppRouterGuard` reads it on every route change and
/// `AuthInterceptor` reads it on every request.
///
/// State is `SessionState?` — null means signed out, non-null means signed
/// in; see `SessionState.isAuthenticated`'s doc comment for why that's
/// modeled as presence-of-instance rather than an extra bool field.
final class SessionControllerProvider
    extends $NotifierProvider<SessionController, SessionState?> {
  /// Holds the signed-in session in memory (docs/01_FOUNDATION_AUTH.md §10.4
  /// access-token claims). `keepAlive: true` — the plain `@riverpod`
  /// annotation defaults to autoDispose, which is wrong here: this must
  /// survive screen navigation for the whole app lifetime, since
  /// `AppRouterGuard` reads it on every route change and
  /// `AuthInterceptor` reads it on every request.
  ///
  /// State is `SessionState?` — null means signed out, non-null means signed
  /// in; see `SessionState.isAuthenticated`'s doc comment for why that's
  /// modeled as presence-of-instance rather than an extra bool field.
  SessionControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sessionControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  SessionController create() => SessionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionState?>(value),
    );
  }
}

String _$sessionControllerHash() => r'9e125300ac9dfbe66a296616bca84e105fed7f4b';

/// Holds the signed-in session in memory (docs/01_FOUNDATION_AUTH.md §10.4
/// access-token claims). `keepAlive: true` — the plain `@riverpod`
/// annotation defaults to autoDispose, which is wrong here: this must
/// survive screen navigation for the whole app lifetime, since
/// `AppRouterGuard` reads it on every route change and
/// `AuthInterceptor` reads it on every request.
///
/// State is `SessionState?` — null means signed out, non-null means signed
/// in; see `SessionState.isAuthenticated`'s doc comment for why that's
/// modeled as presence-of-instance rather than an extra bool field.

abstract class _$SessionController extends $Notifier<SessionState?> {
  SessionState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionState?, SessionState?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SessionState?, SessionState?>,
        SessionState?,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
