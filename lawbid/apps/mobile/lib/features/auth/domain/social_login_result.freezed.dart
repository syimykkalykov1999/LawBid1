// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_login_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SocialLoginResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SocialLoginResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SocialLoginResult()';
  }
}

/// @nodoc
class $SocialLoginResultCopyWith<$Res> {
  $SocialLoginResultCopyWith(
      SocialLoginResult _, $Res Function(SocialLoginResult) __);
}

/// Adds pattern-matching-related methods to [SocialLoginResult].
extension SocialLoginResultPatterns on SocialLoginResult {
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
    TResult Function(SocialLoginSuccess value)? success,
    TResult Function(SocialLoginCancelled value)? cancelled,
    TResult Function(SocialLoginInvalidToken value)? invalidToken,
    TResult Function(SocialLoginProviderDisabled value)? providerDisabled,
    TResult Function(SocialLoginAccountExists value)? accountExists,
    TResult Function(SocialLoginSuspended value)? suspended,
    TResult Function(SocialLoginDeleted value)? deleted,
    TResult Function(SocialLoginNetworkError value)? networkError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SocialLoginSuccess() when success != null:
        return success(_that);
      case SocialLoginCancelled() when cancelled != null:
        return cancelled(_that);
      case SocialLoginInvalidToken() when invalidToken != null:
        return invalidToken(_that);
      case SocialLoginProviderDisabled() when providerDisabled != null:
        return providerDisabled(_that);
      case SocialLoginAccountExists() when accountExists != null:
        return accountExists(_that);
      case SocialLoginSuspended() when suspended != null:
        return suspended(_that);
      case SocialLoginDeleted() when deleted != null:
        return deleted(_that);
      case SocialLoginNetworkError() when networkError != null:
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
    required TResult Function(SocialLoginSuccess value) success,
    required TResult Function(SocialLoginCancelled value) cancelled,
    required TResult Function(SocialLoginInvalidToken value) invalidToken,
    required TResult Function(SocialLoginProviderDisabled value)
        providerDisabled,
    required TResult Function(SocialLoginAccountExists value) accountExists,
    required TResult Function(SocialLoginSuspended value) suspended,
    required TResult Function(SocialLoginDeleted value) deleted,
    required TResult Function(SocialLoginNetworkError value) networkError,
  }) {
    final _that = this;
    switch (_that) {
      case SocialLoginSuccess():
        return success(_that);
      case SocialLoginCancelled():
        return cancelled(_that);
      case SocialLoginInvalidToken():
        return invalidToken(_that);
      case SocialLoginProviderDisabled():
        return providerDisabled(_that);
      case SocialLoginAccountExists():
        return accountExists(_that);
      case SocialLoginSuspended():
        return suspended(_that);
      case SocialLoginDeleted():
        return deleted(_that);
      case SocialLoginNetworkError():
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
    TResult? Function(SocialLoginSuccess value)? success,
    TResult? Function(SocialLoginCancelled value)? cancelled,
    TResult? Function(SocialLoginInvalidToken value)? invalidToken,
    TResult? Function(SocialLoginProviderDisabled value)? providerDisabled,
    TResult? Function(SocialLoginAccountExists value)? accountExists,
    TResult? Function(SocialLoginSuspended value)? suspended,
    TResult? Function(SocialLoginDeleted value)? deleted,
    TResult? Function(SocialLoginNetworkError value)? networkError,
  }) {
    final _that = this;
    switch (_that) {
      case SocialLoginSuccess() when success != null:
        return success(_that);
      case SocialLoginCancelled() when cancelled != null:
        return cancelled(_that);
      case SocialLoginInvalidToken() when invalidToken != null:
        return invalidToken(_that);
      case SocialLoginProviderDisabled() when providerDisabled != null:
        return providerDisabled(_that);
      case SocialLoginAccountExists() when accountExists != null:
        return accountExists(_that);
      case SocialLoginSuspended() when suspended != null:
        return suspended(_that);
      case SocialLoginDeleted() when deleted != null:
        return deleted(_that);
      case SocialLoginNetworkError() when networkError != null:
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
    TResult Function()? cancelled,
    TResult Function()? invalidToken,
    TResult Function()? providerDisabled,
    TResult Function(String maskedIdentifier, List<String> availableMethods)?
        accountExists,
    TResult Function()? suspended,
    TResult Function()? deleted,
    TResult Function()? networkError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SocialLoginSuccess() when success != null:
        return success(_that.isNewUser);
      case SocialLoginCancelled() when cancelled != null:
        return cancelled();
      case SocialLoginInvalidToken() when invalidToken != null:
        return invalidToken();
      case SocialLoginProviderDisabled() when providerDisabled != null:
        return providerDisabled();
      case SocialLoginAccountExists() when accountExists != null:
        return accountExists(_that.maskedIdentifier, _that.availableMethods);
      case SocialLoginSuspended() when suspended != null:
        return suspended();
      case SocialLoginDeleted() when deleted != null:
        return deleted();
      case SocialLoginNetworkError() when networkError != null:
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
    required TResult Function() cancelled,
    required TResult Function() invalidToken,
    required TResult Function() providerDisabled,
    required TResult Function(
            String maskedIdentifier, List<String> availableMethods)
        accountExists,
    required TResult Function() suspended,
    required TResult Function() deleted,
    required TResult Function() networkError,
  }) {
    final _that = this;
    switch (_that) {
      case SocialLoginSuccess():
        return success(_that.isNewUser);
      case SocialLoginCancelled():
        return cancelled();
      case SocialLoginInvalidToken():
        return invalidToken();
      case SocialLoginProviderDisabled():
        return providerDisabled();
      case SocialLoginAccountExists():
        return accountExists(_that.maskedIdentifier, _that.availableMethods);
      case SocialLoginSuspended():
        return suspended();
      case SocialLoginDeleted():
        return deleted();
      case SocialLoginNetworkError():
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
    TResult? Function()? cancelled,
    TResult? Function()? invalidToken,
    TResult? Function()? providerDisabled,
    TResult? Function(String maskedIdentifier, List<String> availableMethods)?
        accountExists,
    TResult? Function()? suspended,
    TResult? Function()? deleted,
    TResult? Function()? networkError,
  }) {
    final _that = this;
    switch (_that) {
      case SocialLoginSuccess() when success != null:
        return success(_that.isNewUser);
      case SocialLoginCancelled() when cancelled != null:
        return cancelled();
      case SocialLoginInvalidToken() when invalidToken != null:
        return invalidToken();
      case SocialLoginProviderDisabled() when providerDisabled != null:
        return providerDisabled();
      case SocialLoginAccountExists() when accountExists != null:
        return accountExists(_that.maskedIdentifier, _that.availableMethods);
      case SocialLoginSuspended() when suspended != null:
        return suspended();
      case SocialLoginDeleted() when deleted != null:
        return deleted();
      case SocialLoginNetworkError() when networkError != null:
        return networkError();
      case _:
        return null;
    }
  }
}

/// @nodoc

class SocialLoginSuccess implements SocialLoginResult {
  const SocialLoginSuccess({required this.isNewUser});

  final bool isNewUser;

  /// Create a copy of SocialLoginResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SocialLoginSuccessCopyWith<SocialLoginSuccess> get copyWith =>
      _$SocialLoginSuccessCopyWithImpl<SocialLoginSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SocialLoginSuccess &&
            (identical(other.isNewUser, isNewUser) ||
                other.isNewUser == isNewUser));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, isNewUser);
  }

  @override
  String toString() {
    return 'SocialLoginResult.success(isNewUser: $isNewUser)';
  }
}

/// @nodoc
abstract mixin class $SocialLoginSuccessCopyWith<$Res>
    implements $SocialLoginResultCopyWith<$Res> {
  factory $SocialLoginSuccessCopyWith(
          SocialLoginSuccess value, $Res Function(SocialLoginSuccess) _then) =
      _$SocialLoginSuccessCopyWithImpl;
  @useResult
  $Res call({bool isNewUser});
}

/// @nodoc
class _$SocialLoginSuccessCopyWithImpl<$Res>
    implements $SocialLoginSuccessCopyWith<$Res> {
  _$SocialLoginSuccessCopyWithImpl(this._self, this._then);

  final SocialLoginSuccess _self;
  final $Res Function(SocialLoginSuccess) _then;

  /// Create a copy of SocialLoginResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isNewUser = null,
  }) {
    return _then(SocialLoginSuccess(
      isNewUser: null == isNewUser
          ? _self.isNewUser
          : isNewUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class SocialLoginCancelled implements SocialLoginResult {
  const SocialLoginCancelled();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SocialLoginCancelled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SocialLoginResult.cancelled()';
  }
}

/// @nodoc

class SocialLoginInvalidToken implements SocialLoginResult {
  const SocialLoginInvalidToken();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SocialLoginInvalidToken);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SocialLoginResult.invalidToken()';
  }
}

/// @nodoc

class SocialLoginProviderDisabled implements SocialLoginResult {
  const SocialLoginProviderDisabled();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SocialLoginProviderDisabled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SocialLoginResult.providerDisabled()';
  }
}

/// @nodoc

class SocialLoginAccountExists implements SocialLoginResult {
  const SocialLoginAccountExists(
      {required this.maskedIdentifier, required List<String> availableMethods})
      : _availableMethods = availableMethods;

  final String maskedIdentifier;
  final List<String> _availableMethods;
  List<String> get availableMethods {
    if (_availableMethods is EqualUnmodifiableListView)
      return _availableMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableMethods);
  }

  /// Create a copy of SocialLoginResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SocialLoginAccountExistsCopyWith<SocialLoginAccountExists> get copyWith =>
      _$SocialLoginAccountExistsCopyWithImpl<SocialLoginAccountExists>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SocialLoginAccountExists &&
            (identical(other.maskedIdentifier, maskedIdentifier) ||
                other.maskedIdentifier == maskedIdentifier) &&
            const DeepCollectionEquality()
                .equals(other.availableMethods, _availableMethods));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, maskedIdentifier,
        const DeepCollectionEquality().hash(_availableMethods));
  }

  @override
  String toString() {
    return 'SocialLoginResult.accountExists(maskedIdentifier: $maskedIdentifier, availableMethods: $availableMethods)';
  }
}

/// @nodoc
abstract mixin class $SocialLoginAccountExistsCopyWith<$Res>
    implements $SocialLoginResultCopyWith<$Res> {
  factory $SocialLoginAccountExistsCopyWith(SocialLoginAccountExists value,
          $Res Function(SocialLoginAccountExists) _then) =
      _$SocialLoginAccountExistsCopyWithImpl;
  @useResult
  $Res call({String maskedIdentifier, List<String> availableMethods});
}

/// @nodoc
class _$SocialLoginAccountExistsCopyWithImpl<$Res>
    implements $SocialLoginAccountExistsCopyWith<$Res> {
  _$SocialLoginAccountExistsCopyWithImpl(this._self, this._then);

  final SocialLoginAccountExists _self;
  final $Res Function(SocialLoginAccountExists) _then;

  /// Create a copy of SocialLoginResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? maskedIdentifier = null,
    Object? availableMethods = null,
  }) {
    return _then(SocialLoginAccountExists(
      maskedIdentifier: null == maskedIdentifier
          ? _self.maskedIdentifier
          : maskedIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      availableMethods: null == availableMethods
          ? _self._availableMethods
          : availableMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class SocialLoginSuspended implements SocialLoginResult {
  const SocialLoginSuspended();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SocialLoginSuspended);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SocialLoginResult.suspended()';
  }
}

/// @nodoc

class SocialLoginDeleted implements SocialLoginResult {
  const SocialLoginDeleted();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SocialLoginDeleted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SocialLoginResult.deleted()';
  }
}

/// @nodoc

class SocialLoginNetworkError implements SocialLoginResult {
  const SocialLoginNetworkError();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SocialLoginNetworkError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SocialLoginResult.networkError()';
  }
}

// dart format on
