// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionState {
  String get accessToken;
  String get sub;
  String? get role;
  String get sid;
  bool get verified;
  String get subscriptionStatus;
  DateTime get accessTokenExpiresAt;

  /// Owner 2026-10-05 (docs/ops/demo-world.md): access-token claim `demo` —
  /// this session lives in the separate demo database. Every request
  /// then carries `X-LawBid-Demo: 1` (AuthInterceptor).
  bool get isDemo;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionStateCopyWith<SessionState> get copyWith =>
      _$SessionStateCopyWithImpl<SessionState>(
          this as SessionState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as SessionState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionState &&
            (identical(other.accessToken, _this.accessToken) ||
                other.accessToken == _this.accessToken) &&
            (identical(other.sub, _this.sub) || other.sub == _this.sub) &&
            (identical(other.role, _this.role) || other.role == _this.role) &&
            (identical(other.sid, _this.sid) || other.sid == _this.sid) &&
            (identical(other.verified, _this.verified) ||
                other.verified == _this.verified) &&
            (identical(other.subscriptionStatus, _this.subscriptionStatus) ||
                other.subscriptionStatus == _this.subscriptionStatus) &&
            (identical(
                    other.accessTokenExpiresAt, _this.accessTokenExpiresAt) ||
                other.accessTokenExpiresAt == _this.accessTokenExpiresAt) &&
            (identical(other.isDemo, _this.isDemo) ||
                other.isDemo == _this.isDemo));
  }

  @override
  int get hashCode {
    final _this = this as SessionState;
    return Object.hash(
        runtimeType,
        _this.accessToken,
        _this.sub,
        _this.role,
        _this.sid,
        _this.verified,
        _this.subscriptionStatus,
        _this.accessTokenExpiresAt,
        _this.isDemo);
  }

  @override
  String toString() {
    final _this = this as SessionState;
    return 'SessionState(accessToken: ${_this.accessToken}, sub: ${_this.sub}, role: ${_this.role}, sid: ${_this.sid}, verified: ${_this.verified}, subscriptionStatus: ${_this.subscriptionStatus}, accessTokenExpiresAt: ${_this.accessTokenExpiresAt}, isDemo: ${_this.isDemo})';
  }
}

/// @nodoc
abstract mixin class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
          SessionState value, $Res Function(SessionState) _then) =
      _$SessionStateCopyWithImpl;
  @useResult
  $Res call(
      {String accessToken,
      String sub,
      String? role,
      String sid,
      bool verified,
      String subscriptionStatus,
      DateTime accessTokenExpiresAt,
      bool isDemo});
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res> implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._self, this._then);

  final SessionState _self;
  final $Res Function(SessionState) _then;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? sub = null,
    Object? role = freezed,
    Object? sid = null,
    Object? verified = null,
    Object? subscriptionStatus = null,
    Object? accessTokenExpiresAt = null,
    Object? isDemo = null,
  }) {
    return _then(SessionState(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      sub: null == sub
          ? _self.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      sid: null == sid
          ? _self.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      verified: null == verified
          ? _self.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionStatus: null == subscriptionStatus
          ? _self.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      accessTokenExpiresAt: null == accessTokenExpiresAt
          ? _self.accessTokenExpiresAt
          : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDemo: null == isDemo
          ? _self.isDemo
          : isDemo // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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
    TResult Function(_SessionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionState() when $default != null:
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
    TResult Function(_SessionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionState():
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
    TResult? Function(_SessionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionState() when $default != null:
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
            String accessToken,
            String sub,
            String? role,
            String sid,
            bool verified,
            String subscriptionStatus,
            DateTime accessTokenExpiresAt,
            bool isDemo)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionState() when $default != null:
        return $default(
            _that.accessToken,
            _that.sub,
            _that.role,
            _that.sid,
            _that.verified,
            _that.subscriptionStatus,
            _that.accessTokenExpiresAt,
            _that.isDemo);
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
            String accessToken,
            String sub,
            String? role,
            String sid,
            bool verified,
            String subscriptionStatus,
            DateTime accessTokenExpiresAt,
            bool isDemo)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionState():
        return $default(
            _that.accessToken,
            _that.sub,
            _that.role,
            _that.sid,
            _that.verified,
            _that.subscriptionStatus,
            _that.accessTokenExpiresAt,
            _that.isDemo);
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
            String accessToken,
            String sub,
            String? role,
            String sid,
            bool verified,
            String subscriptionStatus,
            DateTime accessTokenExpiresAt,
            bool isDemo)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionState() when $default != null:
        return $default(
            _that.accessToken,
            _that.sub,
            _that.role,
            _that.sid,
            _that.verified,
            _that.subscriptionStatus,
            _that.accessTokenExpiresAt,
            _that.isDemo);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SessionState extends SessionState {
  const _SessionState(
      {required this.accessToken,
      required this.sub,
      required this.role,
      required this.sid,
      required this.verified,
      required this.subscriptionStatus,
      required this.accessTokenExpiresAt,
      this.isDemo = false})
      : super._();

  @override
  final String accessToken;
  @override
  final String sub;
  @override
  final String? role;
  @override
  final String sid;
  @override
  final bool verified;
  @override
  final String subscriptionStatus;
  @override
  final DateTime accessTokenExpiresAt;

  /// Owner 2026-10-05 (docs/ops/demo-world.md): access-token claim `demo` —
  /// this session lives in the separate demo database. Every request
  /// then carries `X-LawBid-Demo: 1` (AuthInterceptor).
  @override
  @JsonKey()
  final bool isDemo;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionStateCopyWith<_SessionState> get copyWith =>
      __$SessionStateCopyWithImpl<_SessionState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionState &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.sub, sub) || other.sub == sub) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.sid, sid) || other.sid == sid) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus) &&
            (identical(other.accessTokenExpiresAt, accessTokenExpiresAt) ||
                other.accessTokenExpiresAt == accessTokenExpiresAt) &&
            (identical(other.isDemo, isDemo) || other.isDemo == isDemo));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, accessToken, sub, role, sid, verified,
        subscriptionStatus, accessTokenExpiresAt, isDemo);
  }

  @override
  String toString() {
    return 'SessionState(accessToken: $accessToken, sub: $sub, role: $role, sid: $sid, verified: $verified, subscriptionStatus: $subscriptionStatus, accessTokenExpiresAt: $accessTokenExpiresAt, isDemo: $isDemo)';
  }
}

/// @nodoc
abstract mixin class _$SessionStateCopyWith<$Res>
    implements $SessionStateCopyWith<$Res> {
  factory _$SessionStateCopyWith(
          _SessionState value, $Res Function(_SessionState) _then) =
      __$SessionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String sub,
      String? role,
      String sid,
      bool verified,
      String subscriptionStatus,
      DateTime accessTokenExpiresAt,
      bool isDemo});
}

/// @nodoc
class __$SessionStateCopyWithImpl<$Res>
    implements _$SessionStateCopyWith<$Res> {
  __$SessionStateCopyWithImpl(this._self, this._then);

  final _SessionState _self;
  final $Res Function(_SessionState) _then;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accessToken = null,
    Object? sub = null,
    Object? role = freezed,
    Object? sid = null,
    Object? verified = null,
    Object? subscriptionStatus = null,
    Object? accessTokenExpiresAt = null,
    Object? isDemo = null,
  }) {
    return _then(_SessionState(
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      sub: null == sub
          ? _self.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      sid: null == sid
          ? _self.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String,
      verified: null == verified
          ? _self.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      subscriptionStatus: null == subscriptionStatus
          ? _self.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      accessTokenExpiresAt: null == accessTokenExpiresAt
          ? _self.accessTokenExpiresAt
          : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDemo: null == isDemo
          ? _self.isDemo
          : isDemo // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
