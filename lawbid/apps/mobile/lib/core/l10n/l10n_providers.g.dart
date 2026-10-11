// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the in-memory translation maps [translatorProvider] reads from —
/// docs/01_FOUNDATION_AUTH.md §9.4's boot sequence: "читает кэш из drift →
/// показывает UI → в фоне запрашивает bundle?since= → обновляет".
///
///   - [bootstrap], from `main.dart` before `runApp`: LOCAL-ONLY. Loads
///     intl date symbols and the Drift cache for the current language
///     (seeding the compiled-in maps on a brand-new install).
///   - [refreshInBackground], from the splash (`AppStartupController`):
///     refreshes the server language list (which may switch an
///     auto-detected language, see `LanguageController`), then the
///     current language's bundle (delta via `since=`) and, for any
///     non-English language, the English fallback bundle. Failures are
///     swallowed — the cached state stays.
///
/// [build] does no I/O; it `ref.listen`s to [languageControllerProvider]
/// so a later switch (picker, server value after login, auto-detection)
/// re-runs load-then-refresh for the new language without first resetting
/// the maps (no flash of raw keys).

@ProviderFor(L10nCacheController)
final l10nCacheControllerProvider = L10nCacheControllerProvider._();

/// Owns the in-memory translation maps [translatorProvider] reads from —
/// docs/01_FOUNDATION_AUTH.md §9.4's boot sequence: "читает кэш из drift →
/// показывает UI → в фоне запрашивает bundle?since= → обновляет".
///
///   - [bootstrap], from `main.dart` before `runApp`: LOCAL-ONLY. Loads
///     intl date symbols and the Drift cache for the current language
///     (seeding the compiled-in maps on a brand-new install).
///   - [refreshInBackground], from the splash (`AppStartupController`):
///     refreshes the server language list (which may switch an
///     auto-detected language, see `LanguageController`), then the
///     current language's bundle (delta via `since=`) and, for any
///     non-English language, the English fallback bundle. Failures are
///     swallowed — the cached state stays.
///
/// [build] does no I/O; it `ref.listen`s to [languageControllerProvider]
/// so a later switch (picker, server value after login, auto-detection)
/// re-runs load-then-refresh for the new language without first resetting
/// the maps (no flash of raw keys).
final class L10nCacheControllerProvider
    extends $NotifierProvider<L10nCacheController, L10nCacheState> {
  /// Owns the in-memory translation maps [translatorProvider] reads from —
  /// docs/01_FOUNDATION_AUTH.md §9.4's boot sequence: "читает кэш из drift →
  /// показывает UI → в фоне запрашивает bundle?since= → обновляет".
  ///
  ///   - [bootstrap], from `main.dart` before `runApp`: LOCAL-ONLY. Loads
  ///     intl date symbols and the Drift cache for the current language
  ///     (seeding the compiled-in maps on a brand-new install).
  ///   - [refreshInBackground], from the splash (`AppStartupController`):
  ///     refreshes the server language list (which may switch an
  ///     auto-detected language, see `LanguageController`), then the
  ///     current language's bundle (delta via `since=`) and, for any
  ///     non-English language, the English fallback bundle. Failures are
  ///     swallowed — the cached state stays.
  ///
  /// [build] does no I/O; it `ref.listen`s to [languageControllerProvider]
  /// so a later switch (picker, server value after login, auto-detection)
  /// re-runs load-then-refresh for the new language without first resetting
  /// the maps (no flash of raw keys).
  L10nCacheControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'l10nCacheControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$l10nCacheControllerHash();

  @$internal
  @override
  L10nCacheController create() => L10nCacheController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(L10nCacheState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<L10nCacheState>(value),
    );
  }
}

String _$l10nCacheControllerHash() =>
    r'404c0459178247e13884427bd9574b4e9d18a6a6';

/// Owns the in-memory translation maps [translatorProvider] reads from —
/// docs/01_FOUNDATION_AUTH.md §9.4's boot sequence: "читает кэш из drift →
/// показывает UI → в фоне запрашивает bundle?since= → обновляет".
///
///   - [bootstrap], from `main.dart` before `runApp`: LOCAL-ONLY. Loads
///     intl date symbols and the Drift cache for the current language
///     (seeding the compiled-in maps on a brand-new install).
///   - [refreshInBackground], from the splash (`AppStartupController`):
///     refreshes the server language list (which may switch an
///     auto-detected language, see `LanguageController`), then the
///     current language's bundle (delta via `since=`) and, for any
///     non-English language, the English fallback bundle. Failures are
///     swallowed — the cached state stays.
///
/// [build] does no I/O; it `ref.listen`s to [languageControllerProvider]
/// so a later switch (picker, server value after login, auto-detection)
/// re-runs load-then-refresh for the new language without first resetting
/// the maps (no flash of raw keys).

abstract class _$L10nCacheController extends $Notifier<L10nCacheState> {
  L10nCacheState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<L10nCacheState, L10nCacheState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<L10nCacheState, L10nCacheState>,
        L10nCacheState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
