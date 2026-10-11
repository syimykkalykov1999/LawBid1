// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteAccountFlowState {
  DeleteAccountStep get step;
  bool get biometricAvailable;
  String? get phoneNumber;
  bool get codeRequested;
  String? get reauthToken;
  String get confirmPhraseInput;
  bool get isSubmitting;
  String? get errorMessage;

  /// Create a copy of DeleteAccountFlowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteAccountFlowStateCopyWith<DeleteAccountFlowState> get copyWith =>
      _$DeleteAccountFlowStateCopyWithImpl<DeleteAccountFlowState>(
          this as DeleteAccountFlowState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as DeleteAccountFlowState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteAccountFlowState &&
            (identical(other.step, _this.step) || other.step == _this.step) &&
            (identical(other.biometricAvailable, _this.biometricAvailable) ||
                other.biometricAvailable == _this.biometricAvailable) &&
            (identical(other.phoneNumber, _this.phoneNumber) ||
                other.phoneNumber == _this.phoneNumber) &&
            (identical(other.codeRequested, _this.codeRequested) ||
                other.codeRequested == _this.codeRequested) &&
            (identical(other.reauthToken, _this.reauthToken) ||
                other.reauthToken == _this.reauthToken) &&
            (identical(other.confirmPhraseInput, _this.confirmPhraseInput) ||
                other.confirmPhraseInput == _this.confirmPhraseInput) &&
            (identical(other.isSubmitting, _this.isSubmitting) ||
                other.isSubmitting == _this.isSubmitting) &&
            (identical(other.errorMessage, _this.errorMessage) ||
                other.errorMessage == _this.errorMessage));
  }

  @override
  int get hashCode {
    final _this = this as DeleteAccountFlowState;
    return Object.hash(
        runtimeType,
        _this.step,
        _this.biometricAvailable,
        _this.phoneNumber,
        _this.codeRequested,
        _this.reauthToken,
        _this.confirmPhraseInput,
        _this.isSubmitting,
        _this.errorMessage);
  }

  @override
  String toString() {
    final _this = this as DeleteAccountFlowState;
    return 'DeleteAccountFlowState(step: ${_this.step}, biometricAvailable: ${_this.biometricAvailable}, phoneNumber: ${_this.phoneNumber}, codeRequested: ${_this.codeRequested}, reauthToken: ${_this.reauthToken}, confirmPhraseInput: ${_this.confirmPhraseInput}, isSubmitting: ${_this.isSubmitting}, errorMessage: ${_this.errorMessage})';
  }
}

/// @nodoc
abstract mixin class $DeleteAccountFlowStateCopyWith<$Res> {
  factory $DeleteAccountFlowStateCopyWith(DeleteAccountFlowState value,
          $Res Function(DeleteAccountFlowState) _then) =
      _$DeleteAccountFlowStateCopyWithImpl;
  @useResult
  $Res call(
      {DeleteAccountStep step,
      bool biometricAvailable,
      String? phoneNumber,
      bool codeRequested,
      String? reauthToken,
      String confirmPhraseInput,
      bool isSubmitting,
      String? errorMessage});
}

/// @nodoc
class _$DeleteAccountFlowStateCopyWithImpl<$Res>
    implements $DeleteAccountFlowStateCopyWith<$Res> {
  _$DeleteAccountFlowStateCopyWithImpl(this._self, this._then);

  final DeleteAccountFlowState _self;
  final $Res Function(DeleteAccountFlowState) _then;

  /// Create a copy of DeleteAccountFlowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? biometricAvailable = null,
    Object? phoneNumber = freezed,
    Object? codeRequested = null,
    Object? reauthToken = freezed,
    Object? confirmPhraseInput = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(DeleteAccountFlowState(
      step: null == step
          ? _self.step
          : step // ignore: cast_nullable_to_non_nullable
              as DeleteAccountStep,
      biometricAvailable: null == biometricAvailable
          ? _self.biometricAvailable
          : biometricAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      codeRequested: null == codeRequested
          ? _self.codeRequested
          : codeRequested // ignore: cast_nullable_to_non_nullable
              as bool,
      reauthToken: freezed == reauthToken
          ? _self.reauthToken
          : reauthToken // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmPhraseInput: null == confirmPhraseInput
          ? _self.confirmPhraseInput
          : confirmPhraseInput // ignore: cast_nullable_to_non_nullable
              as String,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [DeleteAccountFlowState].
extension DeleteAccountFlowStatePatterns on DeleteAccountFlowState {
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
    TResult Function(_DeleteAccountFlowState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountFlowState() when $default != null:
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
    TResult Function(_DeleteAccountFlowState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountFlowState():
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
    TResult? Function(_DeleteAccountFlowState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountFlowState() when $default != null:
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
            DeleteAccountStep step,
            bool biometricAvailable,
            String? phoneNumber,
            bool codeRequested,
            String? reauthToken,
            String confirmPhraseInput,
            bool isSubmitting,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountFlowState() when $default != null:
        return $default(
            _that.step,
            _that.biometricAvailable,
            _that.phoneNumber,
            _that.codeRequested,
            _that.reauthToken,
            _that.confirmPhraseInput,
            _that.isSubmitting,
            _that.errorMessage);
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
            DeleteAccountStep step,
            bool biometricAvailable,
            String? phoneNumber,
            bool codeRequested,
            String? reauthToken,
            String confirmPhraseInput,
            bool isSubmitting,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountFlowState():
        return $default(
            _that.step,
            _that.biometricAvailable,
            _that.phoneNumber,
            _that.codeRequested,
            _that.reauthToken,
            _that.confirmPhraseInput,
            _that.isSubmitting,
            _that.errorMessage);
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
            DeleteAccountStep step,
            bool biometricAvailable,
            String? phoneNumber,
            bool codeRequested,
            String? reauthToken,
            String confirmPhraseInput,
            bool isSubmitting,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DeleteAccountFlowState() when $default != null:
        return $default(
            _that.step,
            _that.biometricAvailable,
            _that.phoneNumber,
            _that.codeRequested,
            _that.reauthToken,
            _that.confirmPhraseInput,
            _that.isSubmitting,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DeleteAccountFlowState implements DeleteAccountFlowState {
  const _DeleteAccountFlowState(
      {this.step = DeleteAccountStep.warning,
      this.biometricAvailable = false,
      this.phoneNumber,
      this.codeRequested = false,
      this.reauthToken,
      this.confirmPhraseInput = '',
      this.isSubmitting = false,
      this.errorMessage});

  @override
  @JsonKey()
  final DeleteAccountStep step;
  @override
  @JsonKey()
  final bool biometricAvailable;
  @override
  final String? phoneNumber;
  @override
  @JsonKey()
  final bool codeRequested;
  @override
  final String? reauthToken;
  @override
  @JsonKey()
  final String confirmPhraseInput;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final String? errorMessage;

  /// Create a copy of DeleteAccountFlowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeleteAccountFlowStateCopyWith<_DeleteAccountFlowState> get copyWith =>
      __$DeleteAccountFlowStateCopyWithImpl<_DeleteAccountFlowState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeleteAccountFlowState &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.biometricAvailable, biometricAvailable) ||
                other.biometricAvailable == biometricAvailable) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.codeRequested, codeRequested) ||
                other.codeRequested == codeRequested) &&
            (identical(other.reauthToken, reauthToken) ||
                other.reauthToken == reauthToken) &&
            (identical(other.confirmPhraseInput, confirmPhraseInput) ||
                other.confirmPhraseInput == confirmPhraseInput) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        step,
        biometricAvailable,
        phoneNumber,
        codeRequested,
        reauthToken,
        confirmPhraseInput,
        isSubmitting,
        errorMessage);
  }

  @override
  String toString() {
    return 'DeleteAccountFlowState(step: $step, biometricAvailable: $biometricAvailable, phoneNumber: $phoneNumber, codeRequested: $codeRequested, reauthToken: $reauthToken, confirmPhraseInput: $confirmPhraseInput, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$DeleteAccountFlowStateCopyWith<$Res>
    implements $DeleteAccountFlowStateCopyWith<$Res> {
  factory _$DeleteAccountFlowStateCopyWith(_DeleteAccountFlowState value,
          $Res Function(_DeleteAccountFlowState) _then) =
      __$DeleteAccountFlowStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {DeleteAccountStep step,
      bool biometricAvailable,
      String? phoneNumber,
      bool codeRequested,
      String? reauthToken,
      String confirmPhraseInput,
      bool isSubmitting,
      String? errorMessage});
}

/// @nodoc
class __$DeleteAccountFlowStateCopyWithImpl<$Res>
    implements _$DeleteAccountFlowStateCopyWith<$Res> {
  __$DeleteAccountFlowStateCopyWithImpl(this._self, this._then);

  final _DeleteAccountFlowState _self;
  final $Res Function(_DeleteAccountFlowState) _then;

  /// Create a copy of DeleteAccountFlowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? step = null,
    Object? biometricAvailable = null,
    Object? phoneNumber = freezed,
    Object? codeRequested = null,
    Object? reauthToken = freezed,
    Object? confirmPhraseInput = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_DeleteAccountFlowState(
      step: null == step
          ? _self.step
          : step // ignore: cast_nullable_to_non_nullable
              as DeleteAccountStep,
      biometricAvailable: null == biometricAvailable
          ? _self.biometricAvailable
          : biometricAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      codeRequested: null == codeRequested
          ? _self.codeRequested
          : codeRequested // ignore: cast_nullable_to_non_nullable
              as bool,
      reauthToken: freezed == reauthToken
          ? _self.reauthToken
          : reauthToken // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmPhraseInput: null == confirmPhraseInput
          ? _self.confirmPhraseInput
          : confirmPhraseInput // ignore: cast_nullable_to_non_nullable
              as String,
      isSubmitting: null == isSubmitting
          ? _self.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
