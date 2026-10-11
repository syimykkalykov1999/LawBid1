// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_flow.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the pre-session sign-in screens: welcome → phone|email → otp,
/// plus Apple/Google. After a successful sign-in it waits for
/// `GET /users/me` so AppRouterGuard's next decision already sees the
/// account (stage 1.7 mobile); where the user goes next — onboarding step
/// or feed — is decided by the guard, not here.
///
/// `keepAlive`: the phone/email screen and the code screen are separate
/// routes; the identifier must survive the push between them.

@ProviderFor(OnboardingFlow)
final onboardingFlowProvider = OnboardingFlowProvider._();

/// Drives the pre-session sign-in screens: welcome → phone|email → otp,
/// plus Apple/Google. After a successful sign-in it waits for
/// `GET /users/me` so AppRouterGuard's next decision already sees the
/// account (stage 1.7 mobile); where the user goes next — onboarding step
/// or feed — is decided by the guard, not here.
///
/// `keepAlive`: the phone/email screen and the code screen are separate
/// routes; the identifier must survive the push between them.
final class OnboardingFlowProvider
    extends $NotifierProvider<OnboardingFlow, OnboardingFlowState> {
  /// Drives the pre-session sign-in screens: welcome → phone|email → otp,
  /// plus Apple/Google. After a successful sign-in it waits for
  /// `GET /users/me` so AppRouterGuard's next decision already sees the
  /// account (stage 1.7 mobile); where the user goes next — onboarding step
  /// or feed — is decided by the guard, not here.
  ///
  /// `keepAlive`: the phone/email screen and the code screen are separate
  /// routes; the identifier must survive the push between them.
  OnboardingFlowProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'onboardingFlowProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$onboardingFlowHash();

  @$internal
  @override
  OnboardingFlow create() => OnboardingFlow();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingFlowState>(value),
    );
  }
}

String _$onboardingFlowHash() => r'f0b61ec0f3f6d00bc28a4435086ffe44a5210e67';

/// Drives the pre-session sign-in screens: welcome → phone|email → otp,
/// plus Apple/Google. After a successful sign-in it waits for
/// `GET /users/me` so AppRouterGuard's next decision already sees the
/// account (stage 1.7 mobile); where the user goes next — onboarding step
/// or feed — is decided by the guard, not here.
///
/// `keepAlive`: the phone/email screen and the code screen are separate
/// routes; the identifier must survive the push between them.

abstract class _$OnboardingFlow extends $Notifier<OnboardingFlowState> {
  OnboardingFlowState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OnboardingFlowState, OnboardingFlowState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<OnboardingFlowState, OnboardingFlowState>,
        OnboardingFlowState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
