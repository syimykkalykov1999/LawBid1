// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reauth_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReauthResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReauthResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReauthResult()';
  }
}

/// @nodoc
class $ReauthResultCopyWith<$Res> {
  $ReauthResultCopyWith(ReauthResult _, $Res Function(ReauthResult) __);
}

/// Adds pattern-matching-related methods to [ReauthResult].
extension ReauthResultPatterns on ReauthResult {
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
    TResult Function(ReauthSuccess value)? success,
    TResult Function(ReauthInvalid value)? invalid,
    TResult Function(ReauthRateLimited value)? rateLimited,
    TResult Function(ReauthNetworkError value)? networkError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ReauthSuccess() when success != null:
        return success(_that);
      case ReauthInvalid() when invalid != null:
        return invalid(_that);
      case ReauthRateLimited() when rateLimited != null:
        return rateLimited(_that);
      case ReauthNetworkError() when networkError != null:
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
    required TResult Function(ReauthSuccess value) success,
    required TResult Function(ReauthInvalid value) invalid,
    required TResult Function(ReauthRateLimited value) rateLimited,
    required TResult Function(ReauthNetworkError value) networkError,
  }) {
    final _that = this;
    switch (_that) {
      case ReauthSuccess():
        return success(_that);
      case ReauthInvalid():
        return invalid(_that);
      case ReauthRateLimited():
        return rateLimited(_that);
      case ReauthNetworkError():
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
    TResult? Function(ReauthSuccess value)? success,
    TResult? Function(ReauthInvalid value)? invalid,
    TResult? Function(ReauthRateLimited value)? rateLimited,
    TResult? Function(ReauthNetworkError value)? networkError,
  }) {
    final _that = this;
    switch (_that) {
      case ReauthSuccess() when success != null:
        return success(_that);
      case ReauthInvalid() when invalid != null:
        return invalid(_that);
      case ReauthRateLimited() when rateLimited != null:
        return rateLimited(_that);
      case ReauthNetworkError() when networkError != null:
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
    TResult Function(String reauthToken)? success,
    TResult Function()? invalid,
    TResult Function(int retryAfterSeconds)? rateLimited,
    TResult Function()? networkError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ReauthSuccess() when success != null:
        return success(_that.reauthToken);
      case ReauthInvalid() when invalid != null:
        return invalid();
      case ReauthRateLimited() when rateLimited != null:
        return rateLimited(_that.retryAfterSeconds);
      case ReauthNetworkError() when networkError != null:
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
    required TResult Function(String reauthToken) success,
    required TResult Function() invalid,
    required TResult Function(int retryAfterSeconds) rateLimited,
    required TResult Function() networkError,
  }) {
    final _that = this;
    switch (_that) {
      case ReauthSuccess():
        return success(_that.reauthToken);
      case ReauthInvalid():
        return invalid();
      case ReauthRateLimited():
        return rateLimited(_that.retryAfterSeconds);
      case ReauthNetworkError():
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
    TResult? Function(String reauthToken)? success,
    TResult? Function()? invalid,
    TResult? Function(int retryAfterSeconds)? rateLimited,
    TResult? Function()? networkError,
  }) {
    final _that = this;
    switch (_that) {
      case ReauthSuccess() when success != null:
        return success(_that.reauthToken);
      case ReauthInvalid() when invalid != null:
        return invalid();
      case ReauthRateLimited() when rateLimited != null:
        return rateLimited(_that.retryAfterSeconds);
      case ReauthNetworkError() when networkError != null:
        return networkError();
      case _:
        return null;
    }
  }
}

/// @nodoc

class ReauthSuccess implements ReauthResult {
  const ReauthSuccess({required this.reauthToken});

  final String reauthToken;

  /// Create a copy of ReauthResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReauthSuccessCopyWith<ReauthSuccess> get copyWith =>
      _$ReauthSuccessCopyWithImpl<ReauthSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReauthSuccess &&
            (identical(other.reauthToken, reauthToken) ||
                other.reauthToken == reauthToken));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, reauthToken);
  }

  @override
  String toString() {
    return 'ReauthResult.success(reauthToken: $reauthToken)';
  }
}

/// @nodoc
abstract mixin class $ReauthSuccessCopyWith<$Res>
    implements $ReauthResultCopyWith<$Res> {
  factory $ReauthSuccessCopyWith(
          ReauthSuccess value, $Res Function(ReauthSuccess) _then) =
      _$ReauthSuccessCopyWithImpl;
  @useResult
  $Res call({String reauthToken});
}

/// @nodoc
class _$ReauthSuccessCopyWithImpl<$Res>
    implements $ReauthSuccessCopyWith<$Res> {
  _$ReauthSuccessCopyWithImpl(this._self, this._then);

  final ReauthSuccess _self;
  final $Res Function(ReauthSuccess) _then;

  /// Create a copy of ReauthResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reauthToken = null,
  }) {
    return _then(ReauthSuccess(
      reauthToken: null == reauthToken
          ? _self.reauthToken
          : reauthToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class ReauthInvalid implements ReauthResult {
  const ReauthInvalid();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReauthInvalid);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReauthResult.invalid()';
  }
}

/// @nodoc

class ReauthRateLimited implements ReauthResult {
  const ReauthRateLimited(this.retryAfterSeconds);

  final int retryAfterSeconds;

  /// Create a copy of ReauthResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReauthRateLimitedCopyWith<ReauthRateLimited> get copyWith =>
      _$ReauthRateLimitedCopyWithImpl<ReauthRateLimited>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReauthRateLimited &&
            (identical(other.retryAfterSeconds, retryAfterSeconds) ||
                other.retryAfterSeconds == retryAfterSeconds));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, retryAfterSeconds);
  }

  @override
  String toString() {
    return 'ReauthResult.rateLimited(retryAfterSeconds: $retryAfterSeconds)';
  }
}

/// @nodoc
abstract mixin class $ReauthRateLimitedCopyWith<$Res>
    implements $ReauthResultCopyWith<$Res> {
  factory $ReauthRateLimitedCopyWith(
          ReauthRateLimited value, $Res Function(ReauthRateLimited) _then) =
      _$ReauthRateLimitedCopyWithImpl;
  @useResult
  $Res call({int retryAfterSeconds});
}

/// @nodoc
class _$ReauthRateLimitedCopyWithImpl<$Res>
    implements $ReauthRateLimitedCopyWith<$Res> {
  _$ReauthRateLimitedCopyWithImpl(this._self, this._then);

  final ReauthRateLimited _self;
  final $Res Function(ReauthRateLimited) _then;

  /// Create a copy of ReauthResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? retryAfterSeconds = null,
  }) {
    return _then(ReauthRateLimited(
      null == retryAfterSeconds
          ? _self.retryAfterSeconds
          : retryAfterSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class ReauthNetworkError implements ReauthResult {
  const ReauthNetworkError();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReauthNetworkError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReauthResult.networkError()';
  }
}

// dart format on
