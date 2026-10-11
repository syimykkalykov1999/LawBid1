// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current interface language.
///
/// Resolution (re-run whenever the server language list changes):
///   1. an explicit stored choice, if that language is still selectable
///      (or the server list was never fetched — then it's trusted as-is,
///      so a server-only language picked earlier survives an offline cold
///      start with an empty list cache);
///   2. otherwise the system locale, if that language is selectable
///      ([detectSystemLanguage]) — not persisted, so it keeps following
///      the device until the user picks one explicitly;
///   3. otherwise English.
///
/// keepAlive: the auto-detected value lives only here.

@ProviderFor(LanguageController)
final languageControllerProvider = LanguageControllerProvider._();

/// The current interface language.
///
/// Resolution (re-run whenever the server language list changes):
///   1. an explicit stored choice, if that language is still selectable
///      (or the server list was never fetched — then it's trusted as-is,
///      so a server-only language picked earlier survives an offline cold
///      start with an empty list cache);
///   2. otherwise the system locale, if that language is selectable
///      ([detectSystemLanguage]) — not persisted, so it keeps following
///      the device until the user picks one explicitly;
///   3. otherwise English.
///
/// keepAlive: the auto-detected value lives only here.
final class LanguageControllerProvider
    extends $AsyncNotifierProvider<LanguageController, AppLanguage> {
  /// The current interface language.
  ///
  /// Resolution (re-run whenever the server language list changes):
  ///   1. an explicit stored choice, if that language is still selectable
  ///      (or the server list was never fetched — then it's trusted as-is,
  ///      so a server-only language picked earlier survives an offline cold
  ///      start with an empty list cache);
  ///   2. otherwise the system locale, if that language is selectable
  ///      ([detectSystemLanguage]) — not persisted, so it keeps following
  ///      the device until the user picks one explicitly;
  ///   3. otherwise English.
  ///
  /// keepAlive: the auto-detected value lives only here.
  LanguageControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'languageControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$languageControllerHash();

  @$internal
  @override
  LanguageController create() => LanguageController();
}

String _$languageControllerHash() =>
    r'f814dc973912006621a45ea96cfbedac4a0562bd';

/// The current interface language.
///
/// Resolution (re-run whenever the server language list changes):
///   1. an explicit stored choice, if that language is still selectable
///      (or the server list was never fetched — then it's trusted as-is,
///      so a server-only language picked earlier survives an offline cold
///      start with an empty list cache);
///   2. otherwise the system locale, if that language is selectable
///      ([detectSystemLanguage]) — not persisted, so it keeps following
///      the device until the user picks one explicitly;
///   3. otherwise English.
///
/// keepAlive: the auto-detected value lives only here.

abstract class _$LanguageController extends $AsyncNotifier<AppLanguage> {
  FutureOr<AppLanguage> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppLanguage>, AppLanguage>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AppLanguage>, AppLanguage>,
        AsyncValue<AppLanguage>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
