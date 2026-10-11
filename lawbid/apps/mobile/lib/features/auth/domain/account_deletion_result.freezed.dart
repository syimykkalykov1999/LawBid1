// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_deletion_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountDeletionResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AccountDeletionResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountDeletionResult()';
  }
}

/// @nodoc
class $AccountDeletionResultCopyWith<$Res> {
  $AccountDeletionResultCopyWith(
      AccountDeletionResult _, $Res Function(AccountDeletionResult) __);
}

/// Adds pattern-matching-related methods to [AccountDeletionResult].
extension AccountDeletionResultPatterns on AccountDeletionResult {
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
    TResult Function(AccountDeletionSuccess value)? success,
    TResult Function(AccountDeletionReauthRequired value)? reauthRequired,
    TResult Function(AccountDeletionReauthInvalid value)? reauthInvalid,
    TResult Function(AccountDeletionNetworkError value)? networkError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AccountDeletionSuccess() when success != null:
        return success(_that);
      case AccountDeletionReauthRequired() when reauthRequired != null:
        return reauthRequired(_that);
      case AccountDeletionReauthInvalid() when reauthInvalid != null:
        return reauthInvalid(_that);
      case AccountDeletionNetworkError() when networkError != null:
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
    required TResult Function(AccountDeletionSuccess value) success,
    required TResult Function(AccountDeletionReauthRequired value)
        reauthRequired,
    required TResult Function(AccountDeletionReauthInvalid value) reauthInvalid,
    required TResult Function(AccountDeletionNetworkError value) networkError,
  }) {
    final _that = this;
    switch (_that) {
      case AccountDeletionSuccess():
        return success(_that);
      case AccountDeletionReauthRequired():
        return reauthRequired(_that);
      case AccountDeletionReauthInvalid():
        return reauthInvalid(_that);
      case AccountDeletionNetworkError():
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
    TResult? Function(AccountDeletionSuccess value)? success,
    TResult? Function(AccountDeletionReauthRequired value)? reauthRequired,
    TResult? Function(AccountDeletionReauthInvalid value)? reauthInvalid,
    TResult? Function(AccountDeletionNetworkError value)? networkError,
  }) {
    final _that = this;
    switch (_that) {
      case AccountDeletionSuccess() when success != null:
        return success(_that);
      case AccountDeletionReauthRequired() when reauthRequired != null:
        return reauthRequired(_that);
      case AccountDeletionReauthInvalid() when reauthInvalid != null:
        return reauthInvalid(_that);
      case AccountDeletionNetworkError() when networkError != null:
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
    TResult Function()? success,
    TResult Function()? reauthRequired,
    TResult Function()? reauthInvalid,
    TResult Function()? networkError,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AccountDeletionSuccess() when success != null:
        return success();
      case AccountDeletionReauthRequired() when reauthRequired != null:
        return reauthRequired();
      case AccountDeletionReauthInvalid() when reauthInvalid != null:
        return reauthInvalid();
      case AccountDeletionNetworkError() when networkError != null:
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
    required TResult Function() success,
    required TResult Function() reauthRequired,
    required TResult Function() reauthInvalid,
    required TResult Function() networkError,
  }) {
    final _that = this;
    switch (_that) {
      case AccountDeletionSuccess():
        return success();
      case AccountDeletionReauthRequired():
        return reauthRequired();
      case AccountDeletionReauthInvalid():
        return reauthInvalid();
      case AccountDeletionNetworkError():
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
    TResult? Function()? success,
    TResult? Function()? reauthRequired,
    TResult? Function()? reauthInvalid,
    TResult? Function()? networkError,
  }) {
    final _that = this;
    switch (_that) {
      case AccountDeletionSuccess() when success != null:
        return success();
      case AccountDeletionReauthRequired() when reauthRequired != null:
        return reauthRequired();
      case AccountDeletionReauthInvalid() when reauthInvalid != null:
        return reauthInvalid();
      case AccountDeletionNetworkError() when networkError != null:
        return networkError();
      case _:
        return null;
    }
  }
}

/// @nodoc

class AccountDeletionSuccess implements AccountDeletionResult {
  const AccountDeletionSuccess();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AccountDeletionSuccess);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountDeletionResult.success()';
  }
}

/// @nodoc

class AccountDeletionReauthRequired implements AccountDeletionResult {
  const AccountDeletionReauthRequired();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountDeletionReauthRequired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountDeletionResult.reauthRequired()';
  }
}

/// @nodoc

class AccountDeletionReauthInvalid implements AccountDeletionResult {
  const AccountDeletionReauthInvalid();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountDeletionReauthInvalid);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountDeletionResult.reauthInvalid()';
  }
}

/// @nodoc

class AccountDeletionNetworkError implements AccountDeletionResult {
  const AccountDeletionNetworkError();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountDeletionNetworkError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AccountDeletionResult.networkError()';
  }
}

// dart format on
