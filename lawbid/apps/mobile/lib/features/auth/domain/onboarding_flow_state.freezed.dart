// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingFlowState {
  OnboardingStep get step;
  AuthChannel get channel;

  /// E.164 phone or email the code was sent to.
  String? get identifier;
  UserRole? get selectedRole;
  bool get isSubmitting;
  String? get errorMessage;

  /// Owner 2026-10-05: the number belongs to a country LawBid is not
  /// open in yet (ISO code) — the phone screen offers the waiting list.
  String? get closedCountry;

  /// A code that arrived by itself — Android SMS Retriever (§10.2 D) —
  /// shown prefilled on the code
  /// screen while the flow verifies it. Null for a typed code.
  String? get autofilledCode;

  /// Create a copy of OnboardingFlowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OnboardingFlowStateCopyWith<OnboardingFlowState> get copyWith =>
      _$OnboardingFlowStateCopyWithImpl<OnboardingFlowState>(
          this as OnboardingFlowState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as OnboardingFlowState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnboardingFlowState &&
            (identical(other.step, _this.step) || other.step == _this.step) &&
            (identical(other.channel, _this.channel) ||
                other.channel == _this.channel) &&
            (identical(other.identifier, _this.identifier) ||
                other.identifier == _this.identifier) &&
            (identical(other.selectedRole, _this.selectedRole) ||
                other.selectedRole == _this.selectedRole) &&
            (identical(other.isSubmitting, _this.isSubmitting) ||
                other.isSubmitting == _this.isSubmitting) &&
            (identical(other.errorMessage, _this.errorMessage) ||
                other.errorMessage == _this.errorMessage) &&
            (identical(other.closedCountry, _this.closedCountry) ||
                other.closedCountry == _this.closedCountry) &&
            (identical(other.autofilledCode, _this.autofilledCode) ||
                other.autofilledCode == _this.autofilledCode));
  }

  @override
  int get hashCode {
    final _this = this as OnboardingFlowState;
    return Object.hash(
        runtimeType,
        _this.step,
        _this.channel,
        _this.identifier,
        _this.selectedRole,
        _this.isSubmitting,
        _this.errorMessage,
        _this.closedCountry,
        _this.autofilledCode);
  }

  @override
  String toString() {
    final _this = this as OnboardingFlowState;
    return 'OnboardingFlowState(step: ${_this.step}, channel: ${_this.channel}, identifier: ${_this.identifier}, selectedRole: ${_this.selectedRole}, isSubmitting: ${_this.isSubmitting}, errorMessage: ${_this.errorMessage}, closedCountry: ${_this.closedCountry}, autofilledCode: ${_this.autofilledCode})';
  }
}

/// @nodoc
abstract mixin class $OnboardingFlowStateCopyWith<$Res> {
  factory $OnboardingFlowStateCopyWith(
          OnboardingFlowState value, $Res Function(OnboardingFlowState) _then) =
      _$OnboardingFlowStateCopyWithImpl;
  @useResult
  $Res call(
      {OnboardingStep step,
      AuthChannel channel,
      String? identifier,
      UserRole? selectedRole,
      bool isSubmitting,
      String? errorMessage,
      String? closedCountry,
      String? autofilledCode});
}

/// @nodoc
class _$OnboardingFlowStateCopyWithImpl<$Res>
    implements $OnboardingFlowStateCopyWith<$Res> {
  _$OnboardingFlowStateCopyWithImpl(this._self, this._then);

  final OnboardingFlowState _self;
  final $Res Function(OnboardingFlowState) _then;

  /// Create a copy of OnboardingFlowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? channel = null,
    Object? identifier = freezed,
    Object? selectedRole = freezed,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
    Object? closedCountry = freezed,
    Object? autofilledCode = freezed,
  }) {
    return _then(OnboardingFlowState(
      step: null == step
          ? _self.step
          : step // ignore: cast_nullable_to_non_nullable
              as OnboardingStep,
      channel: null == channel
          ? _self.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as AuthChannel,
      identifier: freezed == identifier
          ? _self.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedRole: freezed == selectedRole
          ? _self.selectedRole
          : selectedRole // ignore: cast_nullable_to_non_nullable
              as UserRole?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      closedCountry: freezed == closedCountry
          ? _self.closedCountry
          : closedCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      autofilledCode: freezed == autofilledCode
          ? _self.autofilledCode
          : autofilledCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [OnboardingFlowState].
extension OnboardingFlowStatePatterns on OnboardingFlowState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_OnboardingFlowState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingFlowState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_OnboardingFlowState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingFlowState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_OnboardingFlowState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingFlowState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            OnboardingStep step,
            AuthChannel channel,
            String? identifier,
            UserRole? selectedRole,
            bool isSubmitting,
            String? errorMessage,
            String? closedCountry,
            String? autofilledCode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingFlowState() when $default != null:
        return $default(
            _that.step,
            _that.channel,
            _that.identifier,
            _that.selectedRole,
            _that.isSubmitting,
            _that.errorMessage,
            _that.closedCountry,
            _that.autofilledCode);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            OnboardingStep step,
            AuthChannel channel,
            String? identifier,
            UserRole? selectedRole,
            bool isSubmitting,
            String? errorMessage,
            String? closedCountry,
            String? autofilledCode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingFlowState():
        return $default(
            _that.step,
            _that.channel,
            _that.identifier,
            _that.selectedRole,
            _that.isSubmitting,
            _that.errorMessage,
            _that.closedCountry,
            _that.autofilledCode);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            OnboardingStep step,
            AuthChannel channel,
            String? identifier,
            UserRole? selectedRole,
            bool isSubmitting,
            String? errorMessage,
            String? closedCountry,
            String? autofilledCode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingFlowState() when $default != null:
        return $default(
            _that.step,
            _that.channel,
            _that.identifier,
            _that.selectedRole,
            _that.isSubmitting,
            _that.errorMessage,
            _that.closedCountry,
            _that.autofilledCode);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _OnboardingFlowState implements OnboardingFlowState {
  const _OnboardingFlowState(
      {this.step = OnboardingStep.welcome,
      this.channel = AuthChannel.phone,
      this.identifier,
      this.selectedRole,
      this.isSubmitting = false,
      this.errorMessage,
      this.closedCountry,
      this.autofilledCode});

  @override
  @JsonKey()
  final OnboardingStep step;
  @override
  @JsonKey()
  final AuthChannel channel;

  /// E.164 phone or email the code was sent to.
  @override
  final String? identifier;
  @override
  final UserRole? selectedRole;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? errorMessage;

  /// Owner 2026-10-05: the number belongs to a country LawBid is not
  /// open in yet (ISO code) — the phone screen offers the waiting list.
  @override
  final String? closedCountry;

  /// A code that arrived by itself — Android SMS Retriever (§10.2 D) —
  /// shown prefilled on the code
  /// screen while the flow verifies it. Null for a typed code.
  @override
  final String? autofilledCode;

  /// Create a copy of OnboardingFlowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OnboardingFlowStateCopyWith<_OnboardingFlowState> get copyWith =>
      __$OnboardingFlowStateCopyWithImpl<_OnboardingFlowState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OnboardingFlowState &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.selectedRole, selectedRole) ||
                other.selectedRole == selectedRole) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.closedCountry, closedCountry) ||
                other.closedCountry == closedCountry) &&
            (identical(other.autofilledCode, autofilledCode) ||
                other.autofilledCode == autofilledCode));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, step, channel, identifier, selectedRole,
        isSubmitting, errorMessage, closedCountry, autofilledCode);
  }

  @override
  String toString() {
    return 'OnboardingFlowState(step: $step, channel: $channel, identifier: $identifier, selectedRole: $selectedRole, isSubmitting: $isSubmitting, errorMessage: $errorMessage, closedCountry: $closedCountry, autofilledCode: $autofilledCode)';
  }
}

/// @nodoc
abstract mixin class _$OnboardingFlowStateCopyWith<$Res>
    implements $OnboardingFlowStateCopyWith<$Res> {
  factory _$OnboardingFlowStateCopyWith(_OnboardingFlowState value,
          $Res Function(_OnboardingFlowState) _then) =
      __$OnboardingFlowStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {OnboardingStep step,
      AuthChannel channel,
      String? identifier,
      UserRole? selectedRole,
      bool isSubmitting,
      String? errorMessage,
      String? closedCountry,
      String? autofilledCode});
}

/// @nodoc
class __$OnboardingFlowStateCopyWithImpl<$Res>
    implements _$OnboardingFlowStateCopyWith<$Res> {
  __$OnboardingFlowStateCopyWithImpl(this._self, this._then);

  final _OnboardingFlowState _self;
  final $Res Function(_OnboardingFlowState) _then;

  /// Create a copy of OnboardingFlowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? step = null,
    Object? channel = null,
    Object? identifier = freezed,
    Object? selectedRole = freezed,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
    Object? closedCountry = freezed,
    Object? autofilledCode = freezed,
  }) {
    return _then(_OnboardingFlowState(
      step: null == step
          ? _self.step
          : step // ignore: cast_nullable_to_non_nullable
              as OnboardingStep,
      channel: null == channel
          ? _self.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as AuthChannel,
      identifier: freezed == identifier
          ? _self.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedRole: freezed == selectedRole
          ? _self.selectedRole
          : selectedRole // ignore: cast_nullable_to_non_nullable
              as UserRole?,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      closedCountry: freezed == closedCountry
          ? _self.closedCountry
          : closedCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      autofilledCode: freezed == autofilledCode
          ? _self.autofilledCode
          : autofilledCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
