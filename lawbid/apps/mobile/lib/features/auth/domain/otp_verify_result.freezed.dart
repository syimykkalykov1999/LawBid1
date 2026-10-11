// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_verify_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OtpVerifyResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OtpVerifyResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OtpVerifyResult()';
  }
}

/// @nodoc
class $OtpVerifyResultCopyWith<$Res> {
  $OtpVerifyResultCopyWith(
      OtpVerifyResult _, $Res Function(OtpVerifyResult) __);
}

/// Adds pattern-matching-related methods to [OtpVerifyResult].
extension OtpVerifyResultPatterns on OtpVerifyResult {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OtpVerifySuccess value)? success,
    TResult Function(OtpVerifyInvalid value)? invalid,
    TResult Function(OtpVerifyExpired value)? expired,
    TResult Function(OtpVerifyLocked value)? locked,
    TResult Function(OtpVerifyRateLimited value)? rateLimited,
    TResult Function(OtpVerifyNetworkError value)? networkError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OtpVerifySuccess() when success != null:
        return success(_that);
      case OtpVerifyInvalid() when invalid != null:
        return invalid(_that);
      case OtpVerifyExpired() when expired != null:
        return expired(_that);
      case OtpVerifyLocked() when locked != null:
        return locked(_that);
      case OtpVerifyRateLimited() when rateLimited != null:
        return rateLimited(_that);
      case OtpVerifyNetworkError() when networkError != null:
        return networkError(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(OtpVerifySuccess value) success,
    required TResult Function(OtpVerifyInvalid value) invalid,
    required TResult Function(OtpVerifyExpired value) expired,
    required TResult Function(OtpVerifyLocked value) locked,
    required TResult Function(OtpVerifyRateLimited value) rateLimited,
    required TResult Function(OtpVerifyNetworkError value) networkError,
  }) {
    final _that = this;
    switch (_that) {
      case OtpVerifySuccess():
        return success(_that);
      case OtpVerifyInvalid():
        return invalid(_that);
      case OtpVerifyExpired():
        return expired(_that);
      case OtpVerifyLocked():
        return locked(_that);
      case OtpVerifyRateLimited():
        return rateLimited(_that);
      case OtpVerifyNetworkError():
        return networkError(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OtpVerifySuccess value)? success,
    TResult? Function(OtpVerifyInvalid value)? invalid,
    TResult? Function(OtpVerifyExpired value)? expired,
    TResult? Function(OtpVerifyLocked value)? locked,
    TResult? Function(OtpVerifyRateLimited value)? rateLimited,
    TResult? Function(OtpVerifyNetworkError value)? networkError,
  }) {
    final _that = this;
    switch (_that) {
      case OtpVerifySuccess() when success != null:
        return success(_that);
      case OtpVerifyInvalid() when invalid != null:
        return invalid(_that);
      case OtpVerifyExpired() when expired != null:
        return expired(_that);
      case OtpVerifyLocked() when locked != null:
        return locked(_that);
      case OtpVerifyRateLimited() when rateLimited != null:
        return rateLimited(_that);
      case OtpVerifyNetworkError() when networkError != null:
        return networkError(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool isNewUser)? success,
    TResult Function()? invalid,
    TResult Function()? expired,
    TResult Function()? locked,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? networkError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case OtpVerifySuccess() when success != null:
        return success(_that.isNewUser);
      case OtpVerifyInvalid() when invalid != null:
        return invalid();
      case OtpVerifyExpired() when expired != null:
        return expired();
      case OtpVerifyLocked() when locked != null:
        return locked();
      case OtpVerifyRateLimited() when rateLimited != null:
        return rateLimited(_that.retryAfterSeconds);
      case OtpVerifyNetworkError() when networkError != null:
        return networkError();
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
  TResult when<TResult extends Object?>({
    required TResult Function(bool isNewUser) success,
    required TResult Function() invalid,
    required TResult Function() expired,
    required TResult Function() locked,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() networkError,
  }) {
    final _that = this;
    switch (_that) {
      case OtpVerifySuccess():
        return success(_that.isNewUser);
      case OtpVerifyInvalid():
        return invalid();
      case OtpVerifyExpired():
        return expired();
      case OtpVerifyLocked():
        return locked();
      case OtpVerifyRateLimited():
        return rateLimited(_that.retryAfterSeconds);
      case OtpVerifyNetworkError():
        return networkError();
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool isNewUser)? success,
    TResult? Function()? invalid,
    TResult? Function()? expired,
    TResult? Function()? locked,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? networkError,
  }) {
    final _that = this;
    switch (_that) {
      case OtpVerifySuccess() when success != null:
        return success(_that.isNewUser);
      case OtpVerifyInvalid() when invalid != null:
        return invalid();
      case OtpVerifyExpired() when expired != null:
        return expired();
      case OtpVerifyLocked() when locked != null:
        return locked();
      case OtpVerifyRateLimited() when rateLimited != null:
        return rateLimited(_that.retryAfterSeconds);
      case OtpVerifyNetworkError() when networkError != null:
        return networkError();
      case _:
        return null;
    }
  }
}

/// @nodoc

class OtpVerifySuccess implements OtpVerifyResult {
  const OtpVerifySuccess({required this.isNewUser});

  final bool isNewUser;

  /// Create a copy of OtpVerifyResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OtpVerifySuccessCopyWith<OtpVerifySuccess> get copyWith =>
      _$OtpVerifySuccessCopyWithImpl<OtpVerifySuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OtpVerifySuccess &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, isNewUser);
  }

  @override
  String toString() {
    return 'OtpVerifyResult.success(isNewUser: $isNewUser)';
  }
}

/// @nodoc
abstract mixin class $OtpVerifySuccessCopyWith<$Res>
    implements $OtpVerifyResultCopyWith<$Res> {
  factory $OtpVerifySuccessCopyWith(
          OtpVerifySuccess value, $Res Function(OtpVerifySuccess) _then) =
      _$OtpVerifySuccessCopyWithImpl;
  @useResult
  $Res call({bool isNewUser});
}

/// @nodoc
class _$OtpVerifySuccessCopyWithImpl<$Res>
    implements $OtpVerifySuccessCopyWith<$Res> {
  _$OtpVerifySuccessCopyWithImpl(this._self, this._then);

  final OtpVerifySuccess _self;
  final $Res Function(OtpVerifySuccess) _then;

  /// Create a copy of OtpVerifyResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isNewUser = null,
  }) {
    return _then(OtpVerifySuccess(
      isNewUser: null == isNewUser
          ? _self.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class OtpVerifyInvalid implements OtpVerifyResult {
  const OtpVerifyInvalid();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OtpVerifyInvalid);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OtpVerifyResult.invalid()';
  }
}

/// @nodoc

class OtpVerifyExpired implements OtpVerifyResult {
  const OtpVerifyExpired();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OtpVerifyExpired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OtpVerifyResult.expired()';
  }
}

/// @nodoc

class OtpVerifyLocked implements OtpVerifyResult {
  const OtpVerifyLocked();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OtpVerifyLocked);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OtpVerifyResult.locked()';
  }
}

/// @nodoc

class OtpVerifyRateLimited implements OtpVerifyResult {
  const OtpVerifyRateLimited(this.retryAfterSeconds);

  final int retryAfterSeconds;

  /// Create a copy of OtpVerifyResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OtpVerifyRateLimitedCopyWith<OtpVerifyRateLimited> get copyWith =>
      _$OtpVerifyRateLimitedCopyWithImpl<OtpVerifyRateLimited>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OtpVerifyRateLimited &&
            (identical(other.retryAfterSeconds, retryAfterSeconds) ||
                other.retryAfterSeconds == retryAfterSeconds));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, retryAfterSeconds);
  }

  @override
  String toString() {
    return 'OtpVerifyResult.rateLimited(retryAfterSeconds: $retryAfterSeconds)';
  }
}

/// @nodoc
abstract mixin class $OtpVerifyRateLimitedCopyWith<$Res>
    implements $OtpVerifyResultCopyWith<$Res> {
  factory $OtpVerifyRateLimitedCopyWith(OtpVerifyRateLimited value,
          $Res Function(OtpVerifyRateLimited) _then) =
      _$OtpVerifyRateLimitedCopyWithImpl;
  @useResult
  $Res call({int retryAfterSeconds});
}

/// @nodoc
class _$OtpVerifyRateLimitedCopyWithImpl<$Res>
    implements $OtpVerifyRateLimitedCopyWith<$Res> {
  _$OtpVerifyRateLimitedCopyWithImpl(this._self, this._then);

  final OtpVerifyRateLimited _self;
  final $Res Function(OtpVerifyRateLimited) _then;

  /// Create a copy of OtpVerifyResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? retryAfterSeconds = null,
  }) {
    return _then(OtpVerifyRateLimited(
      null == retryAfterSeconds
          ? _self.retryAfterSeconds
          : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class OtpVerifyNetworkError implements OtpVerifyResult {
  const OtpVerifyNetworkError();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OtpVerifyNetworkError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OtpVerifyResult.networkError()';
  }
}

// dart format on
