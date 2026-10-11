// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives `/profile/settings/delete-account` (file 01 §10.7:
/// "Настройки → Удалить аккаунт → предупреждение → повторная
/// аутентификация → подтверждение"). Phase 4 of the auth networking work
/// (docs/CHANGELOG.md), continuing directly after Phase 3 social login
/// (commit 2bbeba5).
///
/// A plain (sync) `Notifier`, not `AsyncNotifier` — unlike
/// `ActiveDevicesController`, `build()` here does no network call, only
/// [acknowledgeWarning]/[submitPhone]/[submitCode]/[submitDeletion]
/// do, and each already tracks its own [DeleteAccountFlowState.isSubmitting]
/// / [DeleteAccountFlowState.errorMessage] rather than the whole state tree
/// going through `AsyncValue`'s loading/error/data — same shape as
/// `OnboardingFlow` (features/auth/application/onboarding_flow.dart).
///
/// NOTE: this file's `.g.dart` part was NOT generated as part of this
/// change (no `dart` binary available on this bridge) — `dart run
/// build_runner build` is required before this compiles.

@ProviderFor(DeleteAccountController)
final deleteAccountControllerProvider = DeleteAccountControllerProvider._();

/// Drives `/profile/settings/delete-account` (file 01 §10.7:
/// "Настройки → Удалить аккаунт → предупреждение → повторная
/// аутентификация → подтверждение"). Phase 4 of the auth networking work
/// (docs/CHANGELOG.md), continuing directly after Phase 3 social login
/// (commit 2bbeba5).
///
/// A plain (sync) `Notifier`, not `AsyncNotifier` — unlike
/// `ActiveDevicesController`, `build()` here does no network call, only
/// [acknowledgeWarning]/[submitPhone]/[submitCode]/[submitDeletion]
/// do, and each already tracks its own [DeleteAccountFlowState.isSubmitting]
/// / [DeleteAccountFlowState.errorMessage] rather than the whole state tree
/// going through `AsyncValue`'s loading/error/data — same shape as
/// `OnboardingFlow` (features/auth/application/onboarding_flow.dart).
///
/// NOTE: this file's `.g.dart` part was NOT generated as part of this
/// change (no `dart` binary available on this bridge) — `dart run
/// build_runner build` is required before this compiles.
final class DeleteAccountControllerProvider
    extends $NotifierProvider<DeleteAccountController, DeleteAccountFlowState> {
  /// Drives `/profile/settings/delete-account` (file 01 §10.7:
  /// "Настройки → Удалить аккаунт → предупреждение → повторная
  /// аутентификация → подтверждение"). Phase 4 of the auth networking work
  /// (docs/CHANGELOG.md), continuing directly after Phase 3 social login
  /// (commit 2bbeba5).
  ///
  /// A plain (sync) `Notifier`, not `AsyncNotifier` — unlike
  /// `ActiveDevicesController`, `build()` here does no network call, only
  /// [acknowledgeWarning]/[submitPhone]/[submitCode]/[submitDeletion]
  /// do, and each already tracks its own [DeleteAccountFlowState.isSubmitting]
  /// / [DeleteAccountFlowState.errorMessage] rather than the whole state tree
  /// going through `AsyncValue`'s loading/error/data — same shape as
  /// `OnboardingFlow` (features/auth/application/onboarding_flow.dart).
  ///
  /// NOTE: this file's `.g.dart` part was NOT generated as part of this
  /// change (no `dart` binary available on this bridge) — `dart run
  /// build_runner build` is required before this compiles.
  DeleteAccountControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deleteAccountControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deleteAccountControllerHash();

  @$internal
  @override
  DeleteAccountController create() => DeleteAccountController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteAccountFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteAccountFlowState>(value),
    );
  }
}

String _$deleteAccountControllerHash() =>
    r'5177a852120aa08b48e2e5cd32fb76852a4ffb6b';

/// Drives `/profile/settings/delete-account` (file 01 §10.7:
/// "Настройки → Удалить аккаунт → предупреждение → повторная
/// аутентификация → подтверждение"). Phase 4 of the auth networking work
/// (docs/CHANGELOG.md), continuing directly after Phase 3 social login
/// (commit 2bbeba5).
///
/// A plain (sync) `Notifier`, not `AsyncNotifier` — unlike
/// `ActiveDevicesController`, `build()` here does no network call, only
/// [acknowledgeWarning]/[submitPhone]/[submitCode]/[submitDeletion]
/// do, and each already tracks its own [DeleteAccountFlowState.isSubmitting]
/// / [DeleteAccountFlowState.errorMessage] rather than the whole state tree
/// going through `AsyncValue`'s loading/error/data — same shape as
/// `OnboardingFlow` (features/auth/application/onboarding_flow.dart).
///
/// NOTE: this file's `.g.dart` part was NOT generated as part of this
/// change (no `dart` binary available on this bridge) — `dart run
/// build_runner build` is required before this compiles.

abstract class _$DeleteAccountController
    extends $Notifier<DeleteAccountFlowState> {
  DeleteAccountFlowState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<DeleteAccountFlowState, DeleteAccountFlowState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DeleteAccountFlowState, DeleteAccountFlowState>,
        DeleteAccountFlowState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
