// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The language picker's list (`LanguagePickerSheet`). Kicks a background
/// `GET /i18n/languages` refresh, then merges the server's active list
/// ([activeLanguagesControllerProvider] — live, or the cached copy when
/// offline) into the curated [kLanguageCatalog] via [mergeLanguageCatalog].

@ProviderFor(languageCatalog)
final languageCatalogProvider = LanguageCatalogProvider._();

/// The language picker's list (`LanguagePickerSheet`). Kicks a background
/// `GET /i18n/languages` refresh, then merges the server's active list
/// ([activeLanguagesControllerProvider] — live, or the cached copy when
/// offline) into the curated [kLanguageCatalog] via [mergeLanguageCatalog].

final class LanguageCatalogProvider extends $FunctionalProvider<
        AsyncValue<List<LanguageCatalogEntry>>,
        List<LanguageCatalogEntry>,
        FutureOr<List<LanguageCatalogEntry>>>
    with
        $FutureModifier<List<LanguageCatalogEntry>>,
        $FutureProvider<List<LanguageCatalogEntry>> {
  /// The language picker's list (`LanguagePickerSheet`). Kicks a background
  /// `GET /i18n/languages` refresh, then merges the server's active list
  /// ([activeLanguagesControllerProvider] — live, or the cached copy when
  /// offline) into the curated [kLanguageCatalog] via [mergeLanguageCatalog].
  LanguageCatalogProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'languageCatalogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$languageCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<LanguageCatalogEntry>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<LanguageCatalogEntry>> create(Ref ref) {
    return languageCatalog(ref);
  }
}

String _$languageCatalogHash() => r'c1233bb2cb50406189eb9ee1b00d048b3bc73484';
