// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flags_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the app's known feature flags + app_config
/// (docs/01_FOUNDATION_AUTH.md §15 "Этап 1.8"). Deliberately simpler
/// than `L10nCacheController` (l10n_providers.dart): flags have no local
/// cache of their own (no Drift table, nothing seeded on disk) — there
/// is nothing here that needs to survive a cold start before the first
/// network round-trip, because [build] already returns a safe,
/// synchronous default ([defaultFeatureFlags]) that keeps the app fully
/// usable (in particular, the welcome screen's login buttons all render
/// enabled) before that first response ever lands. That default IS the
/// "local cache" — it's compiled in, not fetched, and it's exactly what
/// a freshly-seeded backend would return anyway (see
/// defaultFeatureFlags's doc comment) — so a second on-disk cache layer
/// would only add complexity for a value that already degrades
/// gracefully without one.
///
/// One entry point, called from `main.dart` AFTER `runApp` (non-blocking
/// — see that file): [refreshInBackground] fetches `/config/bootstrap`
/// and merges the result over [defaultFeatureFlags]. ANY failure
/// (offline, timeout, backend error, unexpected response shape) is
/// swallowed here, never rethrown — same "must never crash or block the
/// app" contract as `L10nRepository.refresh`'s doc comment. A flag
/// change in the DB (docs/01_FOUNDATION_AUTH.md §15 stage-1.8 acceptance
/// criterion: "смена флага в БД отражается в приложении без релиза
/// (после обновления bootstrap)") only needs to show up "after a
/// bootstrap update" — there is no requirement that it show up before
/// first paint — so a plain best-effort background fetch satisfies it;
/// nothing calls this again later (no periodic re-poll, no pull-to-
/// refresh hook) because §15 doesn't ask for that either, only for the
/// value to be current as of the next cold start.

@ProviderFor(FeatureFlagsController)
final featureFlagsControllerProvider = FeatureFlagsControllerProvider._();

/// Owns the app's known feature flags + app_config
/// (docs/01_FOUNDATION_AUTH.md §15 "Этап 1.8"). Deliberately simpler
/// than `L10nCacheController` (l10n_providers.dart): flags have no local
/// cache of their own (no Drift table, nothing seeded on disk) — there
/// is nothing here that needs to survive a cold start before the first
/// network round-trip, because [build] already returns a safe,
/// synchronous default ([defaultFeatureFlags]) that keeps the app fully
/// usable (in particular, the welcome screen's login buttons all render
/// enabled) before that first response ever lands. That default IS the
/// "local cache" — it's compiled in, not fetched, and it's exactly what
/// a freshly-seeded backend would return anyway (see
/// defaultFeatureFlags's doc comment) — so a second on-disk cache layer
/// would only add complexity for a value that already degrades
/// gracefully without one.
///
/// One entry point, called from `main.dart` AFTER `runApp` (non-blocking
/// — see that file): [refreshInBackground] fetches `/config/bootstrap`
/// and merges the result over [defaultFeatureFlags]. ANY failure
/// (offline, timeout, backend error, unexpected response shape) is
/// swallowed here, never rethrown — same "must never crash or block the
/// app" contract as `L10nRepository.refresh`'s doc comment. A flag
/// change in the DB (docs/01_FOUNDATION_AUTH.md §15 stage-1.8 acceptance
/// criterion: "смена флага в БД отражается в приложении без релиза
/// (после обновления bootstrap)") only needs to show up "after a
/// bootstrap update" — there is no requirement that it show up before
/// first paint — so a plain best-effort background fetch satisfies it;
/// nothing calls this again later (no periodic re-poll, no pull-to-
/// refresh hook) because §15 doesn't ask for that either, only for the
/// value to be current as of the next cold start.
final class FeatureFlagsControllerProvider
    extends $NotifierProvider<FeatureFlagsController, FeatureFlagsState> {
  /// Owns the app's known feature flags + app_config
  /// (docs/01_FOUNDATION_AUTH.md §15 "Этап 1.8"). Deliberately simpler
  /// than `L10nCacheController` (l10n_providers.dart): flags have no local
  /// cache of their own (no Drift table, nothing seeded on disk) — there
  /// is nothing here that needs to survive a cold start before the first
  /// network round-trip, because [build] already returns a safe,
  /// synchronous default ([defaultFeatureFlags]) that keeps the app fully
  /// usable (in particular, the welcome screen's login buttons all render
  /// enabled) before that first response ever lands. That default IS the
  /// "local cache" — it's compiled in, not fetched, and it's exactly what
  /// a freshly-seeded backend would return anyway (see
  /// defaultFeatureFlags's doc comment) — so a second on-disk cache layer
  /// would only add complexity for a value that already degrades
  /// gracefully without one.
  ///
  /// One entry point, called from `main.dart` AFTER `runApp` (non-blocking
  /// — see that file): [refreshInBackground] fetches `/config/bootstrap`
  /// and merges the result over [defaultFeatureFlags]. ANY failure
  /// (offline, timeout, backend error, unexpected response shape) is
  /// swallowed here, never rethrown — same "must never crash or block the
  /// app" contract as `L10nRepository.refresh`'s doc comment. A flag
  /// change in the DB (docs/01_FOUNDATION_AUTH.md §15 stage-1.8 acceptance
  /// criterion: "смена флага в БД отражается в приложении без релиза
  /// (после обновления bootstrap)") only needs to show up "after a
  /// bootstrap update" — there is no requirement that it show up before
  /// first paint — so a plain best-effort background fetch satisfies it;
  /// nothing calls this again later (no periodic re-poll, no pull-to-
  /// refresh hook) because §15 doesn't ask for that either, only for the
  /// value to be current as of the next cold start.
  FeatureFlagsControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'featureFlagsControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$featureFlagsControllerHash();

  @$internal
  @override
  FeatureFlagsController create() => FeatureFlagsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeatureFlagsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeatureFlagsState>(value),
    );
  }
}

String _$featureFlagsControllerHash() =>
    r'2baeb289a271178fca2953e2e4a818e0cf3678e9';

/// Owns the app's known feature flags + app_config
/// (docs/01_FOUNDATION_AUTH.md §15 "Этап 1.8"). Deliberately simpler
/// than `L10nCacheController` (l10n_providers.dart): flags have no local
/// cache of their own (no Drift table, nothing seeded on disk) — there
/// is nothing here that needs to survive a cold start before the first
/// network round-trip, because [build] already returns a safe,
/// synchronous default ([defaultFeatureFlags]) that keeps the app fully
/// usable (in particular, the welcome screen's login buttons all render
/// enabled) before that first response ever lands. That default IS the
/// "local cache" — it's compiled in, not fetched, and it's exactly what
/// a freshly-seeded backend would return anyway (see
/// defaultFeatureFlags's doc comment) — so a second on-disk cache layer
/// would only add complexity for a value that already degrades
/// gracefully without one.
///
/// One entry point, called from `main.dart` AFTER `runApp` (non-blocking
/// — see that file): [refreshInBackground] fetches `/config/bootstrap`
/// and merges the result over [defaultFeatureFlags]. ANY failure
/// (offline, timeout, backend error, unexpected response shape) is
/// swallowed here, never rethrown — same "must never crash or block the
/// app" contract as `L10nRepository.refresh`'s doc comment. A flag
/// change in the DB (docs/01_FOUNDATION_AUTH.md §15 stage-1.8 acceptance
/// criterion: "смена флага в БД отражается в приложении без релиза
/// (после обновления bootstrap)") only needs to show up "after a
/// bootstrap update" — there is no requirement that it show up before
/// first paint — so a plain best-effort background fetch satisfies it;
/// nothing calls this again later (no periodic re-poll, no pull-to-
/// refresh hook) because §15 doesn't ask for that either, only for the
/// value to be current as of the next cold start.

abstract class _$FeatureFlagsController extends $Notifier<FeatureFlagsState> {
  FeatureFlagsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FeatureFlagsState, FeatureFlagsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FeatureFlagsState, FeatureFlagsState>,
        FeatureFlagsState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
